import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:megacash/data/local/isar_database.dart';
import 'package:megacash/data/providers.dart';
import 'package:megacash/domain/models/bank.dart';
import 'package:megacash/domain/models/payment_card.dart';
import 'package:megacash/domain/models/selection.dart';

/// Список карт для интерфейса собирается из двух источников — карт и банков.
/// Если они разъедутся, экран «Мои карты» просто окажется пустым, без ошибки.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late Isar isar;
  late ProviderContainer container;
  var counter = 0;
  final dirs = <Directory>[];

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('megacash_providers');
    dirs.add(dir);
    isar = await IsarDatabase.openAt(
      directory: dir.path,
      instanceName: 'providers_${counter++}',
    );
    container = ProviderContainer(
      overrides: [isarProvider.overrideWithValue(isar)],
    );
  });

  tearDown(() => container.dispose());

  /// Держит список карт живым на время проверки.
  ///
  /// В Riverpod 3 провайдеры самоуничтожаются, как только на них никто не
  /// подписан, поэтому `read` без подписки успевает убить поток раньше,
  /// чем тот отдаст первое значение. В приложении подписчиком служит экран.
  void keepCardsAlive() {
    final sub = container.listen(cardsProvider, (_, _) {});
    addTearDown(sub.close);
  }

  tearDownAll(() {
    for (final d in dirs) {
      if (d.existsSync()) d.deleteSync(recursive: true);
    }
  });

  test('сохранённая карта попадает в список с названием банка', () async {
    await container.read(bankRepositoryProvider).save(
          const Bank(id: 'b1', name: 'Т-Банк', colorValue: 0xFF1C1C1E),
        );
    await container.read(cardRepositoryProvider).save(
          const PaymentCard(
            id: 'c1',
            bankId: 'b1',
            productName: 'Black',
            baseRate: 1,
            slotLimit: 4,
          ),
        );

    keepCardsAlive();
    final list = await container.read(cardsProvider.future);

    expect(list, hasLength(1));
    expect(list.single.bankName, 'Т-Банк');
    expect(list.single.card.productName, 'Black');
    expect(list.single.colorValue, 0xFF1C1C1E);
  });

  test('карта без своего банка не показывается', () async {
    await container.read(cardRepositoryProvider).save(
          const PaymentCard(
            id: 'c1',
            bankId: 'потерянный',
            productName: 'Black',
            baseRate: 1,
            slotLimit: 4,
          ),
        );

    keepCardsAlive();
    expect(await container.read(cardsProvider.future), isEmpty);
  });

  test('список обновляется после добавления карты', () async {
    keepCardsAlive();
    expect(await container.read(cardsProvider.future), isEmpty);

    await container.read(bankRepositoryProvider).save(
          const Bank(id: 'b1', name: 'Сбербанк', colorValue: 0xFF21A038),
        );
    await container.read(cardRepositoryProvider).save(
          const PaymentCard(
            id: 'c1',
            bankId: 'b1',
            productName: 'СберКарта',
            baseRate: 1,
            slotLimit: 3,
          ),
        );

    // Поток Isar доставляет изменение своим ходом — даём ему дойти.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final list = await container.read(cardsProvider.future);
    expect(list, hasLength(1));
    expect(list.single.bankName, 'Сбербанк');
  });

  test('веса категорий: справочник плюс накопленное пользователем', () async {
    final defaults = await container
        .read(categoryDictionaryProvider)
        .defaultWeights();
    expect(defaults['supermarkets'], 10);

    await container
        .read(weightRepositoryProvider)
        .promote('supermarkets', defaultWeight: 10);

    container.invalidate(weightsProvider);
    final merged = await container.read(weightsProvider.future);

    expect(merged['supermarkets'], closeTo(15, 0.001));
    // Категория, которую пользователь не трогал, остаётся со справочным весом.
    expect(merged['cafe'], 7);
  });

  test('счётчик выбранных категорий раскладывается по картам', () async {
    final selections = container.read(selectionRepositoryProvider);
    await selections.saveAll(const [
      Selection(
        id: 's1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'supermarkets',
        status: SelectionStatus.recommended,
      ),
      Selection(
        id: 's2',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'pharmacy',
        status: SelectionStatus.recommended,
      ),
      Selection(
        id: 's3',
        cardId: 'c2',
        monthKey: '2026-07',
        categoryId: 'cafe',
        status: SelectionStatus.recommended,
      ),
    ]);

    final counts =
        await container.read(selectionCountProvider('2026-07').future);
    expect(counts['c1'], 2);
    expect(counts['c2'], 1);
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:megacash/data/local/isar_database.dart';
import 'package:megacash/data/local/isar_repositories.dart';
import 'package:megacash/domain/models/bank.dart';
import 'package:megacash/domain/models/category_weight.dart';
import 'package:megacash/domain/models/monthly_offer.dart';
import 'package:megacash/domain/models/payment_card.dart';
import 'package:megacash/domain/models/selection.dart';

/// Проверяет, что данные переживают закрытие базы и что удаление карты
/// уносит за собой её предложения и выборы.
void main() {
  late Directory dir;
  late Isar isar;
  var counter = 0;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('megacash_test');
    isar = await IsarDatabase.openAt(
      directory: dir.path,
      instanceName: 'test_${counter++}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  test('карта сохраняется и читается обратно', () async {
    final banks = IsarBankRepository(isar);
    final cards = IsarCardRepository(isar);

    await banks.save(
      const Bank(id: 'b1', name: 'Т-Банк', colorValue: 0xFF1C1C1E),
    );
    await cards.save(
      const PaymentCard(
        id: 'c1',
        bankId: 'b1',
        productName: 'Black',
        baseRate: 1,
        slotLimit: 4,
      ),
    );

    final loaded = await cards.byId('c1');
    expect(loaded, isNotNull);
    expect(loaded!.productName, 'Black');
    expect(loaded.slotLimit, 4);
    expect((await banks.byId('b1'))!.name, 'Т-Банк');
  });

  test('повторное сохранение обновляет запись, а не плодит дубли', () async {
    final cards = IsarCardRepository(isar);
    const card = PaymentCard(
      id: 'c1',
      bankId: 'b1',
      productName: 'Black',
      baseRate: 1,
      slotLimit: 3,
    );

    await cards.save(card);
    await cards.save(card.copyWith(productName: 'Black Premium'));

    final all = await cards.all();
    expect(all, hasLength(1));
    expect(all.single.productName, 'Black Premium');
  });

  test('maxBaseRate возвращает наибольший базовый процент', () async {
    final cards = IsarCardRepository(isar);
    expect(await cards.maxBaseRate(), 0, reason: 'без карт базовой ставки нет');

    await cards.save(
      const PaymentCard(
        id: 'c1',
        bankId: 'b1',
        productName: 'A',
        baseRate: 1,
        slotLimit: 3,
      ),
    );
    await cards.save(
      const PaymentCard(
        id: 'c2',
        bankId: 'b2',
        productName: 'B',
        baseRate: 1.5,
        slotLimit: 3,
      ),
    );

    expect(await cards.maxBaseRate(), 1.5);
  });

  test('удаление карты уносит её предложения и выборы', () async {
    final cards = IsarCardRepository(isar);
    final offers = IsarOfferRepository(isar);
    final selections = IsarSelectionRepository(isar);

    await cards.save(
      const PaymentCard(
        id: 'c1',
        bankId: 'b1',
        productName: 'Black',
        baseRate: 1,
        slotLimit: 3,
      ),
    );
    await offers.saveAll([
      const MonthlyOffer(
        id: 'o1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'supermarkets',
        rate: 5,
        source: OfferSource.manual,
      ),
      const MonthlyOffer(
        id: 'o2',
        cardId: 'c2',
        monthKey: '2026-07',
        categoryId: 'cafe',
        rate: 7,
        source: OfferSource.manual,
      ),
    ]);
    await selections.saveAll([
      const Selection(
        id: 's1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'supermarkets',
        status: SelectionStatus.recommended,
      ),
    ]);

    await cards.delete('c1');

    expect(await cards.all(), isEmpty);
    final left = await offers.forMonth('2026-07');
    expect(left, hasLength(1), reason: 'чужие предложения не трогаем');
    expect(left.single.cardId, 'c2');
    expect(await selections.forMonth('2026-07'), isEmpty);
  });

  test('предложения разделены по месяцам, latestMonthKey берёт свежий',
      () async {
    final offers = IsarOfferRepository(isar);

    await offers.saveAll([
      const MonthlyOffer(
        id: 'o1',
        cardId: 'c1',
        monthKey: '2026-06',
        categoryId: 'cafe',
        rate: 7,
        source: OfferSource.ocr,
        confidence: 0.9,
      ),
      const MonthlyOffer(
        id: 'o2',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'cafe',
        rate: 5,
        source: OfferSource.ocr,
        confidence: 0.5,
      ),
    ]);

    expect(await offers.latestMonthKey(), '2026-07');
    expect(await offers.forMonth('2026-06'), hasLength(1));

    // Прошлые месяцы не удаляются: по ним считаются веса.
    await offers.clearMonth('2026-07');
    expect(await offers.forMonth('2026-07'), isEmpty);
    expect(await offers.forMonth('2026-06'), hasLength(1));
  });

  test('низкая уверенность помечает предложение к проверке', () async {
    final offers = IsarOfferRepository(isar);
    await offers.saveAll([
      const MonthlyOffer(
        id: 'o1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'jewelry',
        rate: 9,
        source: OfferSource.ocr,
        confidence: 0.55,
      ),
    ]);

    final loaded = (await offers.forMonth('2026-07')).single;
    expect(loaded.needsReview, isTrue);
    expect(loaded.source, OfferSource.ocr);
  });

  test('replaceMonth заменяет набор выборов целиком', () async {
    final selections = IsarSelectionRepository(isar);

    await selections.replaceMonth('2026-07', [
      const Selection(
        id: 's1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'supermarkets',
        status: SelectionStatus.recommended,
      ),
    ]);
    await selections.replaceMonth('2026-07', [
      const Selection(
        id: 's2',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'cafe',
        status: SelectionStatus.userChosen,
      ),
    ]);

    final left = await selections.forMonth('2026-07');
    expect(left, hasLength(1));
    expect(left.single.categoryId, 'cafe');
    expect(left.single.status, SelectionStatus.userChosen);
  });

  test('три статуса выбора различаются и сохраняются', () async {
    final selections = IsarSelectionRepository(isar);
    await selections.saveAll([
      const Selection(
        id: 's1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'a',
        status: SelectionStatus.recommended,
      ),
    ]);

    await selections.updateStatus('s1', SelectionStatus.activated);
    expect(
      (await selections.forMonth('2026-07')).single.status,
      SelectionStatus.activated,
    );
  });

  test('вес растёт и падает, не выходя за границы', () async {
    final weights = IsarWeightRepository(isar);

    await weights.promote('supermarkets', defaultWeight: 10);
    expect((await weights.all())['supermarkets'], closeTo(15, 0.001));

    await weights.demote('supermarkets', defaultWeight: 10);
    expect((await weights.all())['supermarkets'], closeTo(10.5, 0.001));

    // Потолок 30: сколько ни повышай, выше не уйдёт.
    for (var i = 0; i < 20; i++) {
      await weights.promote('supermarkets', defaultWeight: 10);
    }
    expect((await weights.all())['supermarkets'], CategoryWeight.maxWeight);

    // Пол 0.1.
    for (var i = 0; i < 60; i++) {
      await weights.demote('supermarkets', defaultWeight: 10);
    }
    expect((await weights.all())['supermarkets'], CategoryWeight.minWeight);
  });

  test('вес новой категории отсчитывается от значения из справочника',
      () async {
    final weights = IsarWeightRepository(isar);
    await weights.demote('flowers', defaultWeight: 0.5);
    expect((await weights.all())['flowers'], closeTo(0.35, 0.001));
  });

  test('данные переживают закрытие и повторное открытие базы', () async {
    final name = isar.name;
    await IsarCardRepository(isar).save(
      const PaymentCard(
        id: 'c1',
        bankId: 'b1',
        productName: 'Black',
        baseRate: 1,
        slotLimit: 3,
      ),
    );

    await isar.close();
    isar = await IsarDatabase.openAt(directory: dir.path, instanceName: name);

    final reopened = await IsarCardRepository(isar).all();
    expect(reopened, hasLength(1));
    expect(reopened.single.productName, 'Black');
  });
}

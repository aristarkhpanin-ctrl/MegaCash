import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/core/theme/app_theme.dart';
import 'package:megacash/data/providers.dart';
import 'package:megacash/data/remote/category_dictionary_impl.dart';
import 'package:megacash/domain/models/category.dart';
import 'package:megacash/domain/models/monthly_offer.dart';
import 'package:megacash/domain/models/payment_card.dart';
import 'package:megacash/domain/ocr/recognition_service.dart';
import 'package:megacash/features/setup/review_screen.dart';
import 'package:megacash/features/setup/setup_controller.dart';

/// Экран проверки Б4 без базы и без движка распознавания.
///
/// Разбор скриншотов проверяется на расшифровках, полный путь настройки —
/// в дымовом тесте. Здесь нужна одна вещь: что несопоставленную строку
/// человек может отнести к категории, а не только выбросить. Поднимать
/// ради этого Isar и распознавание — значит проверять всё, кроме того,
/// что проверяется.
class _SeededSetupController extends SetupController {
  _SeededSetupController(this.initial);

  final SetupState initial;

  @override
  SetupState build() => initial;
}

void main() {
  late List<Category> categories;

  setUpAll(() async {
    categories = await BundledCategoryDictionary().all();
  });

  const card = PaymentCard(
    id: 'card-1',
    bankId: 'tbank',
    productName: 'Black',
    baseRate: 1,
    slotLimit: 4,
  );

  const rivGosh = UnmatchedOffer(
    rawName: 'РИВ ГОШ',
    rate: 5,
    cardId: 'card-1',
  );

  Future<void> pumpReview(
    WidgetTester tester, {
    required SetupState state,
  }) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWithValue(categories),
          setupControllerProvider
              .overrideWith(() => _SeededSetupController(state)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ReviewScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  SetupState read(WidgetTester tester) => ProviderScope.containerOf(
        tester.element(find.byType(ReviewScreen)),
      ).read(setupControllerProvider);

  testWidgets('Несопоставленную строку можно отнести к категории',
      (tester) async {
    await pumpReview(
      tester,
      state: const SetupState(cards: [card], unmatched: [rivGosh]),
    );

    expect(find.text('НЕ НАШЛОСЬ В СПРАВОЧНИКЕ'), findsOneWidget);
    expect(find.text('РИВ ГОШ'), findsOneWidget);

    await tester.tap(find.text('РИВ ГОШ'));
    await tester.pumpAndSettle();

    // В шапке выбора видно, что именно разбираем.
    expect(find.text('5% · РИВ ГОШ'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'красот');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Красота и уход'));
    await tester.pumpAndSettle();

    final state = read(tester);
    expect(state.unmatched, isEmpty, reason: 'строка разобрана');
    expect(state.offers, hasLength(1));

    final offer = state.offers.single;
    expect(offer.cardId, 'card-1', reason: 'карта берётся из скриншота');
    expect(offer.categoryId, 'beauty');
    expect(offer.rate, 5, reason: 'процент берётся из распознанного');
    expect(offer.source, OfferSource.manual);

    // Разобранная строка ушла из списка, а счётчик распознанного вырос.
    expect(find.text('РИВ ГОШ'), findsNothing);
    expect(find.text('НЕ НАШЛОСЬ В СПРАВОЧНИКЕ'), findsNothing);
  });

  testWidgets('Условие предложения переезжает в назначенную категорию',
      (tester) async {
    await pumpReview(
      tester,
      state: const SetupState(
        cards: [card],
        unmatched: [
          UnmatchedOffer(
            rawName: 'Lamoda',
            rate: 10,
            cardId: 'card-1',
            note: 'Только в приложении',
          ),
        ],
      ),
    );

    expect(find.text('Только в приложении'), findsOneWidget);

    await tester.tap(find.text('Lamoda'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'одежд');
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Одежда').last);
    await tester.pumpAndSettle();

    expect(read(tester).offers.single.note, 'Только в приложении');
  });

  testWidgets('Выбор категории можно отменить — строка остаётся',
      (tester) async {
    await pumpReview(
      tester,
      state: const SetupState(cards: [card], unmatched: [rivGosh]),
    );

    await tester.tap(find.text('РИВ ГОШ'));
    await tester.pumpAndSettle();

    // Закрываем выбор, ничего не выбрав.
    Navigator.of(tester.element(find.byType(ReviewScreen))).pop();
    await tester.pumpAndSettle();

    final state = read(tester);
    expect(state.unmatched, hasLength(1));
    expect(state.offers, isEmpty);
  });

  testWidgets('Ненужную строку по-прежнему можно убрать крестиком',
      (tester) async {
    await pumpReview(
      tester,
      state: const SetupState(cards: [card], unmatched: [rivGosh]),
    );

    await tester.tap(find.byTooltip('Убрать'));
    await tester.pumpAndSettle();

    final state = read(tester);
    expect(state.unmatched, isEmpty);
    expect(state.offers, isEmpty, reason: 'выброшенное не попадает в подбор');
  });

  testWidgets('Один магазин у двух карт — две отдельные строки',
      (tester) async {
    await pumpReview(
      tester,
      state: const SetupState(
        cards: [
          card,
          PaymentCard(
            id: 'card-2',
            bankId: 'alfa',
            productName: 'Альфа-Карта',
            baseRate: 1,
            slotLimit: 4,
          ),
        ],
        unmatched: [
          UnmatchedOffer(rawName: 'Lamoda', rate: 10, cardId: 'card-1'),
          UnmatchedOffer(rawName: 'Lamoda', rate: 10, cardId: 'card-2'),
        ],
      ),
    );

    expect(find.text('Lamoda'), findsNWidgets(2));

    // Разбор одной строки не должен уносить с собой чужую: это разные
    // предложения разных банков, просто с одинаковым названием.
    await tester.tap(find.text('Lamoda').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'одежд');
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Одежда').last);
    await tester.pumpAndSettle();

    final state = read(tester);
    expect(state.offers.single.cardId, 'card-1');
    expect(state.unmatched.single.cardId, 'card-2');
    expect(find.text('Lamoda'), findsOneWidget);
  });
}

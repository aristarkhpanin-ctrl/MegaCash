import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/domain/answer/payment_answer.dart';
import 'package:megacash/domain/models/bank.dart';
import 'package:megacash/domain/models/monthly_offer.dart';
import 'package:megacash/domain/models/payment_card.dart';
import 'package:megacash/domain/models/selection.dart';

/// Ответ на вопрос «какой картой платить» человек читает у кассы за секунду
/// и действует по нему не задумываясь. Ошибка здесь стоит ему денег.
void main() {
  const banks = {
    'b_sber': Bank(id: 'b_sber', name: 'Сбербанк', colorValue: 0xFF21A038),
    'b_alfa': Bank(id: 'b_alfa', name: 'Альфа-Банк', colorValue: 0xFFEF3124),
    'b_tb': Bank(id: 'b_tb', name: 'Т-Банк', colorValue: 0xFF1C1C1E),
  };

  PaymentCard card(String id, String bankId, double base) => PaymentCard(
        id: id,
        bankId: bankId,
        productName: 'Карта',
        baseRate: base,
        slotLimit: 3,
      );

  MonthlyOffer offer(String cardId, String categoryId, double rate) =>
      MonthlyOffer(
        id: '$cardId-$categoryId',
        cardId: cardId,
        monthKey: '2026-07',
        categoryId: categoryId,
        rate: rate,
        source: OfferSource.manual,
      );

  Selection selection(String cardId, String categoryId) => Selection(
        id: '$cardId-$categoryId',
        cardId: cardId,
        monthKey: '2026-07',
        categoryId: categoryId,
        status: SelectionStatus.userChosen,
      );

  PaymentAnswer build({
    required List<PaymentCard> cards,
    List<Selection> selections = const [],
    List<MonthlyOffer> offers = const [],
    String categoryId = 'supermarkets',
  }) =>
      buildPaymentAnswer(
        categoryId: categoryId,
        categoryName: 'Супермаркеты',
        cards: cards,
        banksById: banks,
        selections: selections,
        offers: offers,
      );

  test('победитель — карта с выбранной категорией', () {
    final answer = build(
      cards: [
        card('sber', 'b_sber', 1),
        card('alfa', 'b_alfa', 1),
        card('tb', 'b_tb', 1),
      ],
      selections: [selection('sber', 'supermarkets')],
      offers: [offer('sber', 'supermarkets', 5)],
    );

    expect(answer.best!.bankName, 'Сбербанк');
    expect(answer.best!.rate, 5);
    expect(answer.best!.elevated, isTrue);
    expect(answer.noElevated, isFalse);
    expect(answer.others, hasLength(2));
  });

  /// Главная ловушка: предложение банка и выбранная категория — разные вещи.
  /// Повышенный процент действует только там, где категория включена.
  test('чужие предложения по этой же категории не считаются действующими',
      () {
    final answer = build(
      cards: [card('sber', 'b_sber', 1), card('alfa', 'b_alfa', 1)],
      selections: [selection('sber', 'supermarkets')],
      offers: [
        offer('sber', 'supermarkets', 5),
        // Альфа тоже предлагает супермаркеты, но категория там не выбрана —
        // значит вернётся базовый процент, а не 7%.
        offer('alfa', 'supermarkets', 7),
      ],
    );

    expect(answer.best!.bankName, 'Сбербанк');
    expect(answer.best!.rate, 5);

    final alfa = answer.others.single;
    expect(alfa.bankName, 'Альфа-Банк');
    expect(alfa.rate, 1, reason: 'категория в Альфе не выбрана');
    expect(alfa.elevated, isFalse);
  });

  test('высокий базовый процент обходит слабую выбранную категорию', () {
    // У Т-Банка выбраны супермаркеты под 3%, но Альфа даёт 5% на всё.
    final answer = build(
      cards: [card('tb', 'b_tb', 1), card('alfa', 'b_alfa', 5)],
      selections: [selection('tb', 'supermarkets')],
      offers: [offer('tb', 'supermarkets', 3)],
    );

    expect(answer.best!.bankName, 'Альфа-Банк');
    expect(answer.best!.rate, 5);
    expect(answer.best!.elevated, isFalse);
    expect(
      answer.noElevated,
      isTrue,
      reason: 'лучшая карта даёт базовый процент — так и говорим',
    );
  });

  test('без выбранных категорий показываем лучший базовый', () {
    final answer = build(
      cards: [
        card('sber', 'b_sber', 1),
        card('alfa', 'b_alfa', 1.5),
        card('tb', 'b_tb', 1),
      ],
    );

    expect(answer.noElevated, isTrue);
    expect(answer.best!.bankName, 'Альфа-Банк');
    expect(answer.best!.rate, 1.5);
    expect(answer.others, hasLength(2));
  });

  test('остальные карты идут по убыванию процента', () {
    final answer = build(
      cards: [
        card('sber', 'b_sber', 1),
        card('alfa', 'b_alfa', 3),
        card('tb', 'b_tb', 2),
      ],
    );

    expect(
      answer.others.map((o) => o.rate).toList(),
      [2, 1],
    );
  });

  test('при равных процентах вперёд идёт карта с выбранной категорией', () {
    final answer = build(
      cards: [card('sber', 'b_sber', 1), card('alfa', 'b_alfa', 5)],
      selections: [selection('sber', 'supermarkets')],
      offers: [offer('sber', 'supermarkets', 5)],
    );

    expect(answer.best!.bankName, 'Сбербанк');
    expect(answer.best!.elevated, isTrue);
  });

  test('выбор в другой категории на ответ не влияет', () {
    final answer = build(
      cards: [card('sber', 'b_sber', 1), card('alfa', 'b_alfa', 1)],
      selections: [selection('sber', 'cafe')],
      offers: [offer('sber', 'cafe', 7)],
    );

    expect(answer.noElevated, isTrue);
    expect(answer.best!.rate, 1);
  });

  test('нет карт — ответа нет', () {
    final answer = build(cards: const []);
    expect(answer.isEmpty, isTrue);
    expect(answer.best, isNull);
  });

  test('карта без своего банка пропускается', () {
    final answer = build(
      cards: [
        card('sber', 'b_sber', 1),
        card('ghost', 'удалённый_банк', 9),
      ],
    );

    expect(answer.best!.bankName, 'Сбербанк');
    expect(answer.others, isEmpty);
  });

  test('выбранная категория без предложения даёт базовый процент', () {
    // Такое возможно, если предложения месяца перезагрузили, а выбор остался.
    final answer = build(
      cards: [card('sber', 'b_sber', 1)],
      selections: [selection('sber', 'supermarkets')],
      offers: const [],
    );

    expect(answer.best!.rate, 1);
    expect(answer.best!.elevated, isFalse);
    expect(answer.noElevated, isTrue);
  });
}

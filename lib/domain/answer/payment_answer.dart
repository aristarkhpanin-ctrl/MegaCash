import '../models/bank.dart';
import '../models/monthly_offer.dart';
import '../models/payment_card.dart';
import '../models/selection.dart';

/// Одна карта в ответе на вопрос «чем платить».
class PaymentOption {
  const PaymentOption({
    required this.cardId,
    required this.bankName,
    required this.productName,
    required this.bankColor,
    required this.rate,
    required this.elevated,
  });

  final String cardId;
  final String bankName;
  final String productName;
  final int bankColor;

  /// Сколько реально вернётся по этой карте в этой категории.
  final double rate;

  /// Процент повышенный, то есть категория в этом банке выбрана.
  /// Иначе это базовая ставка карты.
  final bool elevated;
}

/// Ответ на вопрос «какой картой платить».
class PaymentAnswer {
  const PaymentAnswer({
    required this.categoryId,
    required this.categoryName,
    required this.best,
    required this.others,
  });

  final String categoryId;
  final String categoryName;

  /// Карта с наибольшим процентом. Отсутствует, только если карт нет вовсе.
  final PaymentOption? best;

  /// Остальные карты, по убыванию процента.
  final List<PaymentOption> others;

  /// Ни одна карта не даёт повышенный процент — показываем подсказку
  /// и карту с лучшим базовым.
  bool get noElevated => best != null && !best!.elevated;

  bool get isEmpty => best == null;
}

/// Собирает ответ по данным месяца.
///
/// Ключевая тонкость: повышенный процент действует только там, где категория
/// выбрана. Если три банка предлагают супермаркеты, а выбраны они в одном —
/// в остальных двух вернётся базовая ставка, и показывать их предложения
/// как действующие нельзя, человек рассчитывал бы на деньги, которых не будет.
///
/// Поэтому победитель определяется не по предложениям, а по тому, что реально
/// вернётся: у карты с выбранной категорией — её процент, у всех
/// остальных — базовый.
PaymentAnswer buildPaymentAnswer({
  required String categoryId,
  required String categoryName,
  required List<PaymentCard> cards,
  required Map<String, Bank> banksById,
  required List<Selection> selections,
  required List<MonthlyOffer> offers,
}) {
  if (cards.isEmpty) {
    return PaymentAnswer(
      categoryId: categoryId,
      categoryName: categoryName,
      best: null,
      others: const [],
    );
  }

  // Карта, в которой эта категория выбрана. По правилам она может быть
  // только одна, но на всякий случай берём первую.
  final chosen = selections
      .where((s) => s.categoryId == categoryId)
      .map((s) => s.cardId)
      .firstOrNull;

  double? elevatedRate;
  if (chosen != null) {
    elevatedRate = offers
        .where((o) => o.cardId == chosen && o.categoryId == categoryId)
        .map((o) => o.rate)
        .firstOrNull;
  }

  final options = <PaymentOption>[];
  for (final card in cards) {
    final bank = banksById[card.bankId];
    if (bank == null) continue;

    final isChosen = card.id == chosen && elevatedRate != null;
    options.add(
      PaymentOption(
        cardId: card.id,
        bankName: bank.name,
        productName: card.productName,
        bankColor: bank.colorValue,
        rate: isChosen ? elevatedRate : card.baseRate,
        elevated: isChosen,
      ),
    );
  }

  if (options.isEmpty) {
    return PaymentAnswer(
      categoryId: categoryId,
      categoryName: categoryName,
      best: null,
      others: const [],
    );
  }

  // Повышенная ставка не обязана быть лучшей: карта с базовыми 5% выгоднее
  // карты с выбранной категорией под 3%. Сравниваем по тому, что вернётся.
  options.sort((a, b) {
    final byRate = b.rate.compareTo(a.rate);
    if (byRate != 0) return byRate;
    // При равных процентах вперёд идёт карта с выбранной категорией:
    // её процент подтверждён, а базовый может измениться.
    if (a.elevated != b.elevated) return a.elevated ? -1 : 1;
    return a.bankName.compareTo(b.bankName);
  });

  return PaymentAnswer(
    categoryId: categoryId,
    categoryName: categoryName,
    best: options.first,
    others: options.sublist(1),
  );
}

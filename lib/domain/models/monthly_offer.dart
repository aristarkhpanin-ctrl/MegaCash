/// Откуда взялось предложение.
enum OfferSource {
  /// Распознано со скриншота.
  ocr,

  /// Введено пользователем руками.
  manual,
}

/// Предложение банка на конкретный месяц: «в этой карте эта категория
/// доступна под такой процент».
///
/// Категории и ставки персональны для каждого клиента банка. Общего
/// справочника предложений не существует и быть не может — поэтому
/// предложения всегда привязаны к карте и месяцу.
class MonthlyOffer {
  const MonthlyOffer({
    required this.id,
    required this.cardId,
    required this.monthKey,
    required this.categoryId,
    required this.rate,
    required this.source,
    this.confidence = 1,
  });

  final String id;
  final String cardId;

  /// Месяц в виде «2026-07».
  final String monthKey;

  final String categoryId;

  /// Процент кэшбэка по этому предложению.
  final double rate;

  final OfferSource source;

  /// 0..1 — насколько уверенно распознано. Для введённых руками всегда 1.
  /// Ниже 0.7 предложение показывается пользователю на проверку.
  final double confidence;

  /// Порог, ниже которого распознанное не принимается на веру.
  static const double confidenceThreshold = 0.7;

  bool get needsReview =>
      source == OfferSource.ocr && confidence < confidenceThreshold;

  MonthlyOffer copyWith({
    String? id,
    String? cardId,
    String? monthKey,
    String? categoryId,
    double? rate,
    OfferSource? source,
    double? confidence,
  }) =>
      MonthlyOffer(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        monthKey: monthKey ?? this.monthKey,
        categoryId: categoryId ?? this.categoryId,
        rate: rate ?? this.rate,
        source: source ?? this.source,
        confidence: confidence ?? this.confidence,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyOffer &&
          other.id == id &&
          other.cardId == cardId &&
          other.monthKey == monthKey &&
          other.categoryId == categoryId &&
          other.rate == rate &&
          other.source == source &&
          other.confidence == confidence;

  @override
  int get hashCode =>
      Object.hash(id, cardId, monthKey, categoryId, rate, source, confidence);

  @override
  String toString() =>
      'MonthlyOffer($categoryId $rate% на $cardId, $monthKey)';
}

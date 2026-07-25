/// Назначение категории на карту.
class Assignment {
  const Assignment({
    required this.cardId,
    required this.categoryId,
    required this.rate,
    this.benefit = 0,
  });

  final String cardId;
  final String categoryId;
  final double rate;

  /// Прирост выгоды сверх базовой ставки: `вес × (ставка − базовая)`.
  final double benefit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Assignment &&
          other.cardId == cardId &&
          other.categoryId == categoryId;

  @override
  int get hashCode => Object.hash(cardId, categoryId);

  @override
  String toString() => 'Assignment($categoryId → $cardId, $rate%)';
}

/// Почему категория не попала в выбранные.
///
/// Причина хранится кодом, а не готовой фразой: человек должен понимать
/// логику, а формулировка — забота интерфейса, там она собирается
/// с названиями конкретных банков и процентов.
enum RejectionReason {
  /// Процент не выше базового — брать такую категорию бессмысленно,
  /// столько же вернётся и без неё.
  rateNotAboveBase,

  /// Категория уже выбрана в другом банке под больший процент.
  /// В магазине человек платит один раз и одной картой, поэтому второй
  /// и третий слоты на ту же категорию просто сгорают.
  takenByAnotherCard,

  /// У этой карты все слоты заняты более выгодными категориями.
  cardSlotsFull,

  /// Карта отдана под «все покупки» — остальные её слоты не занимаются.
  cardTakenByAllPurchases,

  /// Пользователь отправил категорию в «Не выбранные».
  excludedByUser,
}

/// Отклонённое предложение с причиной.
class Rejection {
  const Rejection({
    required this.cardId,
    required this.categoryId,
    required this.rate,
    required this.reason,
    this.takenByCardId,
  });

  final String cardId;
  final String categoryId;
  final double rate;
  final RejectionReason reason;

  /// Для [RejectionReason.takenByAnotherCard] — карта, которой досталась
  /// категория. Нужна, чтобы объяснить пользователю причину по-человечески.
  final String? takenByCardId;

  @override
  String toString() => 'Rejection($categoryId на $cardId, $rate%, $reason)';
}

/// Результат подбора.
class OptimizationResult {
  const OptimizationResult({
    required this.selected,
    required this.rejected,
    required this.freeSlots,
  });

  const OptimizationResult.empty()
      : selected = const [],
        rejected = const [],
        freeSlots = const [];

  /// Что выбрать в каком банке.
  final List<Assignment> selected;

  /// Что не попало в выбранные и почему.
  final List<Rejection> rejected;

  /// Слоты, которые нечем заполнить: по одному вхождению `cardId`
  /// на каждый свободный слот этой карты.
  final List<String> freeSlots;

  /// Суммарный прирост выгоды по всем выбранным.
  double get totalBenefit =>
      selected.fold(0, (sum, a) => sum + a.benefit);

  /// Сколько слотов занято у каждой карты.
  Map<String, int> get occupiedByCard {
    final counts = <String, int>{};
    for (final a in selected) {
      counts[a.cardId] = (counts[a.cardId] ?? 0) + 1;
    }
    return counts;
  }

  @override
  String toString() => 'OptimizationResult(выбрано ${selected.length}, '
      'отклонено ${rejected.length}, свободно ${freeSlots.length})';
}

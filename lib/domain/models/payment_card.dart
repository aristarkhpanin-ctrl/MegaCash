/// Банковская карта пользователя.
///
/// В техзадании сущность названа `Card`. Здесь она `PaymentCard`, потому что
/// `Card` — это виджет Flutter: во всех файлах интерфейса пришлось бы
/// разводить их префиксами импорта. Смысл и поля не изменились.
///
/// Несколько карт одного банка в первой версии не поддерживаются.
class PaymentCard {
  const PaymentCard({
    required this.id,
    required this.bankId,
    required this.productName,
    required this.baseRate,
    required this.slotLimit,
  });

  final String id;
  final String bankId;

  /// «Black», «Alfa Travel» — как карта называется в приложении банка.
  final String productName;

  /// Базовый кэшбэк на всё, в процентах. Именно от него считается прирост:
  /// оптимизировать надо выгоду сверх базовой, а не саму ставку.
  final double baseRate;

  /// Сколько категорий можно выбрать в этом банке за месяц.
  final int slotLimit;

  PaymentCard copyWith({
    String? id,
    String? bankId,
    String? productName,
    double? baseRate,
    int? slotLimit,
  }) =>
      PaymentCard(
        id: id ?? this.id,
        bankId: bankId ?? this.bankId,
        productName: productName ?? this.productName,
        baseRate: baseRate ?? this.baseRate,
        slotLimit: slotLimit ?? this.slotLimit,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentCard &&
          other.id == id &&
          other.bankId == bankId &&
          other.productName == productName &&
          other.baseRate == baseRate &&
          other.slotLimit == slotLimit;

  @override
  int get hashCode =>
      Object.hash(id, bankId, productName, baseRate, slotLimit);

  @override
  String toString() => 'PaymentCard($id, $productName, база $baseRate%, '
      'слотов $slotLimit)';
}

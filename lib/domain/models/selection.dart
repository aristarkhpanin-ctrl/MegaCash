/// Три разных состояния выбора. Путать их нельзя: одно дело — что предложил
/// алгоритм, другое — что выбрал пользователь, третье — что он реально
/// включил в приложении банка.
enum SelectionStatus {
  /// Предложено оптимизатором.
  recommended,

  /// Пользователь подтвердил или перебросил вручную.
  userChosen,

  /// Пользователь отметил, что включил категорию в банке.
  activated,
}

/// Выбранная на месяц категория в конкретной карте.
class Selection {
  const Selection({
    required this.id,
    required this.cardId,
    required this.monthKey,
    required this.categoryId,
    required this.status,
  });

  final String id;
  final String cardId;
  final String monthKey;
  final String categoryId;
  final SelectionStatus status;

  Selection copyWith({
    String? id,
    String? cardId,
    String? monthKey,
    String? categoryId,
    SelectionStatus? status,
  }) =>
      Selection(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        monthKey: monthKey ?? this.monthKey,
        categoryId: categoryId ?? this.categoryId,
        status: status ?? this.status,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Selection &&
          other.id == id &&
          other.cardId == cardId &&
          other.monthKey == monthKey &&
          other.categoryId == categoryId &&
          other.status == status;

  @override
  int get hashCode => Object.hash(id, cardId, monthKey, categoryId, status);

  @override
  String toString() => 'Selection($categoryId на $cardId, $monthKey, $status)';
}

/// Вес категории — насколько она важна для конкретного пользователя.
///
/// Начальные значения зашиты в справочнике. Дальше уточняются сами, из
/// действий пользователя: забрал категорию в «Выбранные» — вес растёт,
/// отправил в «Не выбранные» — падает. Сохраняются между месяцами,
/// поэтому данные прошлых месяцев не удаляются.
class CategoryWeight {
  const CategoryWeight({
    required this.categoryId,
    required this.weight,
  });

  final String categoryId;
  final double weight;

  /// Множитель, когда пользователь забрал категорию в «Выбранные».
  static const double promoteFactor = 1.5;

  /// Множитель, когда пользователь отправил категорию в «Не выбранные».
  static const double demoteFactor = 0.7;

  static const double minWeight = 0.1;
  static const double maxWeight = 30;

  /// Применяет множитель, не выпуская вес за границы диапазона.
  CategoryWeight scaled(double factor) => CategoryWeight(
        categoryId: categoryId,
        weight: (weight * factor).clamp(minWeight, maxWeight),
      );

  CategoryWeight promoted() => scaled(promoteFactor);

  CategoryWeight demoted() => scaled(demoteFactor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryWeight &&
          other.categoryId == categoryId &&
          other.weight == weight;

  @override
  int get hashCode => Object.hash(categoryId, weight);

  @override
  String toString() => 'CategoryWeight($categoryId: $weight)';
}

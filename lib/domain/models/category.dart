/// Категория повышенного кэшбэка.
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.defaultWeight,
    this.synonyms = const [],
    this.matchesEverything = false,
  });

  /// Стабильный идентификатор: «supermarkets». Не меняется никогда —
  /// на него завязаны предложения, выборы и веса за все прошлые месяцы.
  final String id;

  /// Отображаемое название: «Супермаркеты». Пользователь может править.
  final String name;

  /// Начальный вес. Пользователя ни о чём не спрашиваем — веса выведены
  /// из публичных данных о структуре расходов и дальше уточняются сами.
  final double defaultWeight;

  /// Формулировки банков, по которым категория узнаётся при распознавании.
  final List<String> synonyms;

  /// «На все покупки» совпадает с любой тратой и потому пересекается
  /// со всеми остальными категориями сразу. Обычное назначение
  /// обрабатывает её неверно — оптимизатор разбирает её отдельной ветвью.
  final bool matchesEverything;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Category($id, $name, вес $defaultWeight)';
}

/// Форматирование процентов.
///
/// Дробная часть отделяется запятой — так в русской типографике и так это
/// сделано в макетах. Целые значения показываются без хвоста: «5%», а не «5,0%».
abstract final class Percent {
  static String format(double value) {
    if (value == value.roundToDouble()) return '${value.round()}%';
    final text = value.toStringAsFixed(1).replaceAll('.', ',');
    return '$text%';
  }

  /// Без знака процента — когда знак рисуется отдельным элементом.
  static String bare(double value) {
    if (value == value.roundToDouble()) return '${value.round()}';
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }
}

/// Русские склонения при числительных.
///
/// Правило: 1, 21, 31 — единственное; 2–4, 22–24 — родительный единственного;
/// всё остальное, включая 11–14, — родительный множественного.
abstract final class Plural {
  static String pick(
    int n, {
    required String one,
    required String few,
    required String many,
  }) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return one;
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return few;
    return many;
  }

  static String categories(int n) =>
      '$n ${pick(n, one: 'категория', few: 'категории', many: 'категорий')}';

  static String activeCategories(int n) => '$n ${pick(
        n,
        one: 'активная категория',
        few: 'активные категории',
        many: 'активных категорий',
      )}';

  static String cards(int n) =>
      '$n ${pick(n, one: 'карта', few: 'карты', many: 'карт')}';

  static String screenshots(int n) =>
      '$n ${pick(n, one: 'скриншот', few: 'скриншота', many: 'скриншотов')}';

  static String slots(int n) =>
      '$n ${pick(n, one: 'слот', few: 'слота', many: 'слотов')}';
}

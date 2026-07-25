/// Работа с ключом месяца вида «2026-07».
///
/// Смена месяца определяется сравнением ключа последнего набора с текущим.
abstract final class MonthKey {
  /// Ключ для указанной даты.
  static String of(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';

  /// Ключ текущего месяца.
  static String current({DateTime? now}) => of(now ?? DateTime.now());

  /// Разбор ключа обратно в дату — первое число месяца.
  /// Возвращает null, если строка не похожа на ключ.
  static DateTime? parse(String key) {
    final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(key);
    if (match == null) return null;
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    if (month < 1 || month > 12) return null;
    return DateTime(year, month);
  }

  static const List<String> _nominative = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  static const List<String> _accusative = [
    'январь', 'февраль', 'март', 'апрель', 'май', 'июнь',
    'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь',
  ];

  /// Название месяца для заголовка экрана: «Июль».
  static String monthName(String key) {
    final date = parse(key);
    if (date == null) return key;
    return _nominative[date.month - 1];
  }

  /// Название в винительном падеже: «Настройка на июль».
  static String monthNameAccusative(String key) {
    final date = parse(key);
    if (date == null) return key;
    return _accusative[date.month - 1];
  }

  /// Следующий месяц после указанного ключа.
  static String next(String key) {
    final date = parse(key);
    if (date == null) return key;
    return of(DateTime(date.year, date.month + 1));
  }

  /// Предыдущий месяц.
  static String previous(String key) {
    final date = parse(key);
    if (date == null) return key;
    return of(DateTime(date.year, date.month - 1));
  }
}

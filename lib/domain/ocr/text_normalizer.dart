/// Приведение текста к виду, в котором его можно сравнивать со словарём.
abstract final class TextNormalizer {
  /// Ключ для сравнения: нижний регистр, «ё» как «е», без знаков препинания
  /// и лишних пробелов.
  ///
  /// «Кешбэк» и «кэшбэк» приводятся к одному виду: ВТБ пишет через «е»,
  /// остальные через «э», и на сопоставление это влиять не должно.
  static String key(String raw) {
    var s = raw.toLowerCase().replaceAll('ё', 'е');
    s = s.replaceAll('кешбэк', 'кэшбэк').replaceAll('кешбек', 'кэшбэк');
    s = s.replaceAll(_punctuation, ' ');
    return s.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).join(' ');
  }

  static final RegExp _punctuation = RegExp(r'''[.,;:!?()\[\]«»"'’“”/\\|]''');

  /// Расстояние Левенштейна.
  ///
  /// Нужно потому, что распознавание регулярно путает похожие буквы:
  /// «Супермаркеты» превращается в «Слермаркеты». Точное сравнение такую
  /// строку теряет, а человек потом ищет её глазами в списке из сорока.
  static int distance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    var previous = List<int>.generate(b.length + 1, (i) => i);
    var current = List<int>.filled(b.length + 1, 0);

    for (var i = 0; i < a.length; i++) {
      current[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
        final deletion = previous[j + 1] + 1;
        final insertion = current[j] + 1;
        final substitution = previous[j] + cost;
        current[j + 1] = deletion < insertion
            ? (deletion < substitution ? deletion : substitution)
            : (insertion < substitution ? insertion : substitution);
      }
      final swap = previous;
      previous = current;
      current = swap;
    }

    return previous[b.length];
  }

  /// Похожесть двух строк, 0..1.
  static double similarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1;
    final longest = a.length > b.length ? a.length : b.length;
    if (longest == 0) return 1;
    return 1 - distance(a, b) / longest;
  }
}

/// Запись о попытке распознавания.
///
/// Нужна не для отладки, а для продукта: строки, не найденные в словаре,
/// показываются пользователю для ручного выбора категории, а накопленный
/// список подсказывает, какие формулировки банков стоит добавить
/// в справочник синонимов.
class RecognitionLog {
  const RecognitionLog({
    required this.id,
    required this.at,
    required this.rawText,
    required this.foundCount,
    required this.unmatchedStrings,
  });

  final String id;
  final DateTime at;

  /// Весь текст, который вернул движок распознавания.
  final String rawText;

  /// Сколько пар «категория — процент» удалось извлечь.
  final int foundCount;

  /// Строки, не найденные в словаре синонимов.
  final List<String> unmatchedStrings;

  @override
  String toString() =>
      'RecognitionLog($at, найдено $foundCount, не опознано '
      '${unmatchedStrings.length})';
}

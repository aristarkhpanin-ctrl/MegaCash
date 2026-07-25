/// Одна распознанная строка.
class OcrLine {
  const OcrLine({required this.text, this.confidence = 1});

  final String text;

  /// Насколько движок уверен в этой строке, 0..1.
  final double confidence;

  @override
  String toString() => 'OcrLine("$text", ${confidence.toStringAsFixed(2)})';
}

/// Результат распознавания одного изображения.
class OcrPage {
  const OcrPage({required this.lines});

  const OcrPage.empty() : lines = const [];

  final List<OcrLine> lines;

  String get rawText => lines.map((l) => l.text).join('\n');

  bool get isEmpty => lines.isEmpty;
}

/// Движок распознавания текста.
///
/// За интерфейсом, потому что точно будет меняться: на Android и iOS
/// разные движки, а качество распознавания русского — вещь, которую
/// придётся подбирать.
///
/// Важное ограничение, определившее выбор: ML Kit от Google распознаёт
/// латиницу, китайский, деванагари, японский и корейский — кириллицы
/// среди них нет. Для русского приложения он не подходит вовсе.
abstract interface class OcrEngine {
  /// Готовит движок к работе: языковые модели, прогрев.
  Future<void> prepare();

  /// Распознаёт изображение по пути в файловой системе.
  Future<OcrPage> recognizeFile(String path);

  /// Освобождает ресурсы.
  Future<void> dispose();
}

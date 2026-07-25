import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

import '../../domain/ocr/ocr_engine.dart';

/// Распознавание через Tesseract, полностью на устройстве.
///
/// Выбран не от хорошей жизни: ML Kit от Google работает быстрее и точнее,
/// но распознаёт только латиницу, китайский, деванагари, японский
/// и корейский. Кириллицы среди них нет — для русского приложения он
/// бесполезен. Tesseract с русской моделью читает кириллицу и не требует
/// сети, а это условие всего продукта.
///
/// Модели лежат в сборке: русская и английская. Английская нужна не для
/// интерфейса, а для названий магазинов — «Lamoda», «zolla», «WOLLMER»,
/// «Tasty Coffee» встречаются в списках банков наравне с русскими.
class TesseractOcrEngine implements OcrEngine {
  TesseractOcrEngine();

  /// Языки Tesseract через плюс: распознаёт обе письменности сразу.
  static const String languages = 'rus+eng';

  /// Банковский экран — единый блок текста с ровными строками, а не
  /// разрозненные надписи, поэтому режим сегментации шестой.
  static const OCRConfig _config = OCRConfig(
    language: languages,
    engine: OCREngine.tesseract,
    options: {
      TesseractConfig.pageSegMode: '6',
      TesseractConfig.preserveInterwordSpaces: '1',
    },
  );

  bool _prepared = false;

  @override
  Future<void> prepare() async {
    // Плагин сам разворачивает модели из assets при первом обращении.
    _prepared = true;
  }

  @override
  Future<OcrPage> recognizeFile(String path) async {
    if (!_prepared) await prepare();

    final text = await TesseractOcr.extractText(path, config: _config);

    return OcrPage(
      lines: [
        for (final raw in text.split('\n'))
          if (raw.trim().isNotEmpty)
            OcrLine(text: raw.trim(), confidence: _confidenceOf(raw)),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    _prepared = false;
  }

  /// Оценка достоверности строки по её виду.
  ///
  /// Tesseract отдаёт уверенность отдельным вызовом, который заметно
  /// замедляет разбор, поэтому здесь дешёвая эвристика: строка, набитая
  /// одиночными символами и мусорными знаками, распознана плохо. Итоговая
  /// уверенность всё равно перемножается с уверенностью сопоставления,
  /// и всё сомнительное попадает пользователю на проверку.
  static double _confidenceOf(String line) {
    final text = line.trim();
    if (text.isEmpty) return 0;

    final letters = RegExp(r'[\p{L}\p{N}%]', unicode: true)
        .allMatches(text)
        .length;
    final ratio = letters / text.length;

    // Меньше половины осмысленных символов — строка почти наверняка каша.
    if (ratio < 0.5) return 0.4;
    if (ratio < 0.75) return 0.7;
    return 0.95;
  }
}

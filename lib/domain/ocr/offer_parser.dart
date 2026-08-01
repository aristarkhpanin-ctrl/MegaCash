import 'ocr_engine.dart';

/// Строка, распознанная как предложение банка.
class ParsedOffer {
  const ParsedOffer({
    required this.rawName,
    required this.rate,
    this.note,
    this.lineConfidence = 1,
  });

  /// Название так, как его написал банк: «Супермаркеты», «РИВ ГОШ».
  final String rawName;

  final double rate;

  /// Условие со следующей строки: «Зарплатным клиентам», «С Альфа-Смарт».
  ///
  /// Это не украшение: под такими условиями предложение может быть человеку
  /// недоступно, и решать это должен он, а не приложение.
  final String? note;

  /// Уверенность движка в исходной строке, 0..1.
  final double lineConfidence;

  @override
  String toString() => 'ParsedOffer($rawName, $rate%'
      '${note == null ? '' : ', «$note»'})';
}

/// Итог разбора одного экрана.
class ParseResult {
  const ParseResult({required this.offers, required this.ignored});

  final List<ParsedOffer> offers;

  /// Строки, не похожие на предложения: шапка, кнопки, суммы лимитов.
  final List<String> ignored;
}

/// Разбор распознанного текста на пары «название — процент».
///
/// Порядок написания у банков одинаковый и обратный ожидаемому: сначала
/// процент, потом название — «5% Супермаркеты». Разбор, рассчитанный
/// только на «Супермаркеты 5%», не найдёт вообще ничего.
abstract final class OfferParser {
  /// Процент впереди: «5% Супермаркеты», «1,5% Аптеки».
  static final RegExp _percentFirst =
      RegExp(r'^(\d{1,3}(?:[.,]\d{1,2})?)\s*%\s*(.+)$');

  /// Процент в конце: «Супермаркеты 5%». Так пишут не все, но встречается.
  static final RegExp _percentLast =
      RegExp(r'^(.+?)\s+(\d{1,3}(?:[.,]\d{1,2})?)\s*%$');

  /// Время в шапке телефона.
  static final RegExp _clock = RegExp(r'^\d{1,2}:\d{2}$');

  /// Ограничение суммы: «Кешбэк до 1 500 ₽».
  static final RegExp _cap = RegExp(r'^к[еэ]шб[еэ]к\s+до\s', caseSensitive: false);

  /// Заголовки, кнопки и подписи, которые предложением быть не могут.
  static const _noise = <String>{
    'подробнее',
    'забрать',
    'выбрать',
    'категории кешбэка',
    'категории кэшбэка',
    'базовый уровень',
    'свои плюсы',
    'с картой любого банка',
  };

  /// Название длиннее этого — это уже описание условий, а не категория.
  static const int _maxNameLength = 48;
  static const int _maxNameWords = 6;

  /// Начало предложения внутри строки: процент и следом название.
  static final RegExp _offerStart =
      RegExp(r'(?<![\d,.\u2212-])(\d{1,3}(?:[.,]\d{1,2})?)\s*%');

  /// Скидка, а не кэшбэк: «−50% Еда и Деливери». Это другой продукт,
  /// в подбор категорий он попасть не должен.
  static final RegExp _discount = RegExp(r'[\u2212-]\s*\d{1,3}\s*%');

  static ParseResult parse(OcrPage page) {
    final offers = <ParsedOffer>[];
    final ignored = <String>[];

    // Условие идёт строкой ниже предложения, поэтому сначала находим все
    // предложения, а потом привязываем к ним подписи.
    final entries = <_Entry>[];
    for (final line in page.lines) {
      for (final text in _splitOffers(line.text.trim())) {
        if (text.isEmpty) continue;
        entries.add(_Entry(text, line.confidence, _tryParse(text)));
      }
    }

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final parsed = entry.parsed;

      if (parsed == null) {
        if (!_isNoise(entry.text)) ignored.add(entry.text);
        continue;
      }

      // Перенесённый хвост названия приклеиваем обратно.
      var name = parsed.$2;
      if (i + 1 < entries.length) {
        final next = entries[i + 1];
        if (next.parsed == null &&
            !_isNoise(next.text) &&
            _isNameTail(next.text)) {
          name = '$name ${next.text}';
        }
      }

      offers.add(
        ParsedOffer(
          rawName: name,
          rate: parsed.$1,
          note: _noteAfter(entries, i),
          lineConfidence: entry.confidence,
        ),
      );
    }

    return ParseResult(offers: offers, ignored: ignored);
  }

  /// Подпись под предложением — ближайшая следующая строка, если она сама
  /// не предложение, не служебная и вообще похожа на текст.
  static String? _noteAfter(List<_Entry> entries, int index) {
    if (index + 1 >= entries.length) return null;
    final next = entries[index + 1];
    if (next.parsed != null) return null;
    if (_isNoise(next.text)) return null;
    if (!_looksLikeText(next.text)) return null;
    if (_isNameTail(next.text)) return null;
    return next.text;
  }

  /// Продолжение названия, перенесённое на вторую строку.
  ///
  /// Банк переносит длинное название: «Электроника и бытовая» / «техника».
  /// Хвост узнаётся по строчной букве в начале — настоящие условия
  /// («Зарплатным клиентам», «Только в приложении») пишутся с заглавной.
  static bool _isNameTail(String text) {
    if (text.isEmpty || text.length > 24) return false;
    if (text.contains(' ') && text.split(' ').length > 2) return false;
    final first = text[0];
    return first.toLowerCase() == first && first.toUpperCase() != first;
  }

  /// Отсекает мусор распознавания: «SSse Ge: ee:», «=E», «©», «5; @)».
  ///
  /// Такие строки движок выдаёт на месте значков и логотипов банков.
  /// Признак настоящей подписи — русское слово хотя бы из четырёх букв:
  /// все условия банков написаны по-русски, а мусор из значков выходит
  /// латиницей и символами. Правило грубое, но ошибается в безопасную
  /// сторону: потерянная подпись хуже не сделает, а мусор в интерфейсе
  /// выглядит как сбой приложения.
  static final RegExp _russianWord =
      RegExp(r'[а-яё]{4,}', caseSensitive: false, unicode: true);

  static bool _looksLikeText(String text) =>
      _russianWord.hasMatch(text.trim());

  /// Делит строку, если распознавание склеило в неё несколько плиток.
  ///
  /// На экранах в две колонки соседние предложения оказываются в одной
  /// строке: «5% АЗС 5% Книги». Без деления получилось бы одно
  /// предложение с мусорным названием — и половина экрана пропала бы.
  static List<String> _splitOffers(String line) {
    final starts = _offerStart.allMatches(line).map((m) => m.start).toList();
    if (starts.length < 2) return [line];

    final parts = <String>[];
    for (var i = 0; i < starts.length; i++) {
      final end = i + 1 < starts.length ? starts[i + 1] : line.length;
      parts.add(line.substring(starts[i], end).trim());
    }

    // Текст до первого процента — обычно хвост подписи, он не теряется.
    final head = line.substring(0, starts.first).trim();
    if (head.isNotEmpty) parts.insert(0, head);

    return parts;
  }

  static bool _isNoise(String text) {
    final lower = text.toLowerCase().replaceAll('ё', 'е').trim();
    if (_clock.hasMatch(lower)) return true;
    if (_cap.hasMatch(lower)) return true;
    if (_noise.contains(lower)) return true;
    // «С вашей картой Я Пэй» и подобные подписи разделов.
    if (lower.startsWith('с вашей картой')) return true;
    if (lower.startsWith('свои плюсы')) return true;
    return false;
  }

  /// Возвращает процент и название либо null, если строка не предложение.
  static (double, String)? _tryParse(String text) {
    final normalized = text.replaceAll(' ', ' ').trim();

    var match = _percentFirst.firstMatch(normalized);
    String? name;
    String? rateText;

    if (match != null) {
      rateText = match.group(1);
      name = match.group(2);
    } else {
      match = _percentLast.firstMatch(normalized);
      if (match != null) {
        name = match.group(1);
        rateText = match.group(2);
      }
    }

    if (name == null || rateText == null) return null;

    // Скидка, а не кэшбэк: «−50% Еда и Деливери». В обратном порядке
    // написания минус попал бы в конец названия, а процент прошёл бы
    // как обычный — и слот занял бы то, что денег не возвращает.
    if (_discount.hasMatch(normalized)) return null;

    final rate = double.tryParse(rateText.replaceAll(',', '.'));
    if (rate == null || rate <= 0 || rate > 100) return null;

    final cleaned = name.trim();
    if (cleaned.isEmpty) return null;
    if (cleaned.length > _maxNameLength) return null;
    if (cleaned.split(RegExp(r'\s+')).length > _maxNameWords) return null;

    return (rate, cleaned);
  }
}

class _Entry {
  _Entry(this.text, this.confidence, this.parsed);

  final String text;
  final double confidence;
  final (double, String)? parsed;
}

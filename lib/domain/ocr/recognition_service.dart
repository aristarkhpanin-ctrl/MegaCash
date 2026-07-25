import '../models/category.dart';
import '../models/monthly_offer.dart';
import 'category_matcher.dart';
import 'ocr_engine.dart';
import 'offer_parser.dart';

/// Строка, которую распознали, но не смогли отнести к категории.
///
/// Это не сбой: в списках банков много магазинов и сервисов — «РИВ ГОШ»,
/// «Lamoda», «Кинопоиск». Сводить их к категориям нельзя, иначе
/// «5% РИВ ГОШ» и «5% Красота» склеятся в одну категорию и оптимизатор
/// выбросит одно из двух как дубль, отняв у человека слот. Что с ними
/// делать, решает пользователь.
class UnmatchedOffer {
  const UnmatchedOffer({
    required this.rawName,
    required this.rate,
    this.note,
  });

  final String rawName;
  final double rate;
  final String? note;
}

/// Результат распознавания одной карты.
class RecognitionOutcome {
  const RecognitionOutcome({
    required this.offers,
    required this.unmatched,
    required this.rawText,
    required this.needsReviewCount,
  });

  /// Готовые предложения, привязанные к категориям справочника.
  final List<MonthlyOffer> offers;

  /// Строки для ручного разбора пользователем.
  final List<UnmatchedOffer> unmatched;

  /// Весь текст, который вернул движок. Идёт в журнал распознаваний.
  final String rawText;

  /// Сколько предложений распознано неуверенно и требует проверки.
  final int needsReviewCount;

  int get totalFound => offers.length + unmatched.length;
}

/// Распознавание скриншота в предложения банка.
///
/// Всё после движка — чистый Dart, поэтому проверяется на расшифровках
/// настоящих скриншотов без запуска приложения и без самого движка.
class RecognitionService {
  const RecognitionService({
    required this.engine,
    required this.categories,
    required this.idGenerator,
  });

  final OcrEngine engine;
  final List<Category> categories;

  /// Генератор идентификаторов. Передаётся снаружи, чтобы слой domain
  /// не тянул за собой ничего платформенного.
  final String Function() idGenerator;

  Future<RecognitionOutcome> recognize({
    required String imagePath,
    required String cardId,
    required String monthKey,
  }) async {
    final page = await engine.recognizeFile(imagePath);
    return fromPage(page, cardId: cardId, monthKey: monthKey);
  }

  /// Разбор уже распознанной страницы. Вынесен отдельно, чтобы тесты
  /// работали на расшифровках, не поднимая движок.
  RecognitionOutcome fromPage(
    OcrPage page, {
    required String cardId,
    required String monthKey,
  }) {
    final parsed = OfferParser.parse(page);
    final matcher = CategoryMatcher(categories);

    final offers = <MonthlyOffer>[];
    final unmatched = <UnmatchedOffer>[];
    var needsReview = 0;

    // Одна категория не может встретиться у карты дважды: банк не даёт
    // выбрать её два раза. Если распознались две строки с одной категорией,
    // оставляем ту, где процент выше.
    final byCategory = <String, MonthlyOffer>{};

    for (final offer in parsed.offers) {
      final match = matcher.match(
        offer.rawName,
        lineConfidence: offer.lineConfidence,
      );

      if (!match.isMatched) {
        unmatched.add(
          UnmatchedOffer(
            rawName: offer.rawName,
            rate: offer.rate,
            note: offer.note,
          ),
        );
        continue;
      }

      final candidate = MonthlyOffer(
        id: idGenerator(),
        cardId: cardId,
        monthKey: monthKey,
        categoryId: match.categoryId!,
        rate: offer.rate,
        source: OfferSource.ocr,
        confidence: match.confidence,
        note: offer.note,
      );

      final existing = byCategory[candidate.categoryId];
      if (existing == null || candidate.rate > existing.rate) {
        byCategory[candidate.categoryId] = candidate;
      }
    }

    for (final offer in byCategory.values) {
      offers.add(offer);
      if (offer.needsReview) needsReview++;
    }

    return RecognitionOutcome(
      offers: offers,
      unmatched: unmatched,
      rawText: page.rawText,
      needsReviewCount: needsReview,
    );
  }
}

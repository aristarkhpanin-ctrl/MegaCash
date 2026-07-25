import '../models/category.dart';
import 'text_normalizer.dart';

/// Чем закончилось сопоставление названия со справочником.
class CategoryMatch {
  const CategoryMatch({
    required this.rawName,
    this.categoryId,
    this.confidence = 0,
    this.matchedOn,
  });

  final String rawName;

  /// Найденная категория. Null — в справочнике такого нет.
  final String? categoryId;

  /// 0..1. Ниже 0.7 предложение показывается пользователю на проверку.
  final double confidence;

  /// Синоним, по которому нашлось. Для объяснения человеку.
  final String? matchedOn;

  bool get isMatched => categoryId != null;

  @override
  String toString() => isMatched
      ? 'CategoryMatch($rawName → $categoryId, ${confidence.toStringAsFixed(2)})'
      : 'CategoryMatch($rawName → не найдено)';
}

/// Сопоставление распознанных названий со справочником категорий.
///
/// Важное наблюдение по настоящим скриншотам: значительная часть позиций —
/// не категории, а магазины и сервисы: «РИВ ГОШ», «Lamoda», «Кинопоиск»,
/// «zolla». Их намеренно не сводят к категориям: «5% РИВ ГОШ» и
/// «5% Красота» — разные предложения, и если склеить их в одну категорию,
/// оптимизатор выбросит одно из двух как дубль, отняв у человека слот.
/// Поэтому такие названия возвращаются несопоставленными, а решение,
/// что с ними делать, принимает пользователь.
class CategoryMatcher {
  const CategoryMatcher(this.categories);

  final List<Category> categories;

  /// Ниже этой похожести совпадением не считаем: лучше отдать строку
  /// человеку, чем молча подставить не ту категорию.
  static const double minSimilarity = 0.84;

  static const double exactConfidence = 0.95;

  CategoryMatch match(String rawName, {double lineConfidence = 1}) {
    final key = TextNormalizer.key(rawName);
    if (key.isEmpty) return CategoryMatch(rawName: rawName);

    // Точное совпадение по названию или синониму.
    for (final category in categories) {
      if (TextNormalizer.key(category.name) == key) {
        return CategoryMatch(
          rawName: rawName,
          categoryId: category.id,
          confidence: exactConfidence * lineConfidence,
          matchedOn: category.name,
        );
      }
      for (final synonym in category.synonyms) {
        if (TextNormalizer.key(synonym) == key) {
          return CategoryMatch(
            rawName: rawName,
            categoryId: category.id,
            confidence: exactConfidence * lineConfidence,
            matchedOn: synonym,
          );
        }
      }
    }

    // Приблизительное: распознавание регулярно путает похожие буквы.
    String? bestId;
    String? bestOn;
    var bestSimilarity = 0.0;
    var bestDistance = 1 << 30;

    for (final category in categories) {
      for (final candidate in [category.name, ...category.synonyms]) {
        final candidateKey = TextNormalizer.key(candidate);
        final similarity = TextNormalizer.similarity(key, candidateKey);
        if (similarity > bestSimilarity) {
          bestSimilarity = similarity;
          bestDistance = TextNormalizer.distance(key, candidateKey);
          bestId = category.id;
          bestOn = candidate;
        }
      }
    }

    // Порог по доле разошедшихся символов на коротких названиях слишком
    // строг: у «Аптеки» одна перепутанная буква — это уже 17% длины.
    // Поэтому одна ошибка на названии от пяти букв принимается отдельно.
    final closeEnough = bestSimilarity >= minSimilarity ||
        (bestDistance <= 1 && key.length >= 5);

    if (bestId == null || !closeEnough) {
      return CategoryMatch(rawName: rawName);
    }

    // Слабое совпадение уходит на проверку, уверенное принимается.
    final scaled = (0.5 + (bestSimilarity - minSimilarity) * 3).clamp(0.5, 0.9);

    return CategoryMatch(
      rawName: rawName,
      categoryId: bestId,
      confidence: scaled * lineConfidence,
      matchedOn: bestOn,
    );
  }
}

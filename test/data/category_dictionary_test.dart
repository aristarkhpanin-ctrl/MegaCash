import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/data/remote/category_dictionary_impl.dart';

/// Справочник — общая опора и оптимизатора, и распознавания.
/// Ошибка в нём тихо испортит и то, и другое.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BundledCategoryDictionary dictionary;

  setUp(() => dictionary = BundledCategoryDictionary());

  test('встроенный справочник читается', () async {
    final categories = await dictionary.all();
    expect(categories.length, greaterThanOrEqualTo(40));
  });

  test('идентификаторы уникальны', () async {
    final ids = (await dictionary.all()).map((c) => c.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('веса из техзадания на месте', () async {
    final weights = await dictionary.defaultWeights();
    expect(weights['supermarkets'], 10);
    expect(weights['cafe'], 7);
    expect(weights['pharmacy'], 6);
    expect(weights['clothes'], 5);
    expect(weights['home'], 4);
    expect(weights['fuel'], 4);
    expect(weights['transport'], 3);
    expect(weights['marketplace'], 3);
    expect(weights['electronics'], 2);
    expect(weights['beauty'], 2);
    expect(weights['entertainment'], 2);
    expect(weights['jewelry'], 0.5);
    expect(weights['flowers'], 0.5);
  });

  test('прочие категории весят 1', () async {
    final categories = await dictionary.all();
    const named = {
      'supermarkets', 'cafe', 'pharmacy', 'clothes', 'home', 'fuel',
      'transport', 'marketplace', 'electronics', 'beauty', 'entertainment',
      'jewelry', 'flowers',
      // Такси и фастфуд банки дают отдельными категориями, поэтому у них
      // свой вес внутри той же группы расходов.
      'taxi', 'fastfood', 'coffee', 'delivery', 'medicine',
    };
    for (final c in categories) {
      if (named.contains(c.id)) continue;
      expect(c.defaultWeight, 1, reason: 'категория ${c.id}');
    }
  });

  test('«На все покупки» помечена как совпадающая со всем', () async {
    final all = await dictionary.allPurchases();
    expect(all, isNotNull);
    expect(all!.id, 'all_purchases');
    expect(all.matchesEverything, isTrue);

    final others = (await dictionary.all())
        .where((c) => c.matchesEverything)
        .toList();
    expect(others, hasLength(1), reason: 'такая категория должна быть одна');
  });

  test('у каждой категории есть синонимы для распознавания', () async {
    for (final c in await dictionary.all()) {
      expect(c.synonyms, isNotEmpty, reason: 'категория ${c.id}');
    }
  });

  /// Один синоним на две категории означает, что распознавание будет
  /// стабильно ошибаться, и заметить это по глазам почти невозможно.
  test('синонимы не пересекаются между категориями', () async {
    final owner = <String, String>{};
    final clashes = <String>[];

    for (final c in await dictionary.all()) {
      for (final raw in c.synonyms) {
        final s = raw.toLowerCase().replaceAll('ё', 'е').trim();
        final previous = owner[s];
        if (previous != null && previous != c.id) {
          clashes.add('«$s» — и в $previous, и в ${c.id}');
        }
        owner[s] = c.id;
      }
    }

    expect(clashes, isEmpty, reason: clashes.join('\n'));
  });

  test('название категории само по себе является синонимом', () async {
    for (final c in await dictionary.all()) {
      final normalized = c.synonyms
          .map((s) => s.toLowerCase().replaceAll('ё', 'е').trim())
          .toList();
      final name = c.name.toLowerCase().replaceAll('ё', 'е').trim();
      expect(normalized, contains(name), reason: 'категория ${c.id}');
    }
  });

  test('битое обновление не затирает рабочую копию', () async {
    final broken = BundledCategoryDictionary(
      remoteLoader: () async => '{"categories": []}',
    );
    final before = await broken.all();
    await broken.refresh();
    final after = await broken.all();
    expect(after.length, before.length);
  });

  test('недоступная сеть не роняет справочник', () async {
    final offline = BundledCategoryDictionary(
      remoteLoader: () async => throw const SocketExceptionStub(),
    );
    await offline.refresh();
    expect(await offline.all(), isNotEmpty);
  });

  test('корректное обновление подменяет справочник', () async {
    final updated = BundledCategoryDictionary(
      remoteLoader: () async => '''
        {"categories": [
          {"id": "supermarkets", "name": "Супермаркеты", "weight": 12,
           "synonyms": ["супермаркеты", "продуктовый гипермаркет"]}
        ]}
      ''',
    );
    await updated.refresh();
    final all = await updated.all();
    expect(all, hasLength(1));
    expect(all.single.defaultWeight, 12);
    expect(all.single.synonyms, contains('продуктовый гипермаркет'));
  });
}

class SocketExceptionStub implements Exception {
  const SocketExceptionStub();
}

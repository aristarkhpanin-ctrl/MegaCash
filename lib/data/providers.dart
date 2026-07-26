import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../core/utils/ids.dart';
import '../domain/models/bank.dart';
import '../domain/models/category.dart';
import '../domain/models/payment_card.dart';
import '../domain/ocr/ocr_engine.dart';
import '../domain/ocr/recognition_service.dart';
import '../domain/repositories/repositories.dart';
import 'local/isar_repositories.dart';
import 'ocr/tesseract_ocr_engine.dart';
import 'remote/category_dictionary_impl.dart';

/// Открытая база. Подменяется в [main] после реального открытия и
/// в тестах — на базу во временном каталоге.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError(
    'isarProvider должен быть переопределён в ProviderScope',
  );
});

final bankRepositoryProvider = Provider<BankRepository>(
  (ref) => IsarBankRepository(ref.watch(isarProvider)),
);

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => IsarCardRepository(ref.watch(isarProvider)),
);

final offerRepositoryProvider = Provider<OfferRepository>(
  (ref) => IsarOfferRepository(ref.watch(isarProvider)),
);

final selectionRepositoryProvider = Provider<SelectionRepository>(
  (ref) => IsarSelectionRepository(ref.watch(isarProvider)),
);

final weightRepositoryProvider = Provider<WeightRepository>(
  (ref) => IsarWeightRepository(ref.watch(isarProvider)),
);

final recognitionLogRepositoryProvider = Provider<RecognitionLogRepository>(
  (ref) => IsarRecognitionLogRepository(ref.watch(isarProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => IsarSettingsRepository(ref.watch(isarProvider)),
);

final categoryDictionaryProvider = Provider<CategoryDictionary>(
  (ref) => BundledCategoryDictionary(),
);

/// Карты пользователя с их банками — в таком виде их и показывает интерфейс.
class CardWithBank {
  const CardWithBank({required this.card, required this.bank});

  final PaymentCard card;
  final Bank bank;

  String get bankName => bank.name;
  int get colorValue => bank.colorValue;
}

/// Список карт, который сам обновляется при изменениях в базе.
///
/// Зависимости читаются здесь, синхронно, а поток собирается отдельной
/// функцией: `ref.watch` внутри тела `async*` выполнился бы уже после
/// построения провайдера, и поток не запустился бы вовсе.
final cardsProvider = StreamProvider<List<CardWithBank>>((ref) {
  return _watchCardsWithBanks(
    cards: ref.watch(cardRepositoryProvider),
    banks: ref.watch(bankRepositoryProvider),
  );
});

/// Карта, чей банк не найден, в список не попадает: показывать её нечем —
/// ни названия, ни цвета.
Stream<List<CardWithBank>> _watchCardsWithBanks({
  required CardRepository cards,
  required BankRepository banks,
}) async* {
  await for (final list in cards.watchAll()) {
    final byId = {for (final b in await banks.all()) b.id: b};
    yield [
      for (final c in list)
        if (byId[c.bankId] case final bank?) CardWithBank(card: c, bank: bank),
    ];
  }
}

/// Сколько категорий выбрано по каждой карте в указанном месяце.
final selectionCountProvider =
    FutureProvider.family<Map<String, int>, String>((ref, monthKey) async {
  final selections =
      await ref.watch(selectionRepositoryProvider).forMonth(monthKey);
  final counts = <String, int>{};
  for (final s in selections) {
    counts[s.cardId] = (counts[s.cardId] ?? 0) + 1;
  }
  return counts;
});

/// Веса категорий: значения по умолчанию из справочника, поверх них —
/// то, что накопилось из действий пользователя.
///
/// Обе зависимости читаются до первого `await`: после него `ref.watch`
/// уже вне построения провайдера.
final weightsProvider = FutureProvider<Map<String, double>>((ref) async {
  final dictionary = ref.watch(categoryDictionaryProvider);
  final weights = ref.watch(weightRepositoryProvider);

  final defaults = await dictionary.defaultWeights();
  final stored = await weights.all();
  return {...defaults, ...stored};
});

/// Справочник категорий.
///
/// Загружается один раз при старте приложения и дальше доступен сразу,
/// как база. Асинхронное чтение на каждом экране означало бы, что любой
/// экран должен уметь показывать себя без категорий — а показывать ему
/// в этот момент нечего.
final categoriesProvider = Provider<List<Category>>((ref) {
  throw UnimplementedError(
    'categoriesProvider должен быть переопределён в ProviderScope',
  );
});

/// Движок распознавания. Подменяется в тестах и при смене платформы.
final ocrEngineProvider = Provider<OcrEngine>((ref) {
  final engine = TesseractOcrEngine();
  ref.onDispose(engine.dispose);
  return engine;
});

/// Распознавание скриншота в предложения банка.
///
/// Всё после движка — чистый Dart: разбор строк, сопоставление со
/// словарём, оценка уверенности. Поэтому проверяется на расшифровках
/// настоящих скриншотов, без устройства и без самого движка.
final recognitionServiceProvider = Provider<RecognitionService>((ref) {
  return RecognitionService(
    engine: ref.watch(ocrEngineProvider),
    categories: ref.watch(categoriesProvider),
    idGenerator: Ids.generate,
  );
});

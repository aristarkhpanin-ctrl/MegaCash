import '../models/bank.dart';
import '../models/category.dart';
import '../models/category_weight.dart';
import '../models/monthly_offer.dart';
import '../models/payment_card.dart';
import '../models/recognition_log.dart';
import '../models/selection.dart';

/// Банки пользователя.
abstract interface class BankRepository {
  Future<List<Bank>> all();
  Future<Bank?> byId(String id);
  Future<void> save(Bank bank);
  Future<void> delete(String id);
  Stream<List<Bank>> watchAll();
}

/// Карты пользователя.
abstract interface class CardRepository {
  Future<List<PaymentCard>> all();
  Future<PaymentCard?> byId(String id);
  Future<void> save(PaymentCard card);

  /// Удаляет карту вместе с её предложениями и выборами — иначе они
  /// останутся висеть без владельца.
  Future<void> delete(String id);

  Stream<List<PaymentCard>> watchAll();

  /// Наибольший базовый процент среди всех карт. От него оптимизатор
  /// считает прирост: даже без выбранной категории человек что-то получит.
  Future<double> maxBaseRate();
}

/// Предложения банков по месяцам.
abstract interface class OfferRepository {
  Future<List<MonthlyOffer>> forMonth(String monthKey);
  Future<List<MonthlyOffer>> forCard(String cardId, String monthKey);
  Future<void> saveAll(List<MonthlyOffer> offers);
  Future<void> delete(String id);

  /// Удаляет все предложения месяца — при повторной загрузке скриншотов.
  Future<void> clearMonth(String monthKey);

  Stream<List<MonthlyOffer>> watchMonth(String monthKey);

  /// Ключ самого свежего месяца, для которого есть предложения.
  /// По нему определяется, наступил ли новый месяц.
  Future<String?> latestMonthKey();
}

/// Выбранные категории по месяцам.
abstract interface class SelectionRepository {
  Future<List<Selection>> forMonth(String monthKey);
  Future<void> saveAll(List<Selection> selections);

  /// Заменяет весь набор выборов месяца — рекомендация всегда
  /// пересчитывается целиком, а не правится по одной строке.
  Future<void> replaceMonth(String monthKey, List<Selection> selections);

  Future<void> updateStatus(String id, SelectionStatus status);
  Future<void> delete(String id);
  Stream<List<Selection>> watchMonth(String monthKey);
}

/// Веса категорий. Живут поверх месяцев и накапливаются.
abstract interface class WeightRepository {
  /// Карта «идентификатор категории → вес». Категории, которых нет
  /// в хранилище, берут вес по умолчанию из справочника.
  Future<Map<String, double>> all();

  Future<void> save(CategoryWeight weight);
  Future<void> saveAll(List<CategoryWeight> weights);

  /// Пользователь забрал категорию в «Выбранные» — вес растёт.
  Future<void> promote(String categoryId, {required double defaultWeight});

  /// Пользователь отправил категорию в «Не выбранные» — вес падает.
  Future<void> demote(String categoryId, {required double defaultWeight});

  Future<void> clear();
}

/// Журнал распознаваний.
abstract interface class RecognitionLogRepository {
  Future<void> add(RecognitionLog log);
  Future<List<RecognitionLog>> recent({int limit = 20});
  Future<void> clear();
}

/// Справочник категорий и словарь синонимов.
///
/// Сегодня — файл в сборке, завтра — загрузка с сервера. Поэтому за
/// интерфейсом: приложение поставляется со встроенной копией и работает
/// полностью без интернета, а обновление справочника позволяет добавлять
/// новые формулировки банков без выпуска обновления приложения.
abstract interface class CategoryDictionary {
  /// Все категории справочника.
  Future<List<Category>> all();

  Future<Category?> byId(String id);

  /// Категория «На все покупки», если она есть в справочнике.
  Future<Category?> allPurchases();

  /// Веса по умолчанию из справочника.
  Future<Map<String, double>> defaultWeights();

  /// Обновляет справочник из сети, если получится. Молча остаётся
  /// на встроенной копии, если сеть недоступна.
  Future<void> refresh();
}

/// Настройки приложения.
abstract interface class SettingsRepository {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<bool> getBool(String key, {bool orElse = false});
  Future<void> setBool(String key, {required bool value});

  /// Стирает все данные пользователя. Нужен в настройках: приложение
  /// хранит всё на устройстве, и человек должен иметь возможность
  /// это прекратить.
  Future<void> clearEverything();
}

/// Ключи настроек в одном месте, чтобы не разъезжались по коду.
abstract final class SettingKeys {
  static const themeMode = 'theme_mode';
  static const onboardingDone = 'onboarding_done';
}

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities.dart';

/// Открытие локальной базы.
///
/// Данные живут только на устройстве: аккаунта нет, облачной синхронизации
/// нет. Страховка от потери — автобэкап Android и экспорт в файл (шаг 8).
abstract final class IsarDatabase {
  static const String name = 'megacash';

  static const List<CollectionSchema<dynamic>> schemas = [
    BankEntitySchema,
    CardEntitySchema,
    OfferEntitySchema,
    SelectionEntitySchema,
    WeightEntitySchema,
    RecognitionLogEntitySchema,
    AppSettingEntitySchema,
  ];

  /// Открывает базу в каталоге документов приложения.
  static Future<Isar> open() async {
    final existing = Isar.getInstance(name);
    if (existing != null) return existing;

    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(schemas, directory: dir.path, name: name);
  }

  /// Открытие в указанном каталоге — для тестов.
  ///
  /// Режима «в памяти» у Isar 3 нет, поэтому тесты работают с временным
  /// каталогом и своим именем инстанса, чтобы не мешать друг другу.
  /// Перед первым вызовом в юнит-тестах нужен [Isar.initializeIsarCore],
  /// который подтягивает нативную библиотеку.
  static Future<Isar> openAt({
    required String directory,
    required String instanceName,
  }) {
    return Isar.open(
      schemas,
      directory: directory,
      name: instanceName,
      inspector: false,
    );
  }
}

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/backup/backup.dart';
import '../domain/models/category_weight.dart';
import 'providers.dart';

/// Сохранение и восстановление копии данных.
class BackupService {
  const BackupService(this._ref);

  final Ref _ref;

  /// Собирает копию всех данных пользователя.
  Future<Backup> collect() async {
    final banks = await _ref.read(bankRepositoryProvider).all();
    final cards = await _ref.read(cardRepositoryProvider).all();
    final weights = await _ref.read(weightRepositoryProvider).all();

    // Предложения и выборы лежат по месяцам, а копия должна забрать все:
    // веса выведены из прошлых месяцев, и потеряв их, человек потеряет
    // всё, чему приложение про него научилось.
    final offers = <dynamic>[];
    final selections = <dynamic>[];
    final months = await _allMonths();
    final offerRepo = _ref.read(offerRepositoryProvider);
    final selectionRepo = _ref.read(selectionRepositoryProvider);
    for (final month in months) {
      offers.addAll(await offerRepo.forMonth(month));
      selections.addAll(await selectionRepo.forMonth(month));
    }

    return Backup(
      banks: banks,
      cards: cards,
      offers: offers.cast(),
      selections: selections.cast(),
      weights: [
        for (final e in weights.entries)
          CategoryWeight(categoryId: e.key, weight: e.value),
      ],
    );
  }

  /// Записывает копию в файл и возвращает путь к нему.
  Future<String> exportToFile() async {
    final backup = await collect();
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().toIso8601String().split('T').first;
    final file = File('${dir.path}/megacash-$stamp.json');
    await file.writeAsString(backup.encode());
    return file.path;
  }

  /// Восстанавливает данные из файла.
  ///
  /// Возвращает false, если файл не похож на копию: подсунуть посторонний
  /// файл легко, а стирать по нему все данные нельзя.
  Future<bool> importFromFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return false;

    final backup = Backup.decode(await file.readAsString());
    if (backup == null || backup.isEmpty) return false;

    await restore(backup);
    return true;
  }

  /// Заменяет текущие данные содержимым копии.
  Future<void> restore(Backup backup) async {
    await _ref.read(settingsRepositoryProvider).clearEverything();

    final banks = _ref.read(bankRepositoryProvider);
    for (final bank in backup.banks) {
      await banks.save(bank);
    }

    final cards = _ref.read(cardRepositoryProvider);
    for (final card in backup.cards) {
      await cards.save(card);
    }

    await _ref.read(offerRepositoryProvider).saveAll(backup.offers);
    await _ref.read(selectionRepositoryProvider).saveAll(backup.selections);
    await _ref.read(weightRepositoryProvider).saveAll(backup.weights);

    _ref.invalidate(cardsProvider);
  }

  /// Все месяцы, по которым есть данные. Идём от самого свежего назад:
  /// год истории — потолок, дальше веса всё равно уже устоялись.
  Future<List<String>> _allMonths() async {
    final latest = await _ref.read(offerRepositoryProvider).latestMonthKey();
    if (latest == null) return const [];

    final parts = latest.split('-');
    var year = int.tryParse(parts.first) ?? DateTime.now().year;
    var month = int.tryParse(parts.last) ?? DateTime.now().month;

    final months = <String>[];
    for (var i = 0; i < 24; i++) {
      months.add(
        '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}',
      );
      month--;
      if (month == 0) {
        month = 12;
        year--;
      }
    }
    return months;
  }
}

final backupServiceProvider = Provider<BackupService>(BackupService.new);

/// Копии, лежащие в папке приложения.
///
/// Выбор файла откуда угодно требует системного диалога, а плагин для
/// него не собирается с текущей версией Flutter — он ещё не переведён
/// на встроенный Kotlin. Пока список ограничен папкой приложения:
/// туда пишет экспорт, и туда же файл можно положить файловым
/// менеджером или из мессенджера.
final backupFilesProvider = FutureProvider<List<String>>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .map((f) => f.path)
      .toList()
    ..sort((a, b) => b.compareTo(a));
  return files;
});

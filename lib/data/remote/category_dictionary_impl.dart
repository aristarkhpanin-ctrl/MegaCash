import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/models/category.dart';
import '../../domain/repositories/repositories.dart';

/// Справочник категорий: встроенная копия плюс необязательное обновление.
///
/// Единственное сетевое обращение во всём приложении. Нужно, чтобы добавлять
/// новые формулировки банков без выпуска обновления. Если сети нет или файл
/// битый — молча остаёмся на встроенной копии: приложение обязано работать
/// полностью офлайн.
class BundledCategoryDictionary implements CategoryDictionary {
  BundledCategoryDictionary({
    this.assetPath = 'assets/categories.json',
    this.remoteLoader,
    this.overrideStore,
  });

  final String assetPath;

  /// Загрузчик обновлённого справочника. Отсутствует — обновление
  /// просто не делается.
  final Future<String?> Function()? remoteLoader;

  /// Куда класть и откуда читать скачанную копию между запусками.
  final CategoryOverrideStore? overrideStore;

  List<Category>? _cache;

  @override
  Future<List<Category>> all() async {
    final cached = _cache;
    if (cached != null) return cached;

    final stored = await overrideStore?.read();
    if (stored != null) {
      final parsed = _tryParse(stored);
      if (parsed != null) return _cache = parsed;
    }

    final raw = await rootBundle.loadString(assetPath);
    final parsed = _tryParse(raw);
    if (parsed == null) {
      throw StateError('Встроенный справочник категорий не читается: $assetPath');
    }
    return _cache = parsed;
  }

  @override
  Future<Category?> byId(String id) async {
    final list = await all();
    for (final c in list) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  Future<Category?> allPurchases() async {
    final list = await all();
    for (final c in list) {
      if (c.matchesEverything) return c;
    }
    return null;
  }

  @override
  Future<Map<String, double>> defaultWeights() async {
    final list = await all();
    return {for (final c in list) c.id: c.defaultWeight};
  }

  @override
  Future<void> refresh() async {
    final loader = remoteLoader;
    if (loader == null) return;

    String? raw;
    try {
      raw = await loader();
    } catch (_) {
      // Сеть недоступна или сервер ответил ошибкой — остаёмся на том,
      // что уже есть. Пользователю об этом сообщать незачем.
      return;
    }
    if (raw == null) return;

    final parsed = _tryParse(raw);
    if (parsed == null) return;

    await overrideStore?.write(raw);
    _cache = parsed;
  }

  /// Разбирает справочник. Возвращает null, если файл не пригоден —
  /// битым обновлением нельзя затирать рабочую копию.
  static List<Category>? _tryParse(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;

      final items = decoded['categories'];
      if (items is! List || items.isEmpty) return null;

      final result = <Category>[];
      for (final item in items) {
        if (item is! Map<String, dynamic>) continue;

        final id = item['id'];
        final name = item['name'];
        if (id is! String || id.isEmpty) continue;
        if (name is! String || name.isEmpty) continue;

        final weight = item['weight'];
        final synonyms = item['synonyms'];

        result.add(
          Category(
            id: id,
            name: name,
            defaultWeight: weight is num ? weight.toDouble() : 1,
            synonyms: synonyms is List
                ? synonyms.whereType<String>().toList(growable: false)
                : const [],
            matchesEverything: item['matchesEverything'] == true,
          ),
        );
      }
      return result.isEmpty ? null : result;
    } catch (_) {
      return null;
    }
  }
}

/// Хранилище скачанной копии справочника.
abstract interface class CategoryOverrideStore {
  Future<String?> read();
  Future<void> write(String raw);
}

import 'package:isar_community/isar.dart';

import '../../domain/models/bank.dart';
import '../../domain/models/category_weight.dart';
import '../../domain/models/monthly_offer.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/models/recognition_log.dart';
import '../../domain/models/selection.dart';
import '../../domain/repositories/repositories.dart';
import 'entities.dart';

class IsarBankRepository implements BankRepository {
  IsarBankRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<Bank>> all() async {
    final rows = await _isar.bankEntitys.where().sortByName().findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Bank?> byId(String id) async {
    final row = await _isar.bankEntitys.getByUid(id);
    return row?.toDomain();
  }

  @override
  Future<void> save(Bank bank) async {
    await _isar.writeTxn(
      () => _isar.bankEntitys.put(BankEntity.fromDomain(bank)),
    );
  }

  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(() => _isar.bankEntitys.deleteByUid(id));
  }

  @override
  Stream<List<Bank>> watchAll() {
    return _isar.bankEntitys
        .where()
        .sortByName()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }
}

class IsarCardRepository implements CardRepository {
  IsarCardRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<PaymentCard>> all() async {
    final rows = await _isar.cardEntitys.where().findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<PaymentCard?> byId(String id) async {
    final row = await _isar.cardEntitys.getByUid(id);
    return row?.toDomain();
  }

  @override
  Future<void> save(PaymentCard card) async {
    await _isar.writeTxn(
      () => _isar.cardEntitys.put(CardEntity.fromDomain(card)),
    );
  }

  /// Удаляет карту вместе с её предложениями и выборами: осиротевшие записи
  /// иначе попадут в оптимизатор и в ответ у кассы.
  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(() async {
      await _isar.cardEntitys.deleteByUid(id);
      await _isar.offerEntitys.filter().cardIdEqualTo(id).deleteAll();
      await _isar.selectionEntitys.filter().cardIdEqualTo(id).deleteAll();
    });
  }

  @override
  Stream<List<PaymentCard>> watchAll() {
    return _isar.cardEntitys
        .where()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }

  @override
  Future<double> maxBaseRate() async {
    final rates = await _isar.cardEntitys.where().baseRateProperty().findAll();
    if (rates.isEmpty) return 0;
    return rates.reduce((a, b) => a > b ? a : b);
  }
}

class IsarOfferRepository implements OfferRepository {
  IsarOfferRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<MonthlyOffer>> forMonth(String monthKey) async {
    final rows =
        await _isar.offerEntitys.filter().monthKeyEqualTo(monthKey).findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<MonthlyOffer>> forCard(String cardId, String monthKey) async {
    final rows = await _isar.offerEntitys
        .filter()
        .monthKeyEqualTo(monthKey)
        .cardIdEqualTo(cardId)
        .findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> saveAll(List<MonthlyOffer> offers) async {
    if (offers.isEmpty) return;
    await _isar.writeTxn(
      () => _isar.offerEntitys.putAll(
        offers.map(OfferEntity.fromDomain).toList(),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(() => _isar.offerEntitys.deleteByUid(id));
  }

  @override
  Future<void> clearMonth(String monthKey) async {
    await _isar.writeTxn(
      () => _isar.offerEntitys.filter().monthKeyEqualTo(monthKey).deleteAll(),
    );
  }

  @override
  Stream<List<MonthlyOffer>> watchMonth(String monthKey) {
    return _isar.offerEntitys
        .filter()
        .monthKeyEqualTo(monthKey)
        .watch(fireImmediately: true)
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }

  /// Ключи месяцев сортируются как строки — формат «2026-07» это позволяет.
  @override
  Future<String?> latestMonthKey() async {
    final keys = await _isar.offerEntitys.where().monthKeyProperty().findAll();
    if (keys.isEmpty) return null;
    return keys.reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
  }
}

class IsarSelectionRepository implements SelectionRepository {
  IsarSelectionRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<Selection>> forMonth(String monthKey) async {
    final rows = await _isar.selectionEntitys
        .filter()
        .monthKeyEqualTo(monthKey)
        .findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> saveAll(List<Selection> selections) async {
    if (selections.isEmpty) return;
    await _isar.writeTxn(
      () => _isar.selectionEntitys.putAll(
        selections.map(SelectionEntity.fromDomain).toList(),
      ),
    );
  }

  /// Рекомендация всегда пересчитывается целиком, поэтому набор месяца
  /// заменяется одной транзакцией, а не правится по строке.
  @override
  Future<void> replaceMonth(
    String monthKey,
    List<Selection> selections,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.selectionEntitys
          .filter()
          .monthKeyEqualTo(monthKey)
          .deleteAll();
      if (selections.isNotEmpty) {
        await _isar.selectionEntitys.putAll(
          selections.map(SelectionEntity.fromDomain).toList(),
        );
      }
    });
  }

  @override
  Future<void> updateStatus(String id, SelectionStatus status) async {
    await _isar.writeTxn(() async {
      final row = await _isar.selectionEntitys.getByUid(id);
      if (row == null) return;
      row.status = status;
      await _isar.selectionEntitys.put(row);
    });
  }

  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(() => _isar.selectionEntitys.deleteByUid(id));
  }

  @override
  Stream<List<Selection>> watchMonth(String monthKey) {
    return _isar.selectionEntitys
        .filter()
        .monthKeyEqualTo(monthKey)
        .watch(fireImmediately: true)
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }
}

class IsarWeightRepository implements WeightRepository {
  IsarWeightRepository(this._isar);

  final Isar _isar;

  @override
  Future<Map<String, double>> all() async {
    final rows = await _isar.weightEntitys.where().findAll();
    return {for (final r in rows) r.categoryId: r.weight};
  }

  @override
  Future<void> save(CategoryWeight weight) async {
    await _isar.writeTxn(
      () => _isar.weightEntitys.put(WeightEntity.fromDomain(weight)),
    );
  }

  @override
  Future<void> saveAll(List<CategoryWeight> weights) async {
    if (weights.isEmpty) return;
    await _isar.writeTxn(
      () => _isar.weightEntitys.putAll(
        weights.map(WeightEntity.fromDomain).toList(),
      ),
    );
  }

  @override
  Future<void> promote(String categoryId, {required double defaultWeight}) {
    return _apply(categoryId, defaultWeight, CategoryWeight.promoteFactor);
  }

  @override
  Future<void> demote(String categoryId, {required double defaultWeight}) {
    return _apply(categoryId, defaultWeight, CategoryWeight.demoteFactor);
  }

  /// Категории, которой ещё нет в хранилище, вес берётся из справочника —
  /// и уже от него применяется множитель.
  Future<void> _apply(
    String categoryId,
    double defaultWeight,
    double factor,
  ) async {
    await _isar.writeTxn(() async {
      final row = await _isar.weightEntitys.getByCategoryId(categoryId);
      final current = row?.weight ?? defaultWeight;
      final next = CategoryWeight(categoryId: categoryId, weight: current)
          .scaled(factor);
      await _isar.weightEntitys.put(WeightEntity.fromDomain(next));
    });
  }

  @override
  Future<void> clear() async {
    await _isar.writeTxn(() => _isar.weightEntitys.clear());
  }
}

class IsarRecognitionLogRepository implements RecognitionLogRepository {
  IsarRecognitionLogRepository(this._isar);

  final Isar _isar;

  @override
  Future<void> add(RecognitionLog log) async {
    await _isar.writeTxn(
      () => _isar.recognitionLogEntitys.put(
        RecognitionLogEntity.fromDomain(log),
      ),
    );
  }

  @override
  Future<List<RecognitionLog>> recent({int limit = 20}) async {
    final rows = await _isar.recognitionLogEntitys
        .where()
        .sortByAtDesc()
        .limit(limit)
        .findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> clear() async {
    await _isar.writeTxn(() => _isar.recognitionLogEntitys.clear());
  }
}

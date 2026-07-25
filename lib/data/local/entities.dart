import 'package:isar_community/isar.dart';

import '../../domain/models/bank.dart';
import '../../domain/models/category_weight.dart';
import '../../domain/models/monthly_offer.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/models/recognition_log.dart';
import '../../domain/models/selection.dart';

part 'entities.g.dart';

/// Схемы хранилища.
///
/// Отдельные от доменных моделей классы — намеренно: слой `domain` не
/// импортирует Isar, иначе оптимизатор не покрыть обычными юнит-тестами
/// без запуска приложения. Здесь же живут преобразования туда и обратно.
///
/// Первичный ключ Isar — целое число, а доменные сущности опознаются
/// строковым идентификатором, поэтому у каждой коллекции есть `uid`
/// с уникальным индексом и режимом замены: повторное сохранение той же
/// сущности обновляет запись, а не плодит дубли.

@collection
class BankEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late String name;
  late int colorValue;

  Bank toDomain() => Bank(id: uid, name: name, colorValue: colorValue);

  static BankEntity fromDomain(Bank b) => BankEntity()
    ..uid = b.id
    ..name = b.name
    ..colorValue = b.colorValue;
}

@collection
class CardEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  @Index()
  late String bankId;

  late String productName;
  late double baseRate;
  late int slotLimit;

  PaymentCard toDomain() => PaymentCard(
        id: uid,
        bankId: bankId,
        productName: productName,
        baseRate: baseRate,
        slotLimit: slotLimit,
      );

  static CardEntity fromDomain(PaymentCard c) => CardEntity()
    ..uid = c.id
    ..bankId = c.bankId
    ..productName = c.productName
    ..baseRate = c.baseRate
    ..slotLimit = c.slotLimit;
}

@collection
class OfferEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  @Index(composite: [CompositeIndex('cardId')])
  late String monthKey;

  late String cardId;
  late String categoryId;
  late double rate;

  @enumerated
  late OfferSource source;

  late double confidence;

  MonthlyOffer toDomain() => MonthlyOffer(
        id: uid,
        cardId: cardId,
        monthKey: monthKey,
        categoryId: categoryId,
        rate: rate,
        source: source,
        confidence: confidence,
      );

  static OfferEntity fromDomain(MonthlyOffer o) => OfferEntity()
    ..uid = o.id
    ..cardId = o.cardId
    ..monthKey = o.monthKey
    ..categoryId = o.categoryId
    ..rate = o.rate
    ..source = o.source
    ..confidence = o.confidence;
}

@collection
class SelectionEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  @Index(composite: [CompositeIndex('cardId')])
  late String monthKey;

  late String cardId;
  late String categoryId;

  @enumerated
  late SelectionStatus status;

  Selection toDomain() => Selection(
        id: uid,
        cardId: cardId,
        monthKey: monthKey,
        categoryId: categoryId,
        status: status,
      );

  static SelectionEntity fromDomain(Selection s) => SelectionEntity()
    ..uid = s.id
    ..cardId = s.cardId
    ..monthKey = s.monthKey
    ..categoryId = s.categoryId
    ..status = s.status;
}

@collection
class WeightEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String categoryId;

  late double weight;

  CategoryWeight toDomain() =>
      CategoryWeight(categoryId: categoryId, weight: weight);

  static WeightEntity fromDomain(CategoryWeight w) => WeightEntity()
    ..categoryId = w.categoryId
    ..weight = w.weight;
}

@collection
class RecognitionLogEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late DateTime at;
  late String rawText;
  late int foundCount;
  late List<String> unmatchedStrings;

  RecognitionLog toDomain() => RecognitionLog(
        id: uid,
        at: at,
        rawText: rawText,
        foundCount: foundCount,
        unmatchedStrings: unmatchedStrings,
      );

  static RecognitionLogEntity fromDomain(RecognitionLog l) =>
      RecognitionLogEntity()
        ..uid = l.id
        ..at = l.at
        ..rawText = l.rawText
        ..foundCount = l.foundCount
        ..unmatchedStrings = l.unmatchedStrings;
}

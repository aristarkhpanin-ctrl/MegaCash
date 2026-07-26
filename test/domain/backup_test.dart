import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/domain/backup/backup.dart';
import 'package:megacash/domain/models/bank.dart';
import 'package:megacash/domain/models/category_weight.dart';
import 'package:megacash/domain/models/monthly_offer.dart';
import 'package:megacash/domain/models/payment_card.dart';
import 'package:megacash/domain/models/selection.dart';

/// Копия — единственная защита от потери всех данных вместе с телефоном.
/// Ошибка здесь обнаруживается ровно в тот момент, когда исправить её
/// уже нечем.
void main() {
  final sample = Backup(
    createdAt: DateTime.utc(2026, 7, 25),
    banks: const [
      Bank(id: 'b1', name: 'Т-Банк', colorValue: 0xFF1C1C1E),
      Bank(id: 'b2', name: 'Сбербанк', colorValue: 0xFF21A038),
    ],
    cards: const [
      PaymentCard(
        id: 'c1',
        bankId: 'b1',
        productName: 'Black',
        baseRate: 1.5,
        slotLimit: 4,
      ),
    ],
    offers: const [
      MonthlyOffer(
        id: 'o1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'supermarkets',
        rate: 7,
        source: OfferSource.ocr,
        confidence: 0.8,
        note: 'Зарплатным клиентам',
      ),
    ],
    selections: const [
      Selection(
        id: 's1',
        cardId: 'c1',
        monthKey: '2026-07',
        categoryId: 'supermarkets',
        status: SelectionStatus.activated,
      ),
    ],
    weights: const [
      CategoryWeight(categoryId: 'supermarkets', weight: 15),
    ],
  );

  test('копия переживает запись и чтение без потерь', () {
    final restored = Backup.decode(sample.encode());

    expect(restored, isNotNull);
    expect(restored!.banks, hasLength(2));
    expect(restored.banks.first.name, 'Т-Банк');
    expect(restored.banks.first.colorValue, 0xFF1C1C1E);

    final card = restored.cards.single;
    expect(card.productName, 'Black');
    expect(card.baseRate, 1.5);
    expect(card.slotLimit, 4);

    final offer = restored.offers.single;
    expect(offer.rate, 7);
    expect(offer.source, OfferSource.ocr);
    expect(offer.confidence, 0.8);
    expect(offer.note, 'Зарплатным клиентам');

    expect(restored.selections.single.status, SelectionStatus.activated);
    expect(restored.weights.single.weight, 15);
  });

  /// Веса накапливаются месяцами и восстановить их иначе нечем.
  test('накопленные веса попадают в копию', () {
    final restored = Backup.decode(sample.encode())!;
    expect(restored.weights.single.categoryId, 'supermarkets');
    expect(restored.weights.single.weight, 15);
  });

  test('файл читается человеком', () {
    final text = sample.encode();
    expect(text, contains('"Т-Банк"'));
    expect(text, contains('"supermarkets"'));
    expect(text, contains('\n'), reason: 'json с отступами, а не в одну строку');
  });

  group('Порча и подмена файла', () {
    test('посторонний файл не принимается', () {
      expect(Backup.decode('это не копия'), isNull);
      expect(Backup.decode('{}'), isNull);
      expect(Backup.decode('[]'), isNull);
      expect(Backup.decode(''), isNull);
    });

    test('копия из будущей версии не принимается', () {
      final future = sample.encode().replaceFirst(
            '"version": 1',
            '"version": 99',
          );
      expect(
        Backup.decode(future),
        isNull,
        reason: 'формат мог измениться так, что чтение испортит данные',
      );
    });

    test('обрезанный файл не принимается', () {
      final text = sample.encode();
      expect(Backup.decode(text.substring(0, text.length ~/ 2)), isNull);
    });

    test('битые записи пропускаются, целые сохраняются', () {
      const raw = '''
      {
        "version": 1,
        "banks": [
          {"id": "b1", "name": "Т-Банк", "color": 100},
          {"name": "без идентификатора"},
          "вообще не объект"
        ],
        "cards": [
          {"id": "c1", "bankId": "b1", "productName": "Black"}
        ]
      }
      ''';
      final restored = Backup.decode(raw);
      expect(restored, isNotNull);
      expect(restored!.banks, hasLength(1));
      expect(restored.cards, hasLength(1));
      // Отсутствующие поля берут разумные значения, а не роняют разбор.
      expect(restored.cards.single.baseRate, 0);
      expect(restored.cards.single.slotLimit, 3);
    });

    test('пустая копия не считается пригодной для восстановления', () {
      const empty = Backup(
        banks: [],
        cards: [],
        offers: [],
        selections: [],
        weights: [],
      );
      expect(empty.isEmpty, isTrue);

      final decoded = Backup.decode(empty.encode());
      expect(decoded, isNotNull);
      expect(decoded!.isEmpty, isTrue);
    });
  });
}

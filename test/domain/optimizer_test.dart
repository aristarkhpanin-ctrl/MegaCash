import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/domain/models/monthly_offer.dart';
import 'package:megacash/domain/models/payment_card.dart';
import 'package:megacash/domain/optimizer/optimization_result.dart';
import 'package:megacash/domain/optimizer/optimizer.dart';

/// Обязательные тесты из раздела 5.8 техзадания.
///
/// Без них ошибки не видны: алгоритм не падает, он просто тихо советует
/// неоптимальное, и пользователь теряет деньги, не догадываясь об этом.
void main() {
  const optimizer = CashbackOptimizer();

  var counter = 0;
  MonthlyOffer offer(String cardId, String categoryId, double rate) =>
      MonthlyOffer(
        id: 'o${counter++}',
        cardId: cardId,
        monthKey: '2026-07',
        categoryId: categoryId,
        rate: rate,
        source: OfferSource.manual,
      );

  PaymentCard card(String id, {double base = 1, int slots = 3}) => PaymentCard(
        id: id,
        bankId: 'b_$id',
        productName: id,
        baseRate: base,
        slotLimit: slots,
      );

  setUp(() => counter = 0);

  /// Какой карте досталась категория.
  String? cardFor(OptimizationResult r, String categoryId) => r.selected
      .where((a) => a.categoryId == categoryId)
      .map((a) => a.cardId)
      .firstOrNull;

  group('1 · Отсутствие дублей', () {
    test('одна категория уходит ровно одной карте — той, где процент выше',
        () {
      final result = optimizer.optimize(
        cards: [card('A'), card('B'), card('C')],
        offers: [
          offer('A', 'supermarkets', 7),
          offer('B', 'supermarkets', 5),
          offer('C', 'supermarkets', 3),
        ],
        weights: const {'supermarkets': 10},
      );

      final chosen =
          result.selected.where((a) => a.categoryId == 'supermarkets');
      expect(chosen, hasLength(1), reason: 'категория не может уйти в два банка');
      expect(chosen.single.cardId, 'A');

      // Проигравшим объясняем, кому досталось.
      final loser = result.rejected
          .where((r) => r.cardId == 'B' && r.categoryId == 'supermarkets')
          .single;
      expect(loser.reason, RejectionReason.takenByAnotherCard);
      expect(loser.takenByCardId, 'A');
    });

    test('наивная сумма ставок 7+5+3 не является ответом', () {
      final result = optimizer.optimize(
        cards: [card('A'), card('B'), card('C')],
        offers: [
          offer('A', 'supermarkets', 7),
          offer('B', 'supermarkets', 5),
          offer('C', 'supermarkets', 3),
        ],
        weights: const {'supermarkets': 10},
      );

      final sumOfRates =
          result.selected.fold<double>(0, (s, a) => s + a.rate);
      expect(sumOfRates, 7, reason: 'сгоревшие слоты не приносят ничего');
    });
  });

  group('2 · Веса важнее ставок', () {
    test('А берёт супермаркеты, Б берёт такси', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 1), card('B', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 7),
          offer('A', 'taxi', 7),
          offer('B', 'supermarkets', 5),
          offer('B', 'taxi', 3),
        ],
        weights: const {'supermarkets': 10, 'taxi': 1},
      );

      expect(cardFor(result, 'supermarkets'), 'A');
      expect(cardFor(result, 'taxi'), 'B');

      // Правильный вариант даёт 10×6 + 1×2 = 62, неправильный 1×6 + 10×4 = 46.
      // Реализация без весов выбрала бы неправильный: там сумма ставок
      // 12 против 10.
      expect(result.totalBenefit, closeTo(62, 0.001));
    });
  });

  group('3 · Свободные слоты', () {
    test('лимит 4, выгодных предложений 2 — два слота остаются свободными',
        () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 4)],
        offers: [
          offer('A', 'supermarkets', 5),
          offer('A', 'cafe', 7),
        ],
        weights: const {'supermarkets': 10, 'cafe': 7},
      );

      expect(result.selected, hasLength(2));
      expect(result.freeSlots, hasLength(2));
      expect(result.freeSlots, everyElement('A'));
    });

    test('предложений нет вовсе — все слоты свободны', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 3)],
        offers: const [],
        weights: const {},
      );

      expect(result.selected, isEmpty);
      expect(result.freeSlots, hasLength(3));
    });
  });

  group('4 · Ставка не выше базовой', () {
    test('категория под 4% при базовых 5% не выбирается', () {
      final result = optimizer.optimize(
        cards: [card('A', base: 5)],
        offers: [offer('A', 'supermarkets', 4)],
        weights: const {'supermarkets': 10},
      );

      expect(result.selected, isEmpty);
      expect(
        result.rejected.single.reason,
        RejectionReason.rateNotAboveBase,
      );
      expect(result.freeSlots, hasLength(3));
    });

    test('ставка ровно равна базовой тоже не выбирается', () {
      final result = optimizer.optimize(
        cards: [card('A', base: 5)],
        offers: [offer('A', 'supermarkets', 5)],
        weights: const {'supermarkets': 10},
      );

      expect(result.selected, isEmpty);
      expect(
        result.rejected.single.reason,
        RejectionReason.rateNotAboveBase,
      );
    });

    test('базовая берётся наибольшая по всем картам, а не по своей', () {
      // У карты Б базовый 1%, но у А — 5%. Предложение Б под 4% не даёт
      // ничего: платить выгоднее картой А вообще без выбранных категорий.
      final result = optimizer.optimize(
        cards: [card('A', base: 5), card('B', base: 1)],
        offers: [offer('B', 'supermarkets', 4)],
        weights: const {'supermarkets': 10},
      );

      expect(result.selected, isEmpty);
      expect(
        result.rejected.single.reason,
        RejectionReason.rateNotAboveBase,
      );
    });
  });

  group('5 · «Все покупки»', () {
    test('ветвь обычных категорий: три по 6% перевешивают все покупки 5%', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 3)],
        offers: [
          offer('A', 'all_purchases', 5),
          offer('A', 'books', 6),
          offer('A', 'games', 6),
          offer('A', 'music', 6),
        ],
        weights: const {'books': 1, 'games': 1, 'music': 1},
      );

      // Обычные: 3 × 1 × 5 = 15. Все покупки: 3 × 4 = 12.
      expect(cardFor(result, 'all_purchases'), isNull);
      expect(result.selected, hasLength(3));
    });

    test('ветвь всех покупок: 9% перевешивают три по 6%', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 3)],
        offers: [
          offer('A', 'all_purchases', 9),
          offer('A', 'books', 6),
          offer('A', 'games', 6),
          offer('A', 'music', 6),
        ],
        weights: const {'books': 1, 'games': 1, 'music': 1},
      );

      // Все покупки: 3 × 8 = 24 против 15.
      expect(cardFor(result, 'all_purchases'), 'A');
      expect(result.selected, hasLength(1), reason: 'прочие слоты не занимаем');

      for (final r in result.rejected) {
        expect(r.reason, RejectionReason.cardTakenByAllPurchases);
      }
      // Намеренно пустые слоты не считаются «нечем заполнить».
      expect(result.freeSlots, isEmpty);
    });

    test('«все покупки» весят как все расходы, а не как одна категория', () {
      // 2% на всё против 7% на супермаркеты при базовых 1%.
      // Супермаркеты — лишь часть трат, поэтому побеждает «на всё».
      final result = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'all_purchases', 2),
          offer('A', 'supermarkets', 7),
        ],
        weights: const {
          'supermarkets': 10,
          'cafe': 7,
          'pharmacy': 6,
          'clothes': 5,
          'home': 4,
          'fuel': 4,
        },
      );

      // Все покупки: 36 × 1 = 36. Супермаркеты: 10 × 6 = 60. Слот один.
      expect(cardFor(result, 'supermarkets'), 'A');

      final wider = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'all_purchases', 4),
          offer('A', 'supermarkets', 7),
        ],
        weights: const {
          'supermarkets': 10,
          'cafe': 7,
          'pharmacy': 6,
          'clothes': 5,
          'home': 4,
          'fuel': 4,
        },
      );
      // Все покупки: 36 × 3 = 108 против 60.
      expect(cardFor(wider, 'all_purchases'), 'A');
    });

    test('«все покупки» не могут достаться двум картам сразу', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 1), card('B', slots: 1)],
        offers: [
          offer('A', 'all_purchases', 9),
          offer('B', 'all_purchases', 5),
        ],
        weights: const {'supermarkets': 10},
      );

      final all =
          result.selected.where((a) => a.categoryId == 'all_purchases');
      expect(all, hasLength(1));
      expect(all.single.cardId, 'A');
    });
  });

  group('6 · Переброс с пересчётом', () {
    test('после фиксации категории остальное распределение меняется', () {
      final cards = [card('A', slots: 1), card('B', slots: 1)];
      final offers = [
        offer('A', 'supermarkets', 9),
        offer('A', 'cafe', 6),
        offer('B', 'supermarkets', 6),
        offer('B', 'cafe', 3),
      ];
      const weights = <String, double>{'supermarkets': 10, 'cafe': 7};

      final before = optimizer.optimize(
        cards: cards,
        offers: offers,
        weights: weights,
      );
      // A берёт супермаркеты (10×8 = 80), B — кафе (7×2 = 14), итого 94.
      // Обратное размещение дало бы 7×5 + 10×5 = 85.
      expect(cardFor(before, 'supermarkets'), 'A');
      expect(cardFor(before, 'cafe'), 'B');
      expect(before.totalBenefit, closeTo(94, 0.001));

      // Пользователь настоял: кафе — на карту A.
      final after = optimizer.optimizeWithPins(
        cards: cards,
        offers: offers,
        weights: weights,
        pinned: [
          const Assignment(cardId: 'A', categoryId: 'cafe', rate: 6),
        ],
        excluded: const [],
      );

      expect(cardFor(after, 'cafe'), 'A');
      // Слот A занят, поэтому супермаркеты не остались без карты,
      // а переехали на B — это и есть пересчёт, а не обмен строк.
      expect(
        cardFor(after, 'supermarkets'),
        'B',
        reason: 'освободившийся слот должен пересчитаться',
      );
    });

    test('отправленная в «не выбранные» категория не возвращается', () {
      final result = optimizer.optimizeWithPins(
        cards: [card('A', slots: 2)],
        offers: [
          offer('A', 'supermarkets', 7),
          offer('A', 'cafe', 6),
        ],
        weights: const {'supermarkets': 10, 'cafe': 7},
        pinned: const [],
        excluded: const ['supermarkets'],
      );

      expect(cardFor(result, 'supermarkets'), isNull);
      expect(cardFor(result, 'cafe'), 'A');
      expect(
        result.rejected.single.reason,
        RejectionReason.excludedByUser,
      );
    });

    test('фиксация не даёт той же категории уйти в другой банк', () {
      final result = optimizer.optimizeWithPins(
        cards: [card('A', slots: 1), card('B', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 3),
          offer('B', 'supermarkets', 7),
        ],
        weights: const {'supermarkets': 10},
        pinned: [
          const Assignment(cardId: 'A', categoryId: 'supermarkets', rate: 3),
        ],
        excluded: const [],
      );

      expect(cardFor(result, 'supermarkets'), 'A');
      final other = result.rejected
          .where((r) => r.cardId == 'B' && r.categoryId == 'supermarkets')
          .single;
      expect(other.reason, RejectionReason.takenByAnotherCard);
      expect(other.takenByCardId, 'A');
    });
  });

  group('7 · Граничные случаи', () {
    test('ноль карт', () {
      final result = optimizer.optimize(
        cards: const [],
        offers: [offer('A', 'supermarkets', 7)],
        weights: const {'supermarkets': 10},
      );

      expect(result.selected, isEmpty);
      expect(result.freeSlots, isEmpty);
    });

    test('одна карта', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 2)],
        offers: [
          offer('A', 'supermarkets', 5),
          offer('A', 'cafe', 7),
          offer('A', 'flowers', 9),
        ],
        weights: const {'supermarkets': 10, 'cafe': 7, 'flowers': 0.5},
      );

      // 10×4 = 40, 7×6 = 42, 0.5×8 = 4 — берём два лучших.
      expect(result.selected, hasLength(2));
      expect(cardFor(result, 'flowers'), isNull);
      expect(cardFor(result, 'cafe'), 'A');
      expect(cardFor(result, 'supermarkets'), 'A');
    });

    test('карта без предложений', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 3), card('B', slots: 2)],
        offers: [offer('A', 'supermarkets', 5)],
        weights: const {'supermarkets': 10},
      );

      expect(result.selected, hasLength(1));
      expect(result.freeSlots.where((c) => c == 'B'), hasLength(2));
      expect(result.freeSlots.where((c) => c == 'A'), hasLength(2));
    });

    test('две карты с одинаковыми предложениями', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 2), card('B', slots: 2)],
        offers: [
          offer('A', 'supermarkets', 5),
          offer('A', 'cafe', 5),
          offer('B', 'supermarkets', 5),
          offer('B', 'cafe', 5),
        ],
        weights: const {'supermarkets': 10, 'cafe': 7},
      );

      // Каждая категория ровно один раз; какой карте — неважно,
      // выгода одинаковая. Важно, что дублей нет и слоты не сгорели.
      expect(result.selected, hasLength(2));
      expect(
        result.selected.map((a) => a.categoryId).toSet(),
        {'supermarkets', 'cafe'},
      );
      expect(result.freeSlots, hasLength(2));
    });

    test('предложения от несуществующей карты игнорируются', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 5),
          offer('удалённая', 'cafe', 9),
        ],
        weights: const {'supermarkets': 10, 'cafe': 7},
      );

      expect(result.selected, hasLength(1));
      expect(result.selected.single.cardId, 'A');
      expect(result.rejected, isEmpty);
    });

    test('пустая таблица весов — все категории весят одинаково', () {
      final result = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 5),
          offer('A', 'cafe', 9),
        ],
        weights: const {},
      );

      expect(cardFor(result, 'cafe'), 'A', reason: 'при равных весах решает ставка');
    });
  });

  group('Правило 6 · равная выгода решается таблицей весов', () {
    test('при одинаковой выгоде побеждает категория с большим весом', () {
      // Обе дают 20: 10×2 и 5×4. Побеждает та, что выше в таблице весов.
      final result = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 3),
          offer('A', 'clothes', 5),
        ],
        weights: const {'supermarkets': 10, 'clothes': 5},
      );

      expect(cardFor(result, 'supermarkets'), 'A');
    });

    test('результат не зависит от порядка предложений на входе', () {
      const weights = {'supermarkets': 10.0, 'clothes': 5.0, 'cafe': 7.0};
      final forward = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 3),
          offer('A', 'clothes', 5),
        ],
        weights: weights,
      );
      counter = 0;
      final backward = optimizer.optimize(
        cards: [card('A', slots: 1)],
        offers: [
          offer('A', 'clothes', 5),
          offer('A', 'supermarkets', 3),
        ],
        weights: weights,
      );

      expect(
        forward.selected.single.categoryId,
        backward.selected.single.categoryId,
      );
    });
  });

  group('Оптимальность на составных случаях', () {
    test('глобальный оптимум важнее локальной жадности', () {
      // Жадный перебор отдал бы супермаркеты карте A (7% — самое большое
      // предложение), и кафе досталось бы B под 3%: 10×6 + 7×2 = 74.
      // Оптимум: A берёт кафе, B — супермаркеты: 7×7 + 10×5 = 99.
      final result = optimizer.optimize(
        cards: [card('A', slots: 1), card('B', slots: 1)],
        offers: [
          offer('A', 'supermarkets', 7),
          offer('A', 'cafe', 8),
          offer('B', 'supermarkets', 6),
          offer('B', 'cafe', 3),
        ],
        weights: const {'supermarkets': 10, 'cafe': 7},
      );

      expect(cardFor(result, 'cafe'), 'A');
      expect(cardFor(result, 'supermarkets'), 'B');
      expect(result.totalBenefit, closeTo(99, 0.001));
    });

    test('пять карт и двадцать категорий: ни одного дубля, лимиты целы', () {
      final cards = [
        card('sber', slots: 3),
        card('alfa', base: 1.5, slots: 3),
        card('tb', slots: 4),
        card('vtb', slots: 2),
        card('raif', base: 1.5, slots: 5),
      ];

      const categories = [
        'supermarkets', 'cafe', 'pharmacy', 'clothes', 'home',
        'fuel', 'transport', 'taxi', 'marketplace', 'electronics',
        'beauty', 'entertainment', 'jewelry', 'flowers', 'books',
        'sport', 'travel', 'kids', 'pets', 'cinema',
      ];
      const weights = {
        'supermarkets': 10.0, 'cafe': 7.0, 'pharmacy': 6.0, 'clothes': 5.0,
        'home': 4.0, 'fuel': 4.0, 'transport': 3.0, 'taxi': 3.0,
        'marketplace': 3.0, 'electronics': 2.0, 'beauty': 2.0,
        'entertainment': 2.0, 'jewelry': 0.5, 'flowers': 0.5,
      };

      final offers = <MonthlyOffer>[];
      for (var c = 0; c < cards.length; c++) {
        for (var i = 0; i < categories.length; i++) {
          // Разные банки дают разные проценты на одни и те же категории.
          final rate = 2 + ((i * 3 + c * 7) % 9);
          offers.add(offer(cards[c].id, categories[i], rate.toDouble()));
        }
      }

      final result = optimizer.optimize(
        cards: cards,
        offers: offers,
        weights: weights,
      );

      final chosenCategories = result.selected.map((a) => a.categoryId);
      expect(
        chosenCategories.toSet().length,
        chosenCategories.length,
        reason: 'ни одна категория не должна уйти в два банка',
      );

      final byCard = result.occupiedByCard;
      for (final c in cards) {
        expect(
          byCard[c.id] ?? 0,
          lessThanOrEqualTo(c.slotLimit),
          reason: 'лимит карты ${c.id}',
        );
      }

      // Слотов всего 17, выгодных категорий больше — значит всё занято.
      expect(result.selected, hasLength(17));
      expect(result.freeSlots, isEmpty);
    });

    test('перебор подтверждает оптимальность на маленькой задаче', () {
      final cards = [card('A', slots: 1), card('B', slots: 1), card('C', slots: 1)];
      const weights = <String, double>{'a': 10, 'b': 7, 'c': 4, 'd': 1};
      final rates = {
        'A': {'a': 5.0, 'b': 9.0, 'c': 3.0, 'd': 8.0},
        'B': {'a': 7.0, 'b': 4.0, 'c': 6.0, 'd': 2.0},
        'C': {'a': 4.0, 'b': 6.0, 'c': 9.0, 'd': 5.0},
      };

      final offers = [
        for (final card in rates.keys)
          for (final cat in rates[card]!.keys)
            offer(card, cat, rates[card]![cat]!),
      ];

      final result = optimizer.optimize(
        cards: cards,
        offers: offers,
        weights: weights,
      );

      // Полный перебор всех размещений трёх категорий по трём картам.
      final categories = weights.keys.toList();
      var best = 0.0;
      for (final a in categories) {
        for (final b in categories) {
          if (b == a) continue;
          for (final c in categories) {
            if (c == a || c == b) continue;
            var sum = 0.0;
            for (final pair in [('A', a), ('B', b), ('C', c)]) {
              final gain = rates[pair.$1]![pair.$2]! - 1;
              if (gain > 0) sum += weights[pair.$2]! * gain;
            }
            if (sum > best) best = sum;
          }
        }
      }

      expect(result.totalBenefit, closeTo(best, 0.001));
    });
  });

  group('Сверка со случайным перебором', () {
    /// Полный перебор всех допустимых размещений: каждая категория либо
    /// не выбрана, либо уходит ровно одной карте, у карты не больше
    /// slotLimit категорий.
    double bruteForce({
      required List<PaymentCard> cards,
      required List<MonthlyOffer> offers,
      required Map<String, double> weights,
    }) {
      final maxBase =
          cards.map((c) => c.baseRate).reduce((a, b) => a > b ? a : b);
      final categories = offers.map((o) => o.categoryId).toSet().toList();
      final rate = <String, double>{
        for (final o in offers) '${o.cardId}|${o.categoryId}': o.rate,
      };

      var best = 0.0;

      void walk(int index, Map<String, int> used, double sum) {
        if (index == categories.length) {
          if (sum > best) best = sum;
          return;
        }
        final category = categories[index];

        // Вариант: категорию не берём вовсе.
        walk(index + 1, used, sum);

        for (final card in cards) {
          final taken = used[card.id] ?? 0;
          if (taken >= card.slotLimit) continue;
          final r = rate['${card.id}|$category'];
          if (r == null) continue;
          final gain = r - maxBase;
          if (gain <= 0) continue;

          used[card.id] = taken + 1;
          walk(
            index + 1,
            used,
            sum + (weights[category] ?? 1) * gain,
          );
          used[card.id] = taken;
        }
      }

      walk(0, <String, int>{}, 0);
      return best;
    }

    test('на ста случайных задачах выгода совпадает с перебором', () {
      final random = Random(20260725);

      for (var attempt = 0; attempt < 100; attempt++) {
        counter = 0;
        final cardCount = 1 + random.nextInt(3);
        final categoryCount = 1 + random.nextInt(5);

        final cards = [
          for (var i = 0; i < cardCount; i++)
            card(
              'card$i',
              base: [0.5, 1.0, 1.5, 2.0][random.nextInt(4)],
              slots: 1 + random.nextInt(3),
            ),
        ];

        final weights = <String, double>{
          for (var i = 0; i < categoryCount; i++)
            'cat$i': [0.5, 1.0, 2.0, 5.0, 7.0, 10.0][random.nextInt(6)],
        };

        final offers = <MonthlyOffer>[];
        for (final c in cards) {
          for (var i = 0; i < categoryCount; i++) {
            // Не каждый банк предлагает каждую категорию.
            if (random.nextInt(4) == 0) continue;
            offers.add(
              offer(c.id, 'cat$i', (1 + random.nextInt(10)).toDouble()),
            );
          }
        }

        final result = optimizer.optimize(
          cards: cards,
          offers: offers,
          weights: weights,
        );
        final expected = bruteForce(
          cards: cards,
          offers: offers,
          weights: weights,
        );

        expect(
          result.totalBenefit,
          closeTo(expected, 0.001),
          reason: 'задача №$attempt: карт ${cards.length}, '
              'категорий $categoryCount, предложений ${offers.length}',
        );

        // Заодно инварианты: ни дублей, ни превышения лимитов.
        final chosen = result.selected.map((a) => a.categoryId).toList();
        expect(chosen.toSet().length, chosen.length);
        final byCard = result.occupiedByCard;
        for (final c in cards) {
          expect(byCard[c.id] ?? 0, lessThanOrEqualTo(c.slotLimit));
        }
      }
    });
  });
}

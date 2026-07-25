import '../models/monthly_offer.dart';
import '../models/payment_card.dart';
import 'hungarian.dart';
import 'optimization_result.dart';

/// Подбор категорий по картам.
///
/// Ключевое правило, которое ломает наивную реализацию: одну и ту же
/// категорию нельзя выбирать в двух банках. Если три банка предлагают
/// супермаркеты под 7%, 5% и 3%, выбор супермаркетов во втором и третьем
/// не даёт ничего — в магазине человек платит один раз и одной картой,
/// той, где 7%. Наивная реализация сложит 7+5+3, посчитает это отличным
/// результатом, и пользователь потеряет деньги.
///
/// Поэтому здесь задача о назначениях, решаемая точно, а не жадный перебор.
class CashbackOptimizer {
  const CashbackOptimizer({
    this.allPurchasesCategoryId = 'all_purchases',
  });

  /// Идентификатор категории «На все покупки».
  final String allPurchasesCategoryId;

  /// Вес категории, не найденной в таблице весов: «все прочие — 1».
  static const double defaultWeight = 1;

  /// Разница выгод меньше этой величины считается равенством —
  /// тогда побеждает категория выше в таблице весов.
  static const double _tieEpsilon = 1e-9;

  OptimizationResult optimize({
    required List<PaymentCard> cards,
    required List<MonthlyOffer> offers,
    required Map<String, double> weights,
  }) {
    return optimizeWithPins(
      cards: cards,
      offers: offers,
      weights: weights,
      pinned: const [],
      excluded: const [],
    );
  }

  /// То же, но с учётом решений пользователя.
  ///
  /// Когда пользователь перетаскивает категорию между столбцами, менять
  /// местами две строки нельзя: освободившийся слот может изменить
  /// оптимальное распределение в других банках — категория могла держаться
  /// там только потому, что другой банк был занят. Поэтому выбор
  /// пользователя фиксируется жёстким ограничением, а всё остальное
  /// пересчитывается заново.
  OptimizationResult optimizeWithPins({
    required List<PaymentCard> cards,
    required List<MonthlyOffer> offers,
    required Map<String, double> weights,
    required List<Assignment> pinned,
    required List<String> excluded,
  }) {
    if (cards.isEmpty) return const OptimizationResult.empty();

    final cardById = {for (final c in cards) c.id: c};
    final maxBaseRate =
        cards.map((c) => c.baseRate).reduce((a, b) => a > b ? a : b);

    // Предложения от карт, которых у пользователя нет, игнорируем молча:
    // они остались от удалённой карты и объяснять тут нечего.
    final live = offers.where((o) => cardById.containsKey(o.cardId)).toList();

    final selected = <Assignment>[];
    final rejected = <Rejection>[];

    final excludedSet = excluded.toSet();
    final pinnedByCategory = {for (final p in pinned) p.categoryId: p};

    // Слоты, занятые решениями пользователя.
    final usedSlots = <String, int>{};

    for (final pin in pinned) {
      final card = cardById[pin.cardId];
      if (card == null) continue;
      selected.add(
        Assignment(
          cardId: pin.cardId,
          categoryId: pin.categoryId,
          rate: pin.rate,
          benefit: _benefit(pin.categoryId, pin.rate, maxBaseRate, weights),
        ),
      );
      usedSlots[pin.cardId] = (usedSlots[pin.cardId] ?? 0) + 1;
    }

    // Категории, о которых больше не надо думать: пользователь уже
    // распорядился ими сам.
    final decided = {...excludedSet, ...pinnedByCategory.keys};

    final candidates = <MonthlyOffer>[];
    for (final offer in live) {
      if (excludedSet.contains(offer.categoryId)) {
        rejected.add(
          _reject(offer, RejectionReason.excludedByUser),
        );
        continue;
      }
      if (pinnedByCategory.containsKey(offer.categoryId)) {
        final pin = pinnedByCategory[offer.categoryId]!;
        if (pin.cardId != offer.cardId) {
          rejected.add(
            _reject(
              offer,
              RejectionReason.takenByAnotherCard,
              takenByCardId: pin.cardId,
            ),
          );
        }
        continue;
      }
      if (offer.rate <= maxBaseRate) {
        rejected.add(_reject(offer, RejectionReason.rateNotAboveBase));
        continue;
      }
      candidates.add(offer);
    }

    // «На все покупки» разбирается отдельной ветвью до основного алгоритма:
    // она совпадает с любой тратой и потому пересекается со всеми
    // остальными категориями сразу, а обычное назначение считает её
    // такой же строкой матрицы и ошибается.
    final allPurchasesCardId = _pickAllPurchasesCard(
      cards: cards,
      candidates: candidates,
      weights: weights,
      maxBaseRate: maxBaseRate,
      usedSlots: usedSlots,
      decided: decided,
    );

    if (allPurchasesCardId != null) {
      final offer = candidates.firstWhere(
        (o) =>
            o.cardId == allPurchasesCardId &&
            o.categoryId == allPurchasesCategoryId,
      );
      selected.add(
        Assignment(
          cardId: offer.cardId,
          categoryId: offer.categoryId,
          rate: offer.rate,
          benefit: _allPurchasesBenefit(offer.rate, maxBaseRate, weights),
        ),
      );
    }

    // Оставшиеся кандидаты: без «всех покупок» и без предложений той карты,
    // которая целиком ушла под «все покупки».
    final forMatrix = <MonthlyOffer>[];
    for (final offer in candidates) {
      if (offer.categoryId == allPurchasesCategoryId) {
        if (offer.cardId != allPurchasesCardId) {
          rejected.add(
            allPurchasesCardId == null
                ? _reject(offer, RejectionReason.cardSlotsFull)
                : _reject(
                    offer,
                    RejectionReason.takenByAnotherCard,
                    takenByCardId: allPurchasesCardId,
                  ),
          );
        }
        continue;
      }
      if (offer.cardId == allPurchasesCardId) {
        rejected.add(
          _reject(offer, RejectionReason.cardTakenByAllPurchases),
        );
        continue;
      }
      forMatrix.add(offer);
    }

    final matrixResult = _solve(
      cards: cards,
      offers: forMatrix,
      weights: weights,
      maxBaseRate: maxBaseRate,
      usedSlots: usedSlots,
      skipCardId: allPurchasesCardId,
    );

    selected.addAll(matrixResult.selected);
    rejected.addAll(matrixResult.rejected);

    return OptimizationResult(
      selected: selected,
      rejected: rejected,
      freeSlots: _freeSlots(
        cards: cards,
        selected: selected,
        allPurchasesCardId: allPurchasesCardId,
      ),
    );
  }

  // ---------------------------------------------------------------- выгода

  double _weightOf(String categoryId, Map<String, double> weights) =>
      weights[categoryId] ?? defaultWeight;

  /// Прирост сверх базовой ставки.
  ///
  /// Вычитаем наибольший базовый процент потому, что даже без выбранной
  /// категории человек что-то получит: оптимизировать надо прирост,
  /// а не саму ставку.
  double _benefit(
    String categoryId,
    double rate,
    double maxBaseRate,
    Map<String, double> weights,
  ) {
    final gain = rate - maxBaseRate;
    if (gain <= 0) return 0;
    return _weightOf(categoryId, weights) * gain;
  }

  /// Выгода от «всех покупок».
  ///
  /// Эта категория совпадает с любой тратой, поэтому её вес — суммарный
  /// вес всех остальных категорий, то есть все расходы целиком. Иначе
  /// «2% на всё» всегда проигрывало бы «7% на супермаркеты», хотя на деле
  /// выигрывает: супермаркеты — лишь часть трат.
  double _allPurchasesBenefit(
    double rate,
    double maxBaseRate,
    Map<String, double> weights,
  ) {
    final gain = rate - maxBaseRate;
    if (gain <= 0) return 0;
    var total = 0.0;
    for (final entry in weights.entries) {
      if (entry.key == allPurchasesCategoryId) continue;
      total += entry.value;
    }
    if (total <= 0) total = defaultWeight;
    return total * gain;
  }

  /// Какая карта уходит под «все покупки», если такая есть.
  ///
  /// Правило из техзадания: если для карты выгода от «всех покупок»
  /// превышает суммарную выгоду от её же лучших `slotLimit` обычных
  /// категорий — рекомендуем «все покупки», а остальные слоты этой карты
  /// не занимаем. Категория одна, поэтому среди подходящих карт берём
  /// ту, где выгода больше.
  String? _pickAllPurchasesCard({
    required List<PaymentCard> cards,
    required List<MonthlyOffer> candidates,
    required Map<String, double> weights,
    required double maxBaseRate,
    required Map<String, int> usedSlots,
    required Set<String> decided,
  }) {
    if (decided.contains(allPurchasesCategoryId)) return null;

    String? best;
    var bestBenefit = 0.0;

    for (final card in cards) {
      final allOffer = candidates
          .where(
            (o) =>
                o.cardId == card.id &&
                o.categoryId == allPurchasesCategoryId,
          )
          .firstOrNull;
      if (allOffer == null) continue;

      final free = card.slotLimit - (usedSlots[card.id] ?? 0);
      if (free <= 0) continue;

      final benefitAll =
          _allPurchasesBenefit(allOffer.rate, maxBaseRate, weights);
      if (benefitAll <= 0) continue;

      // Лучшее, что карта могла бы набрать обычными категориями, если бы
      // никто с ней не конкурировал. Оценка сверху — и этого достаточно:
      // если «все покупки» перебивают даже её, тем более перебьют то,
      // что достанется карте в реальной конкуренции.
      final regular = candidates
          .where(
            (o) =>
                o.cardId == card.id &&
                o.categoryId != allPurchasesCategoryId,
          )
          .map((o) => _benefit(o.categoryId, o.rate, maxBaseRate, weights))
          .toList()
        ..sort((a, b) => b.compareTo(a));

      final bestRegular = regular
          .take(free)
          .fold<double>(0, (sum, value) => sum + value);

      if (benefitAll > bestRegular && benefitAll > bestBenefit) {
        best = card.id;
        bestBenefit = benefitAll;
      }
    }

    return best;
  }

  // ------------------------------------------------------------- матрица

  /// Разворачивает карты в слоты, строит матрицу и решает задачу
  /// о назначениях.
  _MatrixResult _solve({
    required List<PaymentCard> cards,
    required List<MonthlyOffer> offers,
    required Map<String, double> weights,
    required double maxBaseRate,
    required Map<String, int> usedSlots,
    required String? skipCardId,
  }) {
    if (offers.isEmpty) {
      return const _MatrixResult(selected: [], rejected: []);
    }

    // Столбцы: карта с лимитом 3 даёт три одинаковых столбца.
    final slotCardIds = <String>[];
    for (final card in cards) {
      if (card.id == skipCardId) continue;
      final free = card.slotLimit - (usedSlots[card.id] ?? 0);
      for (var i = 0; i < free; i++) {
        slotCardIds.add(card.id);
      }
    }

    if (slotCardIds.isEmpty) {
      return _MatrixResult(
        selected: const [],
        rejected: [
          for (final o in offers) _reject(o, RejectionReason.cardSlotsFull),
        ],
      );
    }

    // Строки: категории. Строка используется не более одного раза —
    // это и есть гарантия того, что категория не уйдёт в два банка.
    final categoryIds = offers.map((o) => o.categoryId).toSet().toList()
      ..sort((a, b) {
        final byWeight =
            _weightOf(b, weights).compareTo(_weightOf(a, weights));
        return byWeight != 0 ? byWeight : a.compareTo(b);
      });

    final offerBy = <String, MonthlyOffer>{
      for (final o in offers) '${o.cardId}|${o.categoryId}': o,
    };

    // При равной выгоде должна побеждать категория выше в таблице весов.
    // Матрица уже отсортирована по весу, поэтому добавляем к выгоде
    // исчезающе малую надбавку по номеру строки: на настоящие различия
    // она повлиять не может, а равенство разрешает предсказуемо.
    final matrix = List.generate(
      categoryIds.length,
      (row) {
        final categoryId = categoryIds[row];
        final tieBonus = (categoryIds.length - row) * _tieEpsilon;
        return List.generate(
          slotCardIds.length,
          (col) {
            final offer = offerBy['${slotCardIds[col]}|$categoryId'];
            if (offer == null) return 0.0;
            final benefit =
                _benefit(categoryId, offer.rate, maxBaseRate, weights);
            return benefit <= 0 ? 0.0 : benefit + tieBonus;
          },
          growable: false,
        );
      },
      growable: false,
    );

    final rowToCol = maxAssignment(matrix);

    final selected = <Assignment>[];
    final takenBy = <String, String>{};

    for (var row = 0; row < rowToCol.length; row++) {
      final col = rowToCol[row];
      if (col < 0) continue;
      // Назначения с нулевой выгодой — это свободные слоты, а не выбор.
      if (matrix[row][col] <= 0) continue;

      final categoryId = categoryIds[row];
      final cardId = slotCardIds[col];
      final offer = offerBy['$cardId|$categoryId'];
      if (offer == null) continue;

      selected.add(
        Assignment(
          cardId: cardId,
          categoryId: categoryId,
          rate: offer.rate,
          benefit: _benefit(categoryId, offer.rate, maxBaseRate, weights),
        ),
      );
      takenBy[categoryId] = cardId;
    }

    final chosen = {for (final a in selected) '${a.cardId}|${a.categoryId}'};
    final rejected = <Rejection>[];

    for (final offer in offers) {
      if (chosen.contains('${offer.cardId}|${offer.categoryId}')) continue;

      final winner = takenBy[offer.categoryId];
      rejected.add(
        winner != null
            ? _reject(
                offer,
                RejectionReason.takenByAnotherCard,
                takenByCardId: winner,
              )
            : _reject(offer, RejectionReason.cardSlotsFull),
      );
    }

    return _MatrixResult(selected: selected, rejected: rejected);
  }

  /// По одному вхождению `cardId` на каждый незанятый слот.
  ///
  /// Карту, целиком отданную под «все покупки», не считаем: её слоты
  /// не «нечем заполнить», а намеренно оставлены пустыми.
  List<String> _freeSlots({
    required List<PaymentCard> cards,
    required List<Assignment> selected,
    required String? allPurchasesCardId,
  }) {
    final occupied = <String, int>{};
    for (final a in selected) {
      occupied[a.cardId] = (occupied[a.cardId] ?? 0) + 1;
    }

    final free = <String>[];
    for (final card in cards) {
      if (card.id == allPurchasesCardId) continue;
      final left = card.slotLimit - (occupied[card.id] ?? 0);
      for (var i = 0; i < left; i++) {
        free.add(card.id);
      }
    }
    return free;
  }

  static Rejection _reject(
    MonthlyOffer offer,
    RejectionReason reason, {
    String? takenByCardId,
  }) =>
      Rejection(
        cardId: offer.cardId,
        categoryId: offer.categoryId,
        rate: offer.rate,
        reason: reason,
        takenByCardId: takenByCardId,
      );
}

class _MatrixResult {
  const _MatrixResult({required this.selected, required this.rejected});

  final List<Assignment> selected;
  final List<Rejection> rejected;
}

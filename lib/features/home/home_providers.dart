import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/answer/payment_answer.dart';
import '../../domain/models/bank.dart';
import '../../domain/models/category.dart';
import '../../domain/models/month_key.dart';
import '../../domain/models/month_state.dart';
import '../../domain/models/monthly_offer.dart';

/// Текущий месяц. Отдельным провайдером, чтобы в тестах можно было
/// подставить любой.
final currentMonthProvider = Provider<String>((ref) => MonthKey.current());

/// Активная категория на главном экране.
class ActiveCategory {
  const ActiveCategory({
    required this.categoryId,
    required this.name,
    required this.rate,
    required this.cardId,
    required this.bankName,
    required this.bankColor,
  });

  final String categoryId;
  final String name;
  final double rate;
  final String cardId;
  final String bankName;
  final int bankColor;
}

/// Плитки главного экрана: что выбрано на этот месяц и в каком банке.
///
/// Порядок — по весу категории: наверху то, на что человек тратит больше.
final activeCategoriesProvider =
    FutureProvider<List<ActiveCategory>>((ref) async {
  final monthKey = ref.watch(currentMonthProvider);
  final selectionRepo = ref.watch(selectionRepositoryProvider);
  final offerRepo = ref.watch(offerRepositoryProvider);

  final cards = await ref.watch(cardsProvider.future);
  final selections = await selectionRepo.forMonth(monthKey);
  if (selections.isEmpty) return const [];

  final offers = await offerRepo.forMonth(monthKey);
  final categories = ref.watch(categoriesProvider);
  final weights = await ref.watch(weightsProvider.future);

  final categoryById = {for (final c in categories) c.id: c};
  final cardById = {for (final c in cards) c.card.id: c};
  final rateBy = <String, double>{
    for (final o in offers) '${o.cardId}|${o.categoryId}': o.rate,
  };

  final result = <ActiveCategory>[];
  for (final s in selections) {
    final card = cardById[s.cardId];
    if (card == null) continue;
    final rate = rateBy['${s.cardId}|${s.categoryId}'];
    if (rate == null) continue;

    result.add(
      ActiveCategory(
        categoryId: s.categoryId,
        name: categoryById[s.categoryId]?.name ?? s.categoryId,
        rate: rate,
        cardId: s.cardId,
        bankName: card.bankName,
        bankColor: card.colorValue,
      ),
    );
  }

  result.sort((a, b) {
    final byWeight = (weights[b.categoryId] ?? 1)
        .compareTo(weights[a.categoryId] ?? 1);
    return byWeight != 0 ? byWeight : a.name.compareTo(b.name);
  });

  return result;
});

/// Состояние месячного цикла.
///
/// Главный экран рисуется по одному состоянию, а не по набору разрозненных
/// флагов: иначе неизбежно всплывёт сочетание, которое никто не предусмотрел.
final monthStateProvider = FutureProvider<MonthState>((ref) async {
  final monthKey = ref.watch(currentMonthProvider);
  final offerRepo = ref.watch(offerRepositoryProvider);
  final selectionRepo = ref.watch(selectionRepositoryProvider);

  final cards = await ref.watch(cardsProvider.future);
  if (cards.isEmpty) return MonthState.noCards;

  final offers = await offerRepo.forMonth(monthKey);
  if (offers.isEmpty) return MonthState.needsScreenshots;

  final selections = await selectionRepo.forMonth(monthKey);
  if (selections.isEmpty) return MonthState.recommended;

  return MonthState.active;
});

/// Наступил новый месяц, а категории на него ещё не выбраны.
///
/// Определяется сравнением ключа последнего набора предложений с текущим:
/// расхождение и означает смену месяца.
final newMonthBannerProvider = FutureProvider<bool>((ref) async {
  final monthKey = ref.watch(currentMonthProvider);
  final offerRepo = ref.watch(offerRepositoryProvider);

  final cards = await ref.watch(cardsProvider.future);
  if (cards.isEmpty) return false;

  final latest = await offerRepo.latestMonthKey();
  if (latest == null) return false;
  return latest != monthKey;
});

/// Ответ на вопрос «какой картой платить» в этой категории.
final paymentAnswerProvider =
    FutureProvider.family<PaymentAnswer, String>((ref, categoryId) async {
  final monthKey = ref.watch(currentMonthProvider);
  final selectionRepo = ref.watch(selectionRepositoryProvider);
  final offerRepo = ref.watch(offerRepositoryProvider);

  final cards = await ref.watch(cardsProvider.future);
  final categories = ref.watch(categoriesProvider);

  final banksById = <String, Bank>{
    for (final c in cards) c.card.bankId: c.bank,
  };

  return buildPaymentAnswer(
    categoryId: categoryId,
    categoryName: _nameOf(categories, categoryId),
    cards: cards.map((c) => c.card).toList(),
    banksById: banksById,
    selections: await selectionRepo.forMonth(monthKey),
    offers: await offerRepo.forMonth(monthKey),
  );
});

String _nameOf(List<Category> categories, String id) {
  for (final c in categories) {
    if (c.id == id) return c.name;
  }
  return id;
}

/// Предложения конкретной карты на текущий месяц — чипы на экране А4.
final cardOffersProvider =
    FutureProvider.family<List<MonthlyOffer>, String>((ref, cardId) async {
  final monthKey = ref.watch(currentMonthProvider);
  final offers =
      await ref.watch(offerRepositoryProvider).forCard(cardId, monthKey);
  final weights = await ref.watch(weightsProvider.future);

  return offers
    ..sort((a, b) {
      final byWeight = (weights[b.categoryId] ?? 1)
          .compareTo(weights[a.categoryId] ?? 1);
      return byWeight != 0 ? byWeight : b.rate.compareTo(a.rate);
    });
});

/// Категории, выбранные в этой карте на текущий месяц.
final cardSelectionsProvider =
    FutureProvider.family<Set<String>, String>((ref, cardId) async {
  final monthKey = ref.watch(currentMonthProvider);
  final selections =
      await ref.watch(selectionRepositoryProvider).forMonth(monthKey);
  return selections
      .where((s) => s.cardId == cardId)
      .map((s) => s.categoryId)
      .toSet();
});

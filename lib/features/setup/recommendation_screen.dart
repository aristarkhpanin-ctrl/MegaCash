import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/optimizer/optimization_result.dart';
import 'setup_controller.dart';

/// Б6 · Рекомендация.
///
/// Три группы: выбранные, не выбранные с причиной, свободные слоты.
/// Причина у каждой отклонённой обязательна: человек должен понимать
/// логику, иначе он не доверится незнакомому приложению в вопросе денег.
class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key});

  @override
  ConsumerState<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState extends ConsumerState<RecommendationScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(setupControllerProvider.notifier).optimize());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final result = state.result;
    final categories = ref.watch(categoriesProvider);
    final nameById = {for (final cat in categories) cat.id: cat.name};

    final banks = ref.watch(cardsProvider).value ?? const [];
    final bankLabel = <String, String>{
      for (final b in banks) b.card.id: '${b.bankName} · ${b.card.productName}',
    };
    final bankColor = <String, int>{
      for (final b in banks) b.card.id: b.colorValue,
    };

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Рекомендация')),
        body: const SizedBox.shrink(),
      );
    }

    final rejected = _uniqueRejected(result);

    return Scaffold(
      appBar: AppBar(title: const Text('Рекомендация')),
      body: SafeArea(
        child: Column(
          children: [
            _SlotsSummary(cards: state.cards, result: result),
            if (state.recalculated)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  Spacing.screen,
                  0,
                  Spacing.screen,
                  Spacing.x3,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.x3 + 2,
                  vertical: Spacing.x2 + 2,
                ),
                decoration: BoxDecoration(
                  color: c.brandSubtle,
                  borderRadius: Radii.fieldBorder,
                ),
                child: Text(
                  'Пересчитали после переноса. Освободившийся слот мог '
                  'изменить выбор и в других банках.',
                  style: AppText.label.copyWith(color: c.text, height: 1.4),
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.screen,
                  0,
                  Spacing.screen,
                  Spacing.x6,
                ),
                children: [
                  _GroupHeader(
                    color: c.success,
                    title: 'Выбранные',
                    count: result.selected.length,
                  ),
                  const SizedBox(height: Spacing.x2 + 2),
                  if (result.selected.isEmpty)
                    Text(
                      'Пока нечего выбрать — добавьте категории вручную.',
                      style: AppText.caption.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    )
                  else
                    for (final a in result.selected) ...[
                      _SelectedRow(
                        category: nameById[a.categoryId] ?? a.categoryId,
                        bank: bankLabel[a.cardId] ?? a.cardId,
                        color: bankColor[a.cardId] ?? 0xFF6B665C,
                        rate: a.rate,
                        onDemote: () => _demote(a.categoryId),
                      ),
                      const SizedBox(height: Spacing.x2),
                    ],
                  if (rejected.isNotEmpty) ...[
                    const SizedBox(height: Spacing.x4),
                    _GroupHeader(
                      color: c.textSecondary,
                      title: 'Не выбранные',
                      count: rejected.length,
                    ),
                    const SizedBox(height: Spacing.x2 + 2),
                    for (final r in rejected) ...[
                      _RejectedRow(
                        category: nameById[r.categoryId] ?? r.categoryId,
                        rate: r.rate,
                        reason: rejectionText(
                          r,
                          cards: state.cards,
                          result: result,
                          bankLabel: bankLabel,
                        ),
                        onPromote: () => _promote(r.categoryId, r.cardId),
                      ),
                      const SizedBox(height: Spacing.x2),
                    ],
                  ],
                  if (result.freeSlots.isNotEmpty) ...[
                    const SizedBox(height: Spacing.x4),
                    _FreeSlots(
                      freeSlots: result.freeSlots,
                      bankLabel: bankLabel,
                      onAdd: () => context.push(Routes.setupManual),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.screen,
                Spacing.x2,
                Spacing.screen,
                Spacing.x4,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: result.selected.isEmpty
                      ? null
                      : () => context.push(Routes.setupActivation),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Перейти к активации'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Одна категория может быть отклонена сразу в нескольких банках.
  /// Человеку это неинтересно: показываем по строке на категорию,
  /// с лучшим из её предложений.
  static List<Rejection> _uniqueRejected(OptimizationResult result) {
    final best = <String, Rejection>{};
    for (final r in result.rejected) {
      final existing = best[r.categoryId];
      if (existing == null || r.rate > existing.rate) {
        best[r.categoryId] = r;
      }
    }
    return best.values.toList()..sort((a, b) => b.rate.compareTo(a.rate));
  }

  Future<void> _promote(String categoryId, String cardId) =>
      ref.read(setupControllerProvider.notifier).promote(categoryId, cardId);

  Future<void> _demote(String categoryId) =>
      ref.read(setupControllerProvider.notifier).demote(categoryId);
}

/// Человеческое объяснение, почему категория не попала в выбранные.
String rejectionText(
  Rejection rejection, {
  required List<PaymentCard> cards,
  required OptimizationResult result,
  required Map<String, String> bankLabel,
}) {
  final occupied = result.occupiedByCard;
  final card = cards.where((c) => c.id == rejection.cardId).firstOrNull;
  final bank = bankLabel[rejection.cardId]?.split(' · ').first ?? 'банке';

  return switch (rejection.reason) {
    RejectionReason.rateNotAboveBase =>
      'Не выше базовой ставки — столько вернётся и без выбора этой категории.',
    RejectionReason.takenByAnotherCard =>
      'Уже выбрана в другом банке под больший процент. Дважды одна категория '
          'не сработает: платить вы будете одной картой.',
    RejectionReason.cardSlotsFull => card == null
        ? 'Свободных слотов не осталось.'
        : 'В «$bank» занято ${occupied[card.id] ?? 0} из ${card.slotLimit} — '
            'уступает уже выбранным.',
    RejectionReason.cardTakenByAllPurchases =>
      'Карта отдана под «все покупки» — это выгоднее, чем занимать её слоты '
          'по отдельности.',
    RejectionReason.excludedByUser => 'Вы отправили её в «Не выбранные».',
  };
}

class _SlotsSummary extends StatelessWidget {
  const _SlotsSummary({required this.cards, required this.result});

  final List<PaymentCard> cards;
  final OptimizationResult result;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final occupied = result.occupiedByCard;
    final total = cards.fold<int>(0, (sum, card) => sum + card.slotLimit);
    final used = result.selected.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        Spacing.screen,
        Spacing.x2,
        Spacing.screen,
        Spacing.x3,
      ),
      padding: const EdgeInsets.all(Spacing.x3 + 2),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: Radii.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Занято слотов',
                  style: AppText.label.copyWith(color: c.textSecondary),
                ),
              ),
              Text(
                '$used из $total',
                style: AppText.bodyStrong.copyWith(color: c.text),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x2),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (var i = 0; i < total; i++)
                Container(
                  width: 18,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i < used ? c.brand : c.surface2,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.x2 + 2),
          Wrap(
            spacing: Spacing.x3,
            runSpacing: Spacing.x1,
            children: [
              for (final card in cards)
                Text(
                  '${card.productName} ${occupied[card.id] ?? 0}/'
                  '${card.slotLimit}',
                  style: AppText.label.copyWith(color: c.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.color,
    required this.title,
    required this.count,
  });

  final Color color;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: Spacing.x2),
        Text(title, style: AppText.bodyStrong.copyWith(color: c.text)),
        const SizedBox(width: Spacing.x2),
        Text('$count', style: AppText.caption.copyWith(color: c.textSecondary)),
      ],
    );
  }
}

class _SelectedRow extends StatelessWidget {
  const _SelectedRow({
    required this.category,
    required this.bank,
    required this.color,
    required this.rate,
    required this.onDemote,
  });

  final String category;
  final String bank;
  final int color;
  final double rate;
  final VoidCallback onDemote;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.only(
        left: Spacing.x3 + 2,
        top: Spacing.x2,
        bottom: Spacing.x2,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: Radii.cardBorder,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(color: c.text),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Spacing.x1 + 2),
                    Flexible(
                      child: Text(
                        bank,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label.copyWith(color: c.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.x2),
          Text(
            Percent.format(rate),
            style: AppText.bodyStrong.copyWith(color: c.text),
          ),
          IconButton(
            tooltip: 'Убрать из выбранных',
            onPressed: onDemote,
            icon: Icon(Icons.arrow_downward, size: 18, color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _RejectedRow extends StatelessWidget {
  const _RejectedRow({
    required this.category,
    required this.rate,
    required this.reason,
    required this.onPromote,
  });

  final String category;
  final double rate;
  final String reason;
  final VoidCallback onPromote;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.only(
        left: Spacing.x3 + 2,
        top: Spacing.x3,
        bottom: Spacing.x3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: Radii.cardBorder,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong.copyWith(color: c.text),
                      ),
                    ),
                    const SizedBox(width: Spacing.x2),
                    Text(
                      Percent.format(rate),
                      style: AppText.caption.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  reason,
                  style: AppText.label.copyWith(
                    color: c.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Забрать в выбранные',
            onPressed: onPromote,
            icon: Icon(Icons.arrow_upward, size: 18, color: c.text),
          ),
        ],
      ),
    );
  }
}

class _FreeSlots extends StatelessWidget {
  const _FreeSlots({
    required this.freeSlots,
    required this.bankLabel,
    required this.onAdd,
  });

  final List<String> freeSlots;
  final Map<String, String> bankLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final byCard = <String, int>{};
    for (final id in freeSlots) {
      byCard[id] = (byCard[id] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.x3 + 2),
      decoration: BoxDecoration(
        color: c.brandSubtle,
        borderRadius: Radii.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Свободно ${Plural.slots(freeSlots.length)}',
            style: AppText.bodyStrong.copyWith(color: c.text),
          ),
          const SizedBox(height: Spacing.x1 + 2),
          Text(
            byCard.entries
                .map(
                  (e) =>
                      '${bankLabel[e.key]?.split(' · ').first ?? e.key}: '
                      '${e.value}',
                )
                .join(', '),
            style: AppText.label.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: Spacing.x2),
          Text(
            'Из распознанного нечем занять их выгодно. Добавьте категорию '
            'сами — она сразу попадёт в выбранные.',
            style: AppText.label.copyWith(color: c.text, height: 1.4),
          ),
          const SizedBox(height: Spacing.x3),
          OutlinedButton(
            onPressed: onAdd,
            child: const Text('Добавить категорию'),
          ),
        ],
      ),
    );
  }
}

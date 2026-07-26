import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../ads/ad_banner_slot.dart';
import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers.dart';
import '../../domain/models/month_key.dart';

/// А3 · Мои карты.
///
/// Список карт с цветовыми метками, базовым процентом и количеством
/// выбранных категорий. Снизу место под баннер.
/// Состояния: пусто; список; список из десяти карт.
class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final cards = ref.watch(cardsProvider);
    final counts =
        ref.watch(selectionCountProvider(MonthKey.current())).value ??
            const <String, int>{};

    // Пока список едет из базы, считаем его пустым, а не прячем экран
    // за индикатором: шапка на месте всегда, меняется только содержимое.
    final list = cards.value ?? const <CardWithBank>[];
    final isEmpty = list.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.screen,
                Spacing.x2,
                Spacing.screen,
                Spacing.x3 + 2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Мои карты',
                          style: AppText.screenTitle.copyWith(color: c.text),
                        ),
                        Text(
                          isEmpty
                              ? 'Ни одной карты'
                              : Plural.cards(list.length),
                          style: AppText.caption
                              .copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (!isEmpty)
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.push(Routes.onboardingFirstCard),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Карта'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.x3 + 2,
                        ),
                        textStyle: AppText.label.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (cards.hasError)
              Expanded(child: _LoadError(message: '${cards.error}'))
            else if (isEmpty)
              const Expanded(child: _EmptyCards())
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.screen,
                    0,
                    Spacing.screen,
                    Spacing.x4 + 2,
                  ),
                  itemCount: list.length + 1,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: Spacing.x2 + 2),
                  itemBuilder: (context, i) {
                    if (i == list.length) {
                      return OutlinedButton.icon(
                        onPressed: () =>
                            context.push(Routes.onboardingFirstCard),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Добавить карту'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            Dimens.minTapTarget,
                          ),
                        ),
                      );
                    }
                    final item = list[i];
                    return _CardRow(
                      bankName: item.bankName,
                      colorValue: item.colorValue,
                      subtitle: _subtitle(
                        item.card.productName,
                        item.card.baseRate,
                        counts[item.card.id] ?? 0,
                      ),
                      onTap: () => context.push(
                        '${Routes.cardEdit}?id=${item.card.id}',
                      ),
                    );
                  },
                ),
              ),
            const AdBannerSlot(),
          ],
        ),
      ),
    );
  }

  static String _subtitle(String product, double baseRate, int categories) {
    return '$product · базовый ${Percent.format(baseRate)} · '
        '${Plural.categories(categories)}';
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.bankName,
    required this.colorValue,
    required this.subtitle,
    required this.onTap,
  });

  final String bankName;
  final int colorValue;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: Radii.cardBorder,
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.x3 + 2,
          vertical: Spacing.x3,
        ),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.border),
          borderRadius: Radii.cardBorder,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(colorValue),
                borderRadius: const BorderRadius.all(Radius.circular(9)),
              ),
            ),
            const SizedBox(width: Spacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    bankName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyStrong.copyWith(color: c.text),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(
                      color: c.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: c.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _EmptyCards extends StatelessWidget {
  const _EmptyCards();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(
                Icons.credit_card_outlined,
                size: 30,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.x4),
            Text(
              'Пока нет карт',
              style: AppText.blockTitle.copyWith(color: c.text),
            ),
            const SizedBox(height: Spacing.x3),
            Text(
              'Добавьте банковские карты — МегаКэш будет подсказывать, '
              'какой платить у кассы.',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(
                color: c.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: Spacing.x4 + 4),
            ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push(Routes.onboardingFirstCard),
              child: const Text('Добавить карту'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Не удалось прочитать карты',
              style: AppText.blockTitle.copyWith(color: c.text),
            ),
            const SizedBox(height: Spacing.x2),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

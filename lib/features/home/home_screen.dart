import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../ads/ad_banner_slot.dart';
import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/category_tile.dart';
import '../../data/providers.dart';
import '../../domain/models/month_key.dart';
import 'home_providers.dart';

/// А1 · Главный экран.
///
/// Сетка активных категорий в две колонки. Состояния: обычное; нет карт;
/// карты есть, категории не выбраны; наступил новый месяц.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthKey = ref.watch(currentMonthProvider);
    final tiles = ref.watch(activeCategoriesProvider).value ??
        const <ActiveCategory>[];
    final hasCards =
        (ref.watch(cardsProvider).value ?? const []).isNotEmpty;
    final showNewMonth = ref.watch(newMonthBannerProvider).value ?? false;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              month: MonthKey.monthName(monthKey),
              subtitle: _subtitle(hasCards, tiles.length),
            ),
            if (showNewMonth)
              _NewMonthBanner(
                monthKey: monthKey,
                onSetup: () => context.push(Routes.setup),
              ),
            if (tiles.isEmpty)
              Expanded(
                child: _Empty(
                  hasCards: hasCards,
                  onAction: () => context.push(
                    hasCards ? Routes.setup : Routes.onboardingFirstCard,
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.screen,
                    0,
                    Spacing.screen,
                    Spacing.screen,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Spacing.x3,
                    crossAxisSpacing: Spacing.x3,
                    // Название в две строки плюс крупный процент требуют этой высоты;
                    // при 132 плитка переполнялась на телефонной ширине.
                    mainAxisExtent: 148,
                  ),
                  itemCount: tiles.length,
                  itemBuilder: (context, i) {
                    final tile = tiles[i];
                    return CategoryTile(
                      category: tile.name,
                      percent: tile.rate,
                      bankName: tile.bankName,
                      bankColor: tile.bankColor,
                      onTap: () => context.push(
                        '${Routes.answer}?category=${tile.categoryId}',
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

  static String _subtitle(bool hasCards, int count) {
    if (!hasCards) return 'Нет карт';
    if (count == 0) return 'Категории не выбраны';
    return Plural.activeCategories(count);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.month, required this.subtitle});

  final String month;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screen,
        Spacing.x2,
        Spacing.x2,
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
                  month,
                  style: AppText.screenTitle.copyWith(color: c.text),
                ),
                Text(
                  subtitle,
                  style: AppText.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Настройки',
            onPressed: () => GoRouter.of(context).push(Routes.settings),
            icon: Icon(Icons.settings_outlined, color: c.text),
            constraints: const BoxConstraints(
              minWidth: Dimens.minTapTarget,
              minHeight: Dimens.minTapTarget,
            ),
          ),
        ],
      ),
    );
  }
}

/// Плашка о смене месяца.
///
/// Категории прошлого месяца больше не действуют, и человек об этом не
/// узнает ниоткуда, кроме приложения. Молчать здесь нельзя.
class _NewMonthBanner extends StatelessWidget {
  const _NewMonthBanner({required this.monthKey, required this.onSetup});

  final String monthKey;
  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final month = MonthKey.monthNameAccusative(monthKey);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        Spacing.screen,
        0,
        Spacing.screen,
        Spacing.x3 + 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x4,
        vertical: Spacing.x3 + 2,
      ),
      decoration: BoxDecoration(
        color: c.brandSubtle,
        borderRadius: Radii.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 20, color: c.text),
              const SizedBox(width: Spacing.x2 + 2),
              Expanded(
                child: Text(
                  'Наступил $month. Категории кэшбэка за прошлый месяц '
                  'больше не действуют — выберите новые.',
                  style: AppText.caption.copyWith(color: c.text, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x2 + 2),
          ElevatedButton(
            onPressed: onSetup,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.x4),
            ),
            child: const Text('Обновить категории'),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.hasCards, required this.onAction});

  final bool hasCards;
  final VoidCallback onAction;

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
            const SizedBox(height: Spacing.x3),
            Text(
              hasCards
                  ? 'Категории на месяц не выбраны'
                  : 'Добавьте первую карту',
              textAlign: TextAlign.center,
              style: AppText.blockTitle.copyWith(color: c.text),
            ),
            const SizedBox(height: Spacing.x3),
            Text(
              hasCards
                  ? 'Карты добавлены. Загрузите скриншоты из банковских '
                      'приложений — МегаКэш подскажет, что выбрать.'
                  : 'Чтобы у кассы видеть, какой картой платить, добавьте '
                      'свои банковские карты.',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(
                color: c.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: Spacing.x4),
            ElevatedButton(
              onPressed: onAction,
              child: Text(
                hasCards ? 'Настроить кэшбэк' : 'Добавить карту',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers.dart';
import 'setup_controller.dart';

/// Б4 · Проверка распознанного.
///
/// Показывается не всё подряд, а только сомнительное: неуверенно
/// распознанные строки и те, что не нашлись в справочнике — магазины
/// вроде «РИВ ГОШ» и «Lamoda». Заставлять человека вычитывать сорок
/// верных строк ради двух спорных — верный способ, чтобы он бросил.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final categories = ref.watch(categoriesProvider);
    final nameById = {for (final cat in categories) cat.id: cat.name};

    final doubtful = state.needsReview;
    final unmatched = state.unmatched;
    final allClear = doubtful.isEmpty && unmatched.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Проверка')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.screen,
                  Spacing.x2,
                  Spacing.screen,
                  Spacing.x6,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(Spacing.x3 + 2),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: Radii.cardBorder,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Распознано',
                            style: AppText.label.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          Plural.categories(state.offers.length),
                          style: AppText.bodyStrong.copyWith(color: c.text),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.x4),
                  if (allClear)
                    Text(
                      'Всё распозналось уверенно — проверять нечего.',
                      style: AppText.caption.copyWith(
                        color: c.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  if (doubtful.isNotEmpty) ...[
                    Text(
                      'РАСПОЗНАЛОСЬ НЕУВЕРЕННО',
                      style: AppText.label.copyWith(
                        color: c.textSecondary,
                        letterSpacing: 0.48,
                      ),
                    ),
                    const SizedBox(height: Spacing.x2 + 2),
                    for (final offer in doubtful) ...[
                      _Row(
                        title: nameById[offer.categoryId] ?? offer.categoryId,
                        subtitle: offer.note,
                        rate: offer.rate,
                        onAccept: () => ref
                            .read(setupControllerProvider.notifier)
                            .correctOffer(offer.id),
                        onDrop: () => ref
                            .read(setupControllerProvider.notifier)
                            .dropOffer(offer.id),
                      ),
                      const SizedBox(height: Spacing.x2),
                    ],
                  ],
                  if (unmatched.isNotEmpty) ...[
                    const SizedBox(height: Spacing.x4),
                    Text(
                      'НЕ НАШЛОСЬ В СПРАВОЧНИКЕ',
                      style: AppText.label.copyWith(
                        color: c.textSecondary,
                        letterSpacing: 0.48,
                      ),
                    ),
                    const SizedBox(height: Spacing.x1 + 2),
                    Text(
                      'Обычно это магазины и сервисы. Укажите категорию '
                      'сами или пропустите.',
                      style: AppText.label.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: Spacing.x2 + 2),
                    for (final item in unmatched) ...[
                      _Row(
                        title: item.rawName,
                        subtitle: item.note,
                        rate: item.rate,
                        onDrop: () => ref
                            .read(setupControllerProvider.notifier)
                            .dismissUnmatched(item.rawName),
                      ),
                      const SizedBox(height: Spacing.x2),
                    ],
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
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push(Routes.setupRecommendation),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      child: const Text('Продолжить'),
                    ),
                  ),
                  const SizedBox(height: Spacing.x2),
                  TextButton(
                    onPressed: () => context.push(Routes.setupManual),
                    child: Text(
                      'Добавить категорию вручную',
                      style: AppText.caption.copyWith(
                        color: c.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.rate,
    required this.onDrop,
    this.subtitle,
    this.onAccept,
  });

  final String title;
  final String? subtitle;
  final double rate;
  final VoidCallback onDrop;
  final VoidCallback? onAccept;

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
        border: Border.all(color: c.border),
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
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(color: c.text),
                ),
                if (subtitle case final note?)
                  Text(
                    note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(color: c.textSecondary),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.x2),
          Text(
            Percent.format(rate),
            style: AppText.bodyStrong.copyWith(color: c.text),
          ),
          if (onAccept case final accept?)
            IconButton(
              tooltip: 'Всё верно',
              onPressed: accept,
              icon: Icon(Icons.check, size: 18, color: c.success),
            ),
          IconButton(
            tooltip: 'Убрать',
            onPressed: onDrop,
            icon: Icon(Icons.close, size: 18, color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

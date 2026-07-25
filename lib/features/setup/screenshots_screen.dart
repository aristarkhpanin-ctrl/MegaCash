import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers.dart';
import 'setup_controller.dart';

/// Б2 · Загрузка скриншотов.
///
/// Скриншоты выбираются отдельно для каждой карты: предложение принадлежит
/// карте, и без этой привязки распознанное некуда положить. Спросить один
/// раз при загрузке дешевле, чем потом разбирать вперемешку.
class ScreenshotsScreen extends ConsumerWidget {
  const ScreenshotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final banks = ref.watch(cardsProvider).value ?? const [];
    final bankName = {for (final b in banks) b.card.id: b.bankName};

    return Scaffold(
      appBar: AppBar(title: const Text('Скриншоты')),
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
                  Text(
                    'Откройте в приложении банка экран выбора категорий '
                    'и сделайте скриншот. Если категорий много и они '
                    'не помещаются — несколько скриншотов подряд.',
                    style: AppText.caption.copyWith(
                      color: c.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: Spacing.x4),
                  for (final card in state.cards) ...[
                    _CardSlot(
                      title: bankName[card.id] ?? card.productName,
                      subtitle: card.productName,
                      count: state.imagesByCard[card.id]?.length ?? 0,
                      onPick: () => _pick(ref, card.id),
                    ),
                    const SizedBox(height: Spacing.x2 + 2),
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
                      // Категории, введённые руками, — такой же готовый
                      // результат, как распознанные. Оставлять человека
                      // на этом экране без выхода нельзя.
                      onPressed: switch ((state.totalImages, state.hasOffers)) {
                        (0, false) => null,
                        (0, true) => () =>
                            context.push(Routes.setupRecommendation),
                        _ => () => context.push(Routes.setupRecognizing),
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      child: Text(
                        switch ((state.totalImages, state.hasOffers)) {
                          (0, false) => 'Добавьте хотя бы один скриншот',
                          (0, true) => 'Продолжить без скриншотов',
                          _ =>
                            'Распознать ${Plural.screenshots(state.totalImages)}',
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.x2),
                  // Распознавание — удобство, а не обязанность: без него
                  // категории вводятся руками, и продукт всё равно работает.
                  TextButton(
                    onPressed: () => context.push(Routes.setupManual),
                    child: Text(
                      'Ввести категории вручную',
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

  Future<void> _pick(WidgetRef ref, String cardId) async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isEmpty) return;
    ref
        .read(setupControllerProvider.notifier)
        .addImages(cardId, picked.map((x) => x.path).toList());
  }
}

class _CardSlot extends StatelessWidget {
  const _CardSlot({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onPick,
  });

  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.x3 + 2),
      decoration: BoxDecoration(
        color: c.surface,
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
                Text(title, style: AppText.bodyStrong.copyWith(color: c.text)),
                Text(
                  count == 0
                      ? '$subtitle · скриншотов нет'
                      : '$subtitle · ${Plural.screenshots(count)}',
                  style: AppText.label.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.x2),
          OutlinedButton(
            onPressed: onPick,
            child: Text(count == 0 ? 'Выбрать' : 'Ещё'),
          ),
        ],
      ),
    );
  }
}

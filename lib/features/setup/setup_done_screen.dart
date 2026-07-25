import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import 'setup_controller.dart';

/// Б8 · Готово.
class SetupDoneScreen extends ConsumerWidget {
  const SetupDoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final count =
        ref.watch(setupControllerProvider).result?.selected.length ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
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
                          color: c.brandSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 32, color: c.text),
                      ),
                      const SizedBox(height: Spacing.x4),
                      Text(
                        'Кэшбэк на месяц собран',
                        textAlign: TextAlign.center,
                        style: AppText.blockTitle.copyWith(color: c.text),
                      ),
                      const SizedBox(height: Spacing.x3),
                      Text(
                        '${Plural.activeCategories(count)} в работе. '
                        'Теперь у кассы нажимайте нужную категорию '
                        'на главном экране.',
                        textAlign: TextAlign.center,
                        style: AppText.caption.copyWith(
                          color: c.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  onPressed: () => context.go(Routes.home),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('На главный'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

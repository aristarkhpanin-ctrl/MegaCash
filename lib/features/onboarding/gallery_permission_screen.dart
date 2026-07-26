import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'onboarding_provider.dart';

/// В2 · Зачем нужен доступ к галерее.
///
/// Экран объяснения перед системным запросом, а не вместо него. Системное
/// окно не говорит зачем, а отказ в нём стоит дорого: второй раз Android
/// его уже не покажет. Поэтому объясняем сами и заранее.
class GalleryPermissionScreen extends ConsumerWidget {
  const GalleryPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.x6,
                  Spacing.x4,
                  Spacing.x6,
                  Spacing.x6,
                ),
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 30,
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Spacing.x4),
                  Text(
                    'Доступ к скриншотам',
                    style: AppText.screenTitle.copyWith(
                      color: c.text,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: Spacing.x3),
                  Text(
                    'Чтобы распознать категории, приложению нужно открыть '
                    'скриншоты, которые вы выберете сами. Ни одна картинка '
                    'не покидает телефон: распознавание работает без '
                    'интернета.',
                    style: AppText.body.copyWith(
                      color: c.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: Spacing.x4),
                  Text(
                    'Разрешение спросит система при первом выборе картинок. '
                    'Отказаться можно — тогда категории вводятся вручную, '
                    'и приложение всё равно работает.',
                    style: AppText.caption.copyWith(
                      color: c.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.x6,
                Spacing.x2,
                Spacing.x6,
                Spacing.x6,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await markOnboardingDone(ref);
                    if (!context.mounted) return;
                    context.go(Routes.onboardingFirstCard);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Понятно, добавить карту'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/screen_stub.dart';

/// А1 · Главный экран.
///
/// Сетка крупных плиток активных категорий по две в ряд, сверху — текущий
/// месяц и количество активных категорий, снизу — рекламный баннер над
/// навигацией. Состояния: карт нет; карты есть, но категории не выбраны;
/// наступил новый месяц; всё активно.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.screen,
                Spacing.x2,
                Spacing.x2,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Июль',
                          style: AppText.screenTitle.copyWith(color: c.text),
                        ),
                        Text(
                          'Категории не выбраны',
                          style:
                              AppText.caption.copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push(Routes.settings),
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Настройки',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScreenStub(
                code: 'А1',
                title: 'Главный экран',
                description:
                    'Плитки активных категорий по две в ряд: название, '
                    'максимальный процент и цветовая метка банка. Нажатие '
                    'открывает ответ, какой картой платить.',
                actions: [
                  StubAction(
                    'Открыть ответ (А2)',
                    () => context.push(Routes.answer),
                    primary: true,
                  ),
                  StubAction(
                    'Настроить кэшбэк на месяц (Б1)',
                    () => context.push(Routes.setup),
                  ),
                  StubAction(
                    'Онбординг (В1)',
                    () => context.push(Routes.onboarding),
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

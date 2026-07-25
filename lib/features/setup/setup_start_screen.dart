import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/month_key.dart';
import '../home/home_providers.dart';
import 'setup_controller.dart';

/// Б1 · Начало настройки.
///
/// Объясняет, что сейчас произойдёт, и перечисляет карты. Настройка идёт
/// раз в месяц, человек забывает порядок действий — напомнить дешевле,
/// чем разбираться потом с брошенной на полпути настройкой.
class SetupStartScreen extends ConsumerStatefulWidget {
  const SetupStartScreen({super.key});

  @override
  ConsumerState<SetupStartScreen> createState() => _SetupStartScreenState();
}

class _SetupStartScreenState extends ConsumerState<SetupStartScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(setupControllerProvider.notifier).start());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final month = MonthKey.monthNameAccusative(
      ref.watch(currentMonthProvider),
    );

    return Scaffold(
      appBar: AppBar(),
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
                    'Настройка на $month',
                    style: AppText.screenTitle.copyWith(color: c.text),
                  ),
                  const SizedBox(height: Spacing.x3),
                  Text(
                    'Загрузите скриншоты экранов выбора категорий из '
                    'банковских приложений. МегаКэш распознает их прямо '
                    'на телефоне и подскажет, что где выбрать.',
                    style: AppText.body.copyWith(
                      color: c.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: Spacing.x6),
                  Text(
                    'ВАШИ КАРТЫ · ${Plural.cards(state.cards.length)}',
                    style: AppText.label.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 0.48,
                    ),
                  ),
                  const SizedBox(height: Spacing.x2 + 2),
                  for (final card in state.cards)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.x2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.x3 + 2,
                          vertical: Spacing.x3,
                        ),
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: Radii.cardBorder,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                card.productName,
                                style: AppText.body.copyWith(color: c.text),
                              ),
                            ),
                            Text(
                              'до ${Plural.slots(card.slotLimit)}',
                              style: AppText.label.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  onPressed: state.cards.isEmpty
                      ? null
                      : () => context.push(Routes.setupScreenshots),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Загрузить скриншоты'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

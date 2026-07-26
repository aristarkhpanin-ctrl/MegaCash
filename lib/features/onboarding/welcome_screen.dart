import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// В1 · Что делает приложение.
///
/// Один экран без пролистывания: обещание, два такта работы и честное
/// предупреждение про активацию в банках. Человек, не понявший последнего,
/// решит, что приложение не работает, — и будет прав со своей стороны.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.x6,
                  Spacing.x8,
                  Spacing.x6,
                  Spacing.x6,
                ),
                children: [
                  Text(
                    'МегаКэш',
                    style: AppText.screenTitle.copyWith(
                      color: c.text,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: Spacing.x3),
                  Text(
                    'Подсказывает, какой картой платить, чтобы вернулось '
                    'больше.',
                    style: AppText.body.copyWith(
                      color: c.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: Spacing.x8),
                  const _Step(
                    number: '1',
                    title: 'Раз в месяц',
                    text: 'Загружаете скриншоты категорий из банковских '
                        'приложений. МегаКэш распознаёт их прямо на телефоне '
                        'и подбирает, что где выбрать.',
                  ),
                  const SizedBox(height: Spacing.x4),
                  const _Step(
                    number: '2',
                    title: 'Каждый день',
                    text: 'У кассы нажимаете нужную категорию и видите, какой '
                        'картой платить.',
                  ),
                  const SizedBox(height: Spacing.x8),
                  Container(
                    padding: const EdgeInsets.all(Spacing.x3 + 2),
                    decoration: BoxDecoration(
                      color: c.brandSubtle,
                      borderRadius: Radii.cardBorder,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 20, color: c.text),
                        const SizedBox(width: Spacing.x2 + 2),
                        Expanded(
                          child: Text(
                            'Приложение не связано с банками и ничего в них '
                            'не включает. Выбранные категории вы отмечаете '
                            'в приложении банка сами — МегаКэш только '
                            'подскажет какие.',
                            style: AppText.caption.copyWith(
                              color: c.text,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.x3),
                  Text(
                    'Данные хранятся только на вашем телефоне. Аккаунт '
                    'не нужен, скриншоты никуда не отправляются.',
                    style: AppText.label.copyWith(
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
                  onPressed: () => context.push(Routes.onboardingPermission),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Начать'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.text,
  });

  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle),
          child: Text(
            number,
            style: AppText.caption.copyWith(
              color: c.onBrand,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: Spacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.bodyStrong.copyWith(color: c.text)),
              const SizedBox(height: 2),
              Text(
                text,
                style: AppText.caption.copyWith(
                  color: c.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

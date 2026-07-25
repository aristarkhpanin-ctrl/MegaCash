import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Временное наполнение экрана на время каркаса (шаг 1).
///
/// Показывает код экрана из макетов, его название и список переходов, чтобы
/// навигацию можно было пройти руками на телефоне. По мере готовности шагов
/// 4–7 каждая заглушка заменяется настоящим экраном; к публикации ни одной
/// остаться не должно.
class ScreenStub extends StatelessWidget {
  const ScreenStub({
    super.key,
    required this.code,
    required this.title,
    this.description,
    this.actions = const [],
  });

  /// Код экрана из макетов: «А1», «Б6», «Г2».
  final String code;

  /// Название экрана.
  final String title;

  /// Что этот экран будет делать.
  final String? description;

  /// Переходы, доступные с экрана.
  final List<StubAction> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screen,
        Spacing.x6,
        Spacing.screen,
        Spacing.x8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.x3,
              vertical: Spacing.x1 + 2,
            ),
            decoration: BoxDecoration(
              color: c.brand,
              borderRadius: Radii.chipBorder,
            ),
            child: Text(
              code,
              style: AppText.label.copyWith(
                color: c.onBrand,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: Spacing.x3),
          Text(title, style: AppText.screenTitle.copyWith(color: c.text)),
          if (description != null) ...[
            const SizedBox(height: Spacing.x2),
            Text(
              description!,
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: Spacing.x6),
            for (final a in actions) ...[
              SizedBox(
                width: double.infinity,
                child: a.primary
                    ? ElevatedButton(onPressed: a.onTap, child: Text(a.label))
                    : OutlinedButton(onPressed: a.onTap, child: Text(a.label)),
              ),
              const SizedBox(height: Spacing.x2),
            ],
          ],
        ],
      ),
    );
  }
}

/// Переход с экрана-заглушки.
class StubAction {
  const StubAction(this.label, this.onTap, {this.primary = false});

  final String label;
  final VoidCallback onTap;
  final bool primary;
}

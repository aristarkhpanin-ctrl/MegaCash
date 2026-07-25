import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';

enum ChipState { unselected, selected, disabled }

/// Чип категории с процентом.
///
/// В выбранном состоянии заливается брендовым жёлтым, текст поверх —
/// тёмный. Жёлтый допустим только так: заливкой, никогда текстом.
class McChip extends StatelessWidget {
  const McChip({
    super.key,
    required this.label,
    this.percent,
    this.state = ChipState.unselected,
    this.onTap,
  });

  final String label;
  final double? percent;
  final ChipState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final (background, foreground, border, opacity) = switch (state) {
      ChipState.selected => (c.brand, c.onBrand, Colors.transparent, 1.0),
      ChipState.disabled => (
          c.surface2,
          c.textSecondary,
          Colors.transparent,
          0.55,
        ),
      ChipState.unselected => (
          Colors.transparent,
          c.text,
          c.border,
          1.0,
        ),
    };

    return Opacity(
      opacity: opacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: state == ChipState.disabled ? null : onTap,
          borderRadius: Radii.chipBorder,
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: Spacing.x3 + 2),
            decoration: BoxDecoration(
              color: background,
              borderRadius: Radii.chipBorder,
              border: Border.all(color: border, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (percent case final p?) ...[
                  const SizedBox(width: Spacing.x1 + 2),
                  Text(
                    Percent.format(p),
                    style: AppText.caption.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

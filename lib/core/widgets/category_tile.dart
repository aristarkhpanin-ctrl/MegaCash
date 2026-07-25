import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';

/// Плитка категории на главном экране.
///
/// Три уровня: банк мелко сверху, название категории, процент крупно.
/// Процент самый заметный — по нему человек за долю секунды находит нужное.
class CategoryTile extends StatefulWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.percent,
    required this.bankName,
    required this.bankColor,
    required this.onTap,
  });

  final String category;
  final double percent;
  final String bankName;
  final int bankColor;
  final VoidCallback onTap;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(Spacing.x4),
          decoration: BoxDecoration(
            color: _pressed ? c.surface2 : c.surface,
            border: Border.all(color: c.border),
            borderRadius: Radii.cardBorder,
          ),
          // Название категории занимает остаток высоты и прижато книзу.
          // Фиксированные отступы здесь переполняли плитку, как только
          // название переносилось на вторую строку.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(widget.bankColor),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Spacing.x2),
                  Expanded(
                    child: Text(
                      widget.bankName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(color: c.textSecondary),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.x2),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.category,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.blockTitle.copyWith(
                        color: c.text,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                Percent.format(widget.percent),
                maxLines: 1,
                style: TextStyle(
                  fontFamily: AppText.fontFamily,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 0.95,
                  color: c.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

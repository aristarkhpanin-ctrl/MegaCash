import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/bank_color.dart';
import '../utils/formatters.dart';

/// Как показывается карта.
enum BankCardVariant {
  /// Обычная карточка в пропорции банковской карты.
  normal,

  /// Ответ на вопрос «чем платить»: та же карточка, но со свечением
  /// и надписью «Платите этой». Взгляд должен упираться в неё сразу.
  winner,

  /// Проигравшая — узкая строка списка. Занимает мало места, потому что
  /// нужна редко: человеку важна одна карта, остальные для проверки.
  loser,
}

/// Карточка банка.
///
/// Цвет заливки приходит из данных, цвет текста поверх вычисляется по
/// яркости фона. Логотипы не используются — только название и цвет.
class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.bankName,
    required this.productName,
    required this.percent,
    required this.bankColor,
    this.variant = BankCardVariant.normal,
    this.onTap,
  });

  final String bankName;
  final String productName;
  final double percent;
  final int bankColor;
  final BankCardVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = switch (variant) {
      BankCardVariant.loser => _buildLoser(context),
      BankCardVariant.winner => _buildFull(context, winner: true),
      BankCardVariant.normal => _buildFull(context, winner: false),
    };

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: Radii.cardBorder,
      child: card,
    );
  }

  Widget _buildFull(BuildContext context, {required bool winner}) {
    final c = context.colors;
    final background = BankPalette.fromValue(bankColor);
    final onColor = BankPalette.onColor(background);
    final onSoft = BankPalette.onColorSoft(background);

    return AspectRatio(
      aspectRatio: Dimens.cardAspectRatio,
      child: Container(
        padding: const EdgeInsets.all(Spacing.x4 + 2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: Radii.cardBorder,
          boxShadow: winner
              ? [
                  BoxShadow(
                    color: c.brand.withValues(alpha: 0.35),
                    blurRadius: 26,
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Color(0x47000000),
                    blurRadius: 34,
                    offset: Offset(0, 16),
                  ),
                ]
              : null,
          border: winner
              ? Border.all(color: c.brand.withValues(alpha: 0.30), width: 4)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (winner)
                  Text(
                    'ПЛАТИТЕ ЭТОЙ',
                    style: AppText.label.copyWith(
                      color: onSoft,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.72,
                    ),
                  )
                else
                  Text(
                    'кэшбэк до',
                    style: AppText.label.copyWith(color: onSoft),
                  ),
                const SizedBox(height: 3),
                Text(
                  bankName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppText.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: onColor,
                  ),
                ),
                if (productName.isNotEmpty)
                  Text(
                    productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(color: onSoft),
                  ),
              ],
            ),
            // У победителя процент вынесен на жёлтую плашку: жёлтый здесь
            // работает заливкой, текст поверх — тёмный. Как надпись
            // на цветном фоне банка он был бы нечитаем.
            if (winner)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.x3 + 2,
                  vertical: Spacing.x1 + 2,
                ),
                decoration: BoxDecoration(
                  color: c.brand,
                  borderRadius: Radii.fieldBorder,
                ),
                child: Text(
                  Percent.format(percent),
                  style: AppText.displayPercent.copyWith(color: c.onBrand),
                ),
              )
            else
              Text(
                Percent.format(percent),
                style: AppText.displayPercent.copyWith(color: onColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoser(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x3,
        vertical: Spacing.x2,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: Radii.cardBorder,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: BankPalette.fromValue(bankColor),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: Spacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bankName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(
                    color: c.text,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                if (productName.isNotEmpty)
                  Text(
                    productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(color: c.textSecondary),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.x2),
          Text(
            Percent.format(percent),
            style: AppText.bodyStrong.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

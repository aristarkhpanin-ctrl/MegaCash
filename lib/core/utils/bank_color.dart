import 'package:flutter/material.dart';

/// Подбор цвета текста поверх заливки банка.
///
/// Цвета банков приходят из данных, а не из дизайн-системы: пользователь может
/// завести карту любого банка. Поэтому цвет текста поверх карточки вычисляется
/// по яркости фона, а не задаётся вручную.
///
/// Логотипы банков не используются — только название текстом и цветовая
/// заливка. Это осознанное решение по товарным знакам.
abstract final class BankPalette {
  /// Текст поверх светлой заливки — тот же тёмный коричнево-чёрный,
  /// что и текст поверх жёлтого.
  static const Color onLight = Color(0xFF1F1A05);

  /// Текст поверх тёмной заливки.
  static const Color onDark = Color(0xFFFFFFFF);

  /// Порог относительной яркости по WCAG.
  static const double luminanceThreshold = 0.5;

  /// Основной цвет текста поверх [background].
  static Color onColor(Color background) =>
      background.computeLuminance() > luminanceThreshold ? onLight : onDark;

  /// Приглушённый вариант — для второстепенных подписей на карточке
  /// (название продукта, надпись «кэшбэк до»).
  static Color onColorSoft(Color background) {
    final base = onColor(background);
    return base == onDark
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.72)
        : const Color(0xFF1F1A05).withValues(alpha: 0.62);
  }

  /// Разбор цвета банка из ARGB-числа, которое хранится в базе.
  static Color fromValue(int argb) => Color(argb);
}

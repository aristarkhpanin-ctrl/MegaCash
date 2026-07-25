import 'package:flutter/material.dart';

/// Семантические цвета «МегаКэша».
///
/// Роли взяты один в один из `tokens.json` дизайн-системы. Материаловская
/// [ColorScheme] не покрывает их: у нас две поверхности, отдельная граница и
/// бренд, который допустим только как заливка. Поэтому — расширение темы.
///
/// Железное правило дизайна: жёлтый (`brand`) нельзя использовать как цвет
/// текста, иконок на светлом фоне, границ и разделителей. Только заливка.
/// Текст поверх жёлтого — всегда [onBrand].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.text,
    required this.textSecondary,
    required this.brand,
    required this.brandPressed,
    required this.onBrand,
    required this.brandSubtle,
    required this.success,
    required this.error,
  });

  /// Подложка всех экранов.
  final Color bg;

  /// Карточки, блоки, поля ввода.
  final Color surface;

  /// Вложенные блоки, неактивные чипы.
  final Color surface2;

  /// Разделители, обводка полей.
  final Color border;

  /// Заголовки и значения.
  final Color text;

  /// Подписи и пояснения.
  final Color textSecondary;

  /// Единственный акцент. Только заливка — никогда не текст и не граница.
  final Color brand;

  /// Состояние нажатия для [brand].
  final Color brandPressed;

  /// Текст и иконки поверх [brand]. Тёмный коричнево-чёрный, не чистый чёрный.
  final Color onBrand;

  /// Лёгкая заливка блока-подсказки.
  final Color brandSubtle;

  /// Подтверждения, прирост выгоды.
  final Color success;

  /// Ошибки, удаление.
  final Color error;

  static const AppColors light = AppColors(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF7F5F0),
    surface2: Color(0xFFEFEBE2),
    border: Color(0xFFE3DDD0),
    text: Color(0xFF1A1814),
    textSecondary: Color(0xFF6B665C),
    brand: Color(0xFFFFC000),
    brandPressed: Color(0xFFE0A800),
    onBrand: Color(0xFF1F1A05),
    brandSubtle: Color(0xFFFFF4D6),
    success: Color(0xFF1E8E3E),
    error: Color(0xFFC5221F),
  );

  /// Фон намеренно тёплый, а не нейтрально-серый: рядом с нейтральным
  /// жёлтый выглядит грязным.
  static const AppColors dark = AppColors(
    bg: Color(0xFF16150F),
    surface: Color(0xFF201E16),
    surface2: Color(0xFF2B2820),
    border: Color(0xFF3B3729),
    text: Color(0xFFF2EEE3),
    textSecondary: Color(0xFF9A9384),
    brand: Color(0xFFFFC72E),
    brandPressed: Color(0xFFE0A800),
    onBrand: Color(0xFF1F1A05),
    brandSubtle: Color(0xFF3A2F0C),
    success: Color(0xFF4ADE80),
    error: Color(0xFFF87171),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? border,
    Color? text,
    Color? textSecondary,
    Color? brand,
    Color? brandPressed,
    Color? onBrand,
    Color? brandSubtle,
    Color? success,
    Color? error,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      border: border ?? this.border,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      brand: brand ?? this.brand,
      brandPressed: brandPressed ?? this.brandPressed,
      onBrand: onBrand ?? this.onBrand,
      brandSubtle: brandSubtle ?? this.brandSubtle,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandPressed: Color.lerp(brandPressed, other.brandPressed, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      brandSubtle: Color.lerp(brandSubtle, other.brandSubtle, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

/// Короткий доступ к токенам: `context.colors.brand`.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

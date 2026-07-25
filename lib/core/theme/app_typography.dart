import 'package:flutter/material.dart';

/// Типографика «МегаКэша».
///
/// Один шрифт на всё приложение — Golos Text, российская гарнитура с полной
/// кириллицей. Иерархия строится весом и размером, не сменой гарнитуры.
/// Шрифт лежит в сборке (`assets/fonts`), а не тянется из сети: приложение
/// обязано работать полностью офлайн.
///
/// Размеры в sp — во Flutter это логические пиксели, которые масштабируются
/// системной настройкой размера шрифта.
abstract final class AppText {
  static const String fontFamily = 'Golos Text';

  /// Крупное число — процент кэшбэка. 40/800.
  static const TextStyle displayPercent = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.0,
    letterSpacing: -0.4,
  );

  /// Заголовок экрана. 26/700.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.26,
  );

  /// Заголовок блока. 18/600.
  static const TextStyle blockTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  /// Основной текст. 16/400.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// То же тело, но полужирное — значения в строках списка, названия банков.
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Подпись, пояснение. 14/400.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Мелкая метка. 12/500.
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Надзаголовок секции: та же метка, но разрядкой и капителью.
  /// Единственное место, где допустим верхний регистр.
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.48,
  );

  /// Текст на кнопках. 16/600.
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Собирает материаловскую [TextTheme] из ролей выше, чтобы стандартные
  /// виджеты подхватывали шрифт без ручной простановки стиля.
  static TextTheme themeFor(Color text, Color textSecondary) {
    return TextTheme(
      displayLarge: displayPercent.copyWith(color: text),
      displayMedium: displayPercent.copyWith(color: text),
      displaySmall: displayPercent.copyWith(color: text),
      headlineLarge: screenTitle.copyWith(color: text),
      headlineMedium: screenTitle.copyWith(color: text),
      headlineSmall: blockTitle.copyWith(color: text),
      titleLarge: blockTitle.copyWith(color: text),
      titleMedium: bodyStrong.copyWith(color: text),
      titleSmall: label.copyWith(color: textSecondary),
      bodyLarge: body.copyWith(color: text),
      bodyMedium: caption.copyWith(color: text),
      bodySmall: label.copyWith(color: textSecondary),
      labelLarge: button.copyWith(color: text),
      labelMedium: label.copyWith(color: textSecondary),
      labelSmall: label.copyWith(color: textSecondary),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

/// Сборка [ThemeData] из токенов дизайн-системы.
///
/// Светлая и тёмная темы обязательны обе — это норма для Android.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final textTheme = AppText.themeFor(c.text, c.textSecondary);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.brand,
      onPrimary: c.onBrand,
      primaryContainer: c.brandSubtle,
      onPrimaryContainer: c.text,
      secondary: c.brand,
      onSecondary: c.onBrand,
      error: c.error,
      onError: brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF1F1A05),
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerHighest: c.surface2,
      outline: c.border,
      outlineVariant: c.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      dividerColor: c.border,
      fontFamily: AppText.fontFamily,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[c],

      // Теней в приложении почти нет — блоки разделяются цветом и отступами.
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.blockTitle.copyWith(color: c.text),
        systemOverlayStyle: brightness == Brightness.light
            ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: c.bg,
                systemNavigationBarIconBrightness: Brightness.dark,
              )
            : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: c.bg,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
      ),

      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
        space: 1,
      ),

      // Кнопка главная: жёлтая заливка, тёмный текст.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return c.surface2;
            if (states.contains(WidgetState.pressed)) return c.brandPressed;
            return c.brand;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return c.textSecondary;
            return c.onBrand;
          }),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          minimumSize: const WidgetStatePropertyAll(
            Size(0, Dimens.minTapTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Spacing.x6),
          ),
          textStyle: const WidgetStatePropertyAll(AppText.button),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: Radii.buttonBorder),
          ),
        ),
      ),

      // Кнопка второстепенная: обводка, без заливки.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStatePropertyAll(c.text),
          overlayColor: WidgetStatePropertyAll(c.surface2),
          side: WidgetStatePropertyAll(BorderSide(color: c.border, width: 1.5)),
          minimumSize: const WidgetStatePropertyAll(
            Size(0, Dimens.minTapTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Spacing.x6),
          ),
          textStyle: const WidgetStatePropertyAll(AppText.button),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: Radii.buttonBorder),
          ),
        ),
      ),

      // Кнопка текстовая.
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(c.text),
          overlayColor: WidgetStatePropertyAll(c.surface2),
          minimumSize: const WidgetStatePropertyAll(
            Size(0, Dimens.minTapTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Spacing.x2),
          ),
          textStyle: const WidgetStatePropertyAll(AppText.button),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: Radii.buttonBorder),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(c.text),
          overlayColor: WidgetStatePropertyAll(c.surface2),
          minimumSize: const WidgetStatePropertyAll(
            Size(Dimens.minTapTarget, Dimens.minTapTarget),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.x4,
          vertical: Spacing.x3,
        ),
        hintStyle: AppText.body.copyWith(color: c.textSecondary),
        labelStyle: AppText.label.copyWith(color: c.textSecondary),
        errorStyle: AppText.label.copyWith(color: c.error),
        border: OutlineInputBorder(
          borderRadius: Radii.fieldBorder,
          borderSide: BorderSide(color: c.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.fieldBorder,
          borderSide: BorderSide(color: c.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.fieldBorder,
          borderSide: BorderSide(color: c.brand, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.fieldBorder,
          borderSide: BorderSide(color: c.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.fieldBorder,
          borderSide: BorderSide(color: c.error, width: 1.5),
        ),
      ),

      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.cardBorder,
          side: BorderSide(color: c.border),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: c.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        titleTextStyle: AppText.blockTitle.copyWith(
          color: c.text,
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
        contentTextStyle: AppText.caption.copyWith(color: c.textSecondary),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.brand,
        linearTrackColor: c.surface2,
        circularTrackColor: c.surface2,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.text,
        contentTextStyle: AppText.caption.copyWith(color: c.bg),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: Radii.buttonBorder,
        ),
      ),

      splashFactory: InkSparkle.splashFactory,
    );
  }
}

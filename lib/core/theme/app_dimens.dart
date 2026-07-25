import 'package:flutter/widgets.dart';

/// Шаг отступов из дизайн-системы. Значения в dp.
abstract final class Spacing {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x6 = 24;
  static const double x8 = 32;

  /// Поля экрана слева и справа.
  static const double screen = 20;

  static const EdgeInsets screenHorizontal =
      EdgeInsets.symmetric(horizontal: screen);
}

/// Радиусы скругления. Значения в dp.
abstract final class Radii {
  static const double card = 12;
  static const double button = 10;
  static const double field = 10;
  static const double chip = 999;

  static const BorderRadius cardBorder = BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonBorder =
      BorderRadius.all(Radius.circular(button));
  static const BorderRadius fieldBorder =
      BorderRadius.all(Radius.circular(field));
  static const BorderRadius chipBorder = BorderRadius.all(Radius.circular(chip));
}

/// Размеры, заданные дизайном.
abstract final class Dimens {
  /// Ни одна интерактивная зона не меньше 48 dp.
  static const double minTapTarget = 48;

  /// Пропорция реальной банковской карты.
  static const double cardAspectRatio = 1.586;

  /// Рекламный баннер: сам блок и высота, которую под него резервирует вёрстка.
  ///
  /// Если реклама не пришла — место схлопывается, а не показывает пустоту,
  /// поэтому [adBannerReservedHeight] применяется только когда баннер есть.
  static const double adBannerWidth = 320;
  static const double adBannerHeight = 50;
  static const double adBannerReservedHeight = 56;

  /// Высота нижней навигации.
  static const double bottomNavHeight = 64;
}

/// Единственная тень в приложении — карта-победитель на экране ответа.
/// Везде остальное блоки разделяются цветом поверхности и отступами.
abstract final class Elevations {
  static const List<BoxShadow> winnerCard = [
    BoxShadow(
      color: Color(0x4DFFC000),
      blurRadius: 0,
      spreadRadius: 4,
    ),
    BoxShadow(
      color: Color(0x59FFC000),
      blurRadius: 26,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Color(0x47000000),
      blurRadius: 34,
      offset: Offset(0, 16),
    ),
  ];
}

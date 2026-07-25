import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// Каркас с нижней навигацией на два раздела: «Кэшбэк» и «Карты».
///
/// Всё нажимаемое — в нижней половине экрана, в зоне большого пальца.
/// Остальные экраны (ответ, месячная настройка, онбординг, настройки)
/// открываются поверх и своей навигации не имеют.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.bg,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: Dimens.bottomNavHeight,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.grid_view_outlined,
                  label: 'Кэшбэк',
                  selected: navigationShell.currentIndex == 0,
                  onTap: () => _go(0),
                ),
                _NavItem(
                  icon: Icons.credit_card_outlined,
                  label: 'Карты',
                  selected: navigationShell.currentIndex == 1,
                  onTap: () => _go(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int index) {
    navigationShell.goBranch(
      index,
      // Повторное нажатие на активный раздел возвращает его в корень.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.text : c.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Активный раздел помечен бренд-подложкой под иконкой.
            // Жёлтый здесь — заливка, а не цвет иконки.
            Container(
              width: 44,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? c.brandSubtle : Colors.transparent,
                borderRadius: Radii.chipBorder,
              ),
              child: Icon(icon, size: 21, color: fg),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppText.label.copyWith(
                color: fg,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/app.dart';
import 'package:megacash/core/theme/app_colors.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MegaCashApp()));
    await tester.pumpAndSettle();
  }

  testWidgets('Приложение открывается на главном экране', (tester) async {
    await pumpApp(tester);

    expect(find.text('Главный экран'), findsOneWidget);
    // Нижняя навигация на два раздела.
    expect(find.text('Кэшбэк'), findsOneWidget);
    expect(find.text('Карты'), findsOneWidget);
  });

  testWidgets('Разделы нижней навигации переключаются', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Карты'));
    await tester.pumpAndSettle();
    expect(find.text('Мои карты'), findsWidgets);

    await tester.tap(find.text('Кэшбэк'));
    await tester.pumpAndSettle();
    expect(find.text('Главный экран'), findsOneWidget);
  });

  testWidgets('С главного открывается ответ и возвращается назад',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Открыть ответ (А2)'));
    await tester.pumpAndSettle();
    expect(find.text('Какой картой платить'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Главный экран'), findsOneWidget);
  });

  testWidgets('Проходится вся месячная настройка Б1 → Б8', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Настроить кэшбэк на месяц (Б1)'));
    await tester.pumpAndSettle();

    for (final label in const [
      'Загрузить скриншоты (Б2)',
      'Распознать (Б3)',
      'Проверить распознанное (Б4)',
      'Продолжить (Б6)',
      'Перейти к активации (Б7)',
      'Всё включил (Б8)',
    ]) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    expect(find.text('Кэшбэк на месяц собран'), findsOneWidget);
  });

  testWidgets('Тема переключается на тёмную и обратно', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Настройки'));
    await tester.pumpAndSettle();

    Color scaffoldBg() {
      final ctx = tester.element(find.text('Тёмная').first);
      return Theme.of(ctx).scaffoldBackgroundColor;
    }

    await tester.tap(find.text('Тёмная'));
    await tester.pumpAndSettle();
    expect(scaffoldBg(), AppColors.dark.bg);

    await tester.tap(find.text('Светлая'));
    await tester.pumpAndSettle();
    expect(scaffoldBg(), AppColors.light.bg);
  });
}

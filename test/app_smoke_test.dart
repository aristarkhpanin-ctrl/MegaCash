import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:megacash/app.dart';
import 'package:megacash/core/theme/app_colors.dart';
import 'package:megacash/data/local/isar_database.dart';
import 'package:megacash/data/providers.dart';

void main() {
  late Directory dir;
  late Isar isar;
  var counter = 0;

  // База намеренно не закрывается: экран карт держит на ней поток, а
  // закрытие под живой подпиской подвешивает процесс тестов. Каждый тест
  // работает со своим инстансом и своим каталогом, так что мешать друг
  // другу они не могут, а каталоги убираются в самом конце.
  final dirs = <Directory>[];

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('megacash_smoke');
    dirs.add(dir);
    isar = await IsarDatabase.openAt(
      directory: dir.path,
      instanceName: 'smoke_${counter++}',
    );
  });

  tearDownAll(() {
    for (final d in dirs) {
      if (d.existsSync()) d.deleteSync(recursive: true);
    }
  });

  /// Прокачивает кадры, давая настоящему вводу-выводу шанс отработать.
  ///
  /// `pumpAndSettle` здесь не годится на экранах с индикатором загрузки:
  /// он крутится бесконечно и «успокоения» не наступает никогда. А потоки
  /// Isar приходят из нативного кода и мимо часов тестового окружения,
  /// поэтому между кадрами нужен настоящий `runAsync`.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 80)),
      );
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  /// Нажатие, за которым идёт настоящая работа с базой.
  ///
  /// Обычный `tap` запускает обработчик в поддельной асинхронной зоне
  /// теста, где `await` на операциях Isar не разрешается никогда. Внутри
  /// `runAsync` обработчик выполняется в настоящей зоне и доходит до конца.
  Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.runAsync(() async {
      await tester.tap(finder);
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await settle(tester);
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [isarProvider.overrideWithValue(isar)],
        child: const MegaCashApp(),
      ),
    );

    // Разбираем дерево до закрытия базы: иначе Isar закрывается, пока
    // на него ещё подписан поток списка карт, и тест зависает.
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    await settle(tester);
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
    await settle(tester);
    // Карт ещё нет — показано пустое состояние.
    expect(find.text('Мои карты'), findsOneWidget);
    expect(find.text('Пока нет карт'), findsOneWidget);

    await tester.tap(find.text('Кэшбэк'));
    await settle(tester);
    expect(find.text('Главный экран'), findsOneWidget);
  });

  testWidgets('С главного открывается ответ и возвращается назад',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Открыть ответ (А2)'));
    await settle(tester);
    expect(find.text('Какой картой платить'), findsWidgets);

    await tester.pageBack();
    await settle(tester);
    expect(find.text('Главный экран'), findsOneWidget);
  });

  testWidgets('Проходится вся месячная настройка Б1 → Б8', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Настроить кэшбэк на месяц (Б1)'));
    await settle(tester);

    for (final label in const [
      'Загрузить скриншоты (Б2)',
      'Распознать (Б3)',
      'Проверить распознанное (Б4)',
      'Продолжить (Б6)',
      'Перейти к активации (Б7)',
      'Всё включил (Б8)',
    ]) {
      await tester.tap(find.text(label));
      await settle(tester);
    }

    expect(find.text('Кэшбэк на месяц собран'), findsOneWidget);
  });

  testWidgets('Тема переключается на тёмную и обратно', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Настройки'));
    await settle(tester);

    Color scaffoldBg() {
      final ctx = tester.element(find.text('Тёмная').first);
      return Theme.of(ctx).scaffoldBackgroundColor;
    }

    await tester.tap(find.text('Тёмная'));
    await settle(tester);
    expect(scaffoldBg(), AppColors.dark.bg);

    await tester.tap(find.text('Светлая'));
    await settle(tester);
    expect(scaffoldBg(), AppColors.light.bg);
  });

  testWidgets('Карта добавляется руками и появляется в списке',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Карты'));
    await settle(tester);

    await tester.tap(find.text('Добавить карту'));
    await settle(tester);

    // Шаг 1 — банк из списка.
    expect(find.text('Выберите банк'), findsOneWidget);
    await tester.tap(find.text('Т-Банк'));
    await settle(tester);

    // Шаг 2 — продукт и базовый процент.
    expect(find.text('Шаг 2 из 2'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Например, Black'),
      'Black',
    );
    await settle(tester);

    await tapAndWait(tester, find.text('Сохранить карту'));
    // Список едет из потока Isar — он приходит из нативного кода и своим
    // темпом, поэтому после возврата на экран даём ему ещё дойти.
    await settle(tester);
    await settle(tester);

    expect(find.text('Т-Банк'), findsOneWidget);
    expect(find.text('1 карта'), findsOneWidget);
    // Строка карты собирает продукт, базовый процент и число категорий.
    expect(
      find.textContaining('Black · базовый 1% · 0 категорий'),
      findsOneWidget,
    );
  });
}

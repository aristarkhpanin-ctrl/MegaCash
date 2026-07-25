import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:megacash/app.dart';
import 'package:megacash/core/theme/app_colors.dart';
import 'package:megacash/data/local/isar_database.dart';
import 'package:megacash/data/providers.dart';
import 'package:megacash/features/cards/cards_screen.dart';
import 'package:megacash/features/home/answer_screen.dart';
import 'package:megacash/features/home/home_screen.dart';

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
  /// Ждёт появления виджета, прокачивая кадры.
  ///
  /// Экраны читают данные из базы и до первого ответа показывают пустоту,
  /// поэтому нажимать сразу после перехода нельзя — цели ещё нет.
  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var attempt = 0; attempt < 6; attempt++) {
      if (finder.evaluate().isNotEmpty) return;
      await settle(tester);
    }
  }

  Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await waitFor(tester, finder);

    // Цель может быть ниже видимой области: нажатие по координатам за
    // краем экрана просто не попадёт по кнопке и ничего не произойдёт.
    try {
      await tester.ensureVisible(finder);
      await tester.pump();
    } on Object {
      // Виджет не внутри прокручиваемой области — нажимаем как есть.
    }

    await tester.runAsync(() async {
      await tester.tap(finder);
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await settle(tester);
  }

  Future<void> pumpApp(WidgetTester tester) async {
    // Тот же размер, в котором нарисованы макеты. По умолчанию тестовое
    // окно 800×600 — экраны в нём раскладываются не так, как на телефоне.
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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

  /// Оба раздела нижней навигации живут в дереве одновременно, поэтому
  /// один и тот же текст находится дважды. Ищем внутри нужного экрана.
  Finder inCards(Finder what) =>
      find.descendant(of: find.byType(CardsScreen), matching: what);
  Finder inHome(Finder what) =>
      find.descendant(of: find.byType(HomeScreen), matching: what);
  Finder inAnswer(Finder what) =>
      find.descendant(of: find.byType(AnswerScreen), matching: what);

  /// Добавляет карту через интерфейс: банк из списка, продукт, базовый.
  Future<void> addCard(
    WidgetTester tester, {
    required String bank,
    required String product,
    String baseRate = '1',
  }) async {
    await tapAndWait(tester, find.text('Карты'));
    // Кнопка «Добавить карту» есть и в пустом состоянии, и в конце списка.
    await tapAndWait(tester, inCards(find.text('Добавить карту')));

    await tapAndWait(tester, find.text(bank));

    await tester.enterText(
      find.widgetWithText(TextField, 'Например, Black'),
      product,
    );
    await settle(tester);

    final rateField = find.byType(TextField).at(1);
    await tester.enterText(rateField, baseRate);
    await settle(tester);

    await tapAndWait(tester, find.text('Сохранить карту'));
    // Список едет из потока Isar — он приходит из нативного кода своим
    // темпом, поэтому после возврата даём ему дойти.
    await settle(tester);
    await settle(tester);
  }

  testWidgets('Приложение открывается на главном экране', (tester) async {
    await pumpApp(tester);

    // Карт нет — главный предлагает добавить первую.
    expect(find.text('Добавьте первую карту'), findsOneWidget);
    expect(find.text('Нет карт'), findsOneWidget);
    expect(find.text('Кэшбэк'), findsOneWidget);
    expect(find.text('Карты'), findsOneWidget);
  });

  testWidgets('Разделы нижней навигации переключаются', (tester) async {
    await pumpApp(tester);

    await tapAndWait(tester, find.text('Карты'));
    expect(find.text('Мои карты'), findsOneWidget);
    expect(find.text('Пока нет карт'), findsOneWidget);

    await tapAndWait(tester, find.text('Кэшбэк'));
    expect(inHome(find.text('Добавьте первую карту')), findsOneWidget);
  });

  testWidgets('Тема переключается на тёмную и обратно', (tester) async {
    await pumpApp(tester);

    await tapAndWait(tester, find.byTooltip('Настройки'));

    Color scaffoldBg() {
      final ctx = tester.element(find.text('Тёмная').first);
      return Theme.of(ctx).scaffoldBackgroundColor;
    }

    await tapAndWait(tester, find.text('Тёмная'));
    expect(scaffoldBg(), AppColors.dark.bg);

    await tapAndWait(tester, find.text('Светлая'));
    expect(scaffoldBg(), AppColors.light.bg);
  });

  testWidgets('Карта добавляется руками и появляется в списке',
      (tester) async {
    await pumpApp(tester);
    await addCard(tester, bank: 'Т-Банк', product: 'Black');

    expect(inCards(find.text('Т-Банк')), findsOneWidget);
    expect(find.text('1 карта'), findsOneWidget);
    expect(
      find.textContaining('Black · базовый 1% · 0 категорий'),
      findsOneWidget,
    );
  });

  /// Полный путь ежедневного использования: завести карты, назначить
  /// категорию руками, получить ответ у кассы.
  testWidgets('Категория назначается руками, ответ показывает нужную карту',
      (tester) async {
    await pumpApp(tester);

    await addCard(tester, bank: 'Т-Банк', product: 'Black');
    await addCard(tester, bank: 'Сбербанк', product: 'СберКарта');

    // Заводим предложение банка и выбираем категорию.
    await tapAndWait(tester, inCards(find.text('Т-Банк')));
    await tapAndWait(tester, find.text('Добавить категорию'));
    await tapAndWait(tester, find.text('Супермаркеты'));

    await tester.enterText(find.byType(TextField).last, '7');
    await settle(tester);
    await tapAndWait(tester, find.text('Добавить'));

    // Чип появился, отмечаем его.
    await waitFor(tester, find.text('Супермаркеты'));
    expect(find.text('Супермаркеты'), findsOneWidget);
    expect(find.text('Выбрано 0 из 3'), findsOneWidget);

    await tapAndWait(tester, find.text('Супермаркеты'));
    expect(find.text('Выбрано 1 из 3'), findsOneWidget);

    // Возвращаемся на главный: категория стала плиткой.
    await tapAndWait(tester, find.byTooltip('Back'));
    await tapAndWait(tester, find.text('Кэшбэк'));

    await waitFor(tester, inHome(find.text('Супермаркеты')));
    expect(inHome(find.text('Супермаркеты')), findsOneWidget);
    expect(inHome(find.text('7%')), findsOneWidget);
    expect(find.text('1 активная категория'), findsOneWidget);

    // Ответ у кассы: платить Т-Банком под 7%, Сбербанк ниже с базовым 1%.
    await tapAndWait(tester, inHome(find.text('Супермаркеты')));

    await waitFor(tester, inAnswer(find.text('ПЛАТИТЕ ЭТОЙ')));
    expect(inAnswer(find.text('ЧЕМ ПЛАТИТЬ')), findsOneWidget);
    expect(inAnswer(find.text('ПЛАТИТЕ ЭТОЙ')), findsOneWidget);
    expect(inAnswer(find.text('Т-Банк')), findsOneWidget);
    expect(inAnswer(find.text('7%')), findsOneWidget);

    // Проигравшие ниже по экрану — прокручиваем к ним.
    await tester.scrollUntilVisible(
      inAnswer(find.text('Сбербанк')),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await settle(tester);

    expect(inAnswer(find.text('ОСТАЛЬНЫЕ КАРТЫ')), findsOneWidget);
    expect(inAnswer(find.text('Сбербанк')), findsOneWidget);
    expect(inAnswer(find.text('1%')), findsOneWidget);
  });

  testWidgets('Проходится вся месячная настройка Б1 → Б8', (tester) async {
    await pumpApp(tester);
    await addCard(tester, bank: 'Т-Банк', product: 'Black');
    await tapAndWait(tester, find.text('Кэшбэк'));

    await tapAndWait(tester, inHome(find.text('Настроить кэшбэк')));

    for (final label in const [
      'Загрузить скриншоты (Б2)',
      'Распознать (Б3)',
      'Проверить распознанное (Б4)',
      'Продолжить (Б6)',
      'Перейти к активации (Б7)',
      'Всё включил (Б8)',
    ]) {
      await tapAndWait(tester, find.text(label));
    }

    expect(find.text('Кэшбэк на месяц собран'), findsOneWidget);
  });
}

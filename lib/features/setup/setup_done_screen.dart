import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б8 · Подтверждение.
///
/// Всё активировано, приложение готово. Переход на главный экран.
class SetupDoneScreen extends StatelessWidget {
  const SetupDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б8',
          title: 'Кэшбэк на месяц собран',
          description:
              'Настройка завершена. Теперь у кассы достаточно открыть приложение.',
          actions: [
            StubAction(
              'На главный экран (А1)',
              () => context.go(Routes.home),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

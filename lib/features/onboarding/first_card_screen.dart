import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// В3 · Первая карта.
///
/// Выбор банка из списка с поиском, затем название продукта
/// и базовый процент.
class FirstCardScreen extends StatelessWidget {
  const FirstCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Первая карта'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'В3',
          title: 'Первая карта',
          description:
              'Шаг 1 — банк из списка с поиском. Шаг 2 — название продукта и базовый процент.',
          actions: [
            StubAction(
              'Сохранить и на главный (А1)',
              () => context.go(Routes.home),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б7 · Инструкция по активации.
///
/// Список по банкам: в каком банке какие категории выбрать. Формат такой,
/// чтобы было удобно держать перед глазами, переключаясь в приложение банка.
/// Отметки о выполнении по каждому банку.
class ActivationScreen extends StatelessWidget {
  const ActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Активация в банках'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б7',
          title: 'Активация в банках',
          description:
              'В каком банке что включить. Отмечайте по ходу — список не потеряется.',
          actions: [
            StubAction(
              'Всё включил (Б8)',
              () => context.push(Routes.setupDone),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

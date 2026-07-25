import 'package:flutter/material.dart';

import '../../core/widgets/screen_stub.dart';

/// А2 · Ответ — какой картой платить.
///
/// Самый важный экран приложения. Сверху название категории, затем
/// карта-победитель в цвете своего банка с названием и процентом, ниже —
/// остальные карты компактными строками, приглушённо. Рекламы здесь нет.
/// Состояния: обычное; ни одна карта не покрывает категорию.
class AnswerScreen extends StatelessWidget {
  const AnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Супермаркеты'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'А2',
          title: 'Какой картой платить',
          description:
              'Карта-победитель крупно, в цвете банка. Ниже — остальные карты строками. Рекламы на этом экране нет: ответ должен читаться на вытянутой руке.',
        ),
      ),
    );
  }
}

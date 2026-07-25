import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// А3 · Мои карты.
///
/// Список карт с цветовыми метками, базовым процентом и количеством
/// выбранных категорий. Снизу баннер. Состояния: пусто; список; десять карт.
class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ScreenStub(
          code: 'А3',
          title: 'Мои карты',
          description:
              'Список карт: цветовая метка, банк, продукт, базовый процент и количество выбранных категорий.',
          actions: [
            StubAction(
              'Открыть карточку банка (А4)',
              () => context.push(Routes.cardEdit),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

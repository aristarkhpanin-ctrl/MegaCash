import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б6 · Рекомендация — ключевой экран продукта.
///
/// Два столбца: «Выбранные» и «Не выбранные». Строки перетаскиваются между
/// столбцами, над ними — сводка занятых слотов. У каждой невыбранной
/// категории показана причина, по которой она не попала в выбранные.
/// Состояния: обычное; есть свободные слоты; только что был переброс.
class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рекомендация'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б6',
          title: 'Рекомендация',
          description:
              'Выбранные и не выбранные категории со сводкой по слотам. У каждой невыбранной — причина, а не непрозрачный вердикт. Переброс перезапускает оптимизатор целиком.',
          actions: [
            StubAction(
              'Перейти к активации (Б7)',
              () => context.push(Routes.setupActivation),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

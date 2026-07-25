import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б3 · Распознавание идёт.
///
/// Прогресс с указанием, какой файл обрабатывается («3 из 8»),
/// и возможность отменить.
class RecognizingScreen extends StatelessWidget {
  const RecognizingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б3',
          title: 'Распознаём категории',
          description:
              'Читаем проценты и названия с ваших скриншотов. Всё локально, на устройстве.',
          actions: [
            StubAction(
              'Проверить распознанное (Б4)',
              () => context.push(Routes.setupReview),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

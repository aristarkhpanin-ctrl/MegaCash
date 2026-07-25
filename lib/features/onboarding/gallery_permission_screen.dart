import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// В2 · Зачем нужен доступ к галерее.
///
/// Объяснение перед системным запросом разрешения.
class GalleryPermissionScreen extends StatelessWidget {
  const GalleryPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ScreenStub(
          code: 'В2',
          title: 'Нужен доступ к галерее',
          description:
              'Распознавание идёт локально, изображения никуда не отправляются. Доступ только к выбранным снимкам.',
          actions: [
            StubAction(
              'Дальше (В3)',
              () => context.push(Routes.onboardingFirstCard),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

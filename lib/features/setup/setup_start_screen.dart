import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б1 · Начало месячной настройки.
///
/// Объяснение, что сейчас произойдёт: загрузите скриншоты — получите
/// рекомендацию — активируете в банках. Три шага, показанные как три шага.
class SetupStartScreen extends StatelessWidget {
  const SetupStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б1',
          title: 'Три шага — и кэшбэк на месяц собран',
          description:
              'Загрузите скриншоты → получите рекомендацию → активируйте в банках.',
          actions: [
            StubAction(
              'Загрузить скриншоты (Б2)',
              () => context.push(Routes.setupScreenshots),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

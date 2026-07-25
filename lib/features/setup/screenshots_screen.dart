import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б2 · Загрузка скриншотов.
///
/// Инструкция, что именно снимать, выбор нескольких файлов из галереи,
/// список выбранных с миниатюрами и удалением. До пятнадцати штук.
/// Состояния: пусто; выбрано несколько; достигнут лимит.
class ScreenshotsScreen extends StatelessWidget {
  const ScreenshotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Скриншоты'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б2',
          title: 'Скриншоты',
          description:
              'Экран «Категории кэшбэка» из приложения банка, по одному скриншоту на банк. До 15 изображений.',
          actions: [
            StubAction(
              'Распознать (Б3)',
              () => context.push(Routes.setupRecognizing),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

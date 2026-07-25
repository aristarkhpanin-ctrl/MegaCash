import 'package:flutter/material.dart';

import '../../core/widgets/screen_stub.dart';

/// Г2 · О приложении.
///
/// Версия, дисклеймер о том, что приложение не связано с банками и не
/// является финансовым советником, ссылки на политику конфиденциальности
/// и пользовательское соглашение.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'Г2',
          title: 'О приложении',
          description:
              'Версия, дисклеймер о независимости от банков, ссылки на политику конфиденциальности и пользовательское соглашение.',
        ),
      ),
    );
  }
}

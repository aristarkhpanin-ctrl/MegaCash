import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// В1 · Что делает приложение.
///
/// Один экран, не пять. Суть в двух предложениях и кнопка.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ScreenStub(
          code: 'В1',
          title: 'Платите картой, которая вернёт больше',
          description:
              'МегаКэш помнит кэшбэк по всем вашим картам и у кассы подсказывает, какой платить именно в этой категории.',
          actions: [
            StubAction(
              'Начать (В2)',
              () => context.push(Routes.onboardingPermission),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

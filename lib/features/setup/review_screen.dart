import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/widgets/screen_stub.dart';

/// Б4 · Проверка распознанного.
///
/// Результат, сгруппированный по банкам. Неуверенно распознанные помечены
/// и вынесены наверх. Можно исправить процент, удалить лишнее, добавить
/// пропущенное. Состояния: всё уверенно; часть под вопросом; распознать не
/// удалось совсем — этот случай будет встречаться часто.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Проверьте распознанное'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б4',
          title: 'Проверьте распознанное',
          description:
              'Результат по банкам. Неуверенное — наверх и под жёлтой отметкой. Если не распозналось совсем, отсюда переход к ручному вводу.',
          actions: [
            StubAction(
              'Ввести вручную (Б5)',
              () => context.push(Routes.setupManual),
            ),
            StubAction(
              'Продолжить (Б6)',
              () => context.push(Routes.setupRecommendation),
              primary: true,
            ),
          ],
        ),
      ),
    );
  }
}

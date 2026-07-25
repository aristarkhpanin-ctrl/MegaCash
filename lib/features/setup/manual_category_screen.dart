import 'package:flutter/material.dart';

import '../../core/widgets/screen_stub.dart';

/// Б5 · Ручной ввод категории.
///
/// Выбор категории из списка с поиском, ввод процента, выбор карты.
class ManualCategoryScreen extends StatelessWidget {
  const ManualCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категория вручную'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'Б5',
          title: 'Категория вручную',
          description:
              'Поиск по справочнику категорий, процент кэшбэка и карта, на которой категория доступна.',
        ),
      ),
    );
  }
}

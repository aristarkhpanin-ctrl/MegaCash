import 'package:flutter/material.dart';

import '../../core/widgets/screen_stub.dart';

/// А4 · Карточка банка — редактирование.
///
/// Название банка и продукта, базовый процент, лимит категорий, список
/// доступных категорий чипами с отметкой выбранных, удаление карты.
class CardEditScreen extends StatelessWidget {
  const CardEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта банка'),
      ),
      body: SafeArea(
        child: ScreenStub(
          code: 'А4',
          title: 'Карта банка',
          description:
              'Продукт, базовый процент, лимит слотов и чипы категорий. Когда лимит выбран, остальные чипы гаснут.',
        ),
      ),
    );
  }
}

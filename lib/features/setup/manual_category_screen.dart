import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers.dart';
import '../../domain/models/category.dart';
import 'setup_controller.dart';

/// Б5 · Ручной ввод категории.
///
/// Нужен не как запасной путь на случай сбоя распознавания, а как
/// полноценный: у части банков список категорий не помещается на экран,
/// у части — предложения приходят письмом, а не в приложении.
class ManualCategoryScreen extends ConsumerStatefulWidget {
  const ManualCategoryScreen({super.key});

  @override
  ConsumerState<ManualCategoryScreen> createState() =>
      _ManualCategoryScreenState();
}

class _ManualCategoryScreenState
    extends ConsumerState<ManualCategoryScreen> {
  final _searchController = TextEditingController();
  final _rateController = TextEditingController(text: '5');

  String? _cardId;
  Category? _category;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final banks = ref.watch(cardsProvider).value ?? const [];
    final bankName = {for (final b in banks) b.card.id: b.bankName};
    final categories = ref.watch(categoriesProvider);

    final query = _normalize(_searchController.text);
    final matches = categories
        .where((cat) => query.isEmpty || _normalize(cat.name).contains(query))
        .take(30)
        .toList();

    final ready = _cardId != null && _category != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Своя категория')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.screen,
                  Spacing.x2,
                  Spacing.screen,
                  Spacing.x6,
                ),
                children: [
                  Text(
                    'В КАКОЙ КАРТЕ',
                    style: AppText.label.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 0.48,
                    ),
                  ),
                  const SizedBox(height: Spacing.x2),
                  Wrap(
                    spacing: Spacing.x2,
                    runSpacing: Spacing.x2,
                    children: [
                      for (final card in state.cards)
                        ChoiceChip(
                          label: Text(
                            bankName[card.id] ?? card.productName,
                          ),
                          selected: _cardId == card.id,
                          onSelected: (_) =>
                              setState(() => _cardId = card.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: Spacing.x6),
                  Text(
                    'КАКАЯ КАТЕГОРИЯ',
                    style: AppText.label.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 0.48,
                    ),
                  ),
                  const SizedBox(height: Spacing.x2),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Поиск категории',
                      prefixIcon: Icon(Icons.search, size: 20),
                    ),
                  ),
                  const SizedBox(height: Spacing.x2),
                  Wrap(
                    spacing: Spacing.x2,
                    runSpacing: Spacing.x2,
                    children: [
                      for (final cat in matches)
                        ChoiceChip(
                          label: Text(cat.name),
                          selected: _category?.id == cat.id,
                          onSelected: (_) =>
                              setState(() => _category = cat),
                        ),
                    ],
                  ),
                  const SizedBox(height: Spacing.x6),
                  Text(
                    'КАКОЙ ПРОЦЕНТ',
                    style: AppText.label.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 0.48,
                    ),
                  ),
                  const SizedBox(height: Spacing.x2),
                  TextField(
                    controller: _rateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    decoration: InputDecoration(
                      suffixText: '%',
                      errorText: _error,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.screen,
                Spacing.x2,
                Spacing.screen,
                Spacing.x4,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ready ? _save : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Добавить'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final rate = double.tryParse(
      _rateController.text.trim().replaceAll(',', '.'),
    );
    if (rate == null || rate <= 0 || rate > 100) {
      setState(() => _error = 'Введите процент больше 0 и не больше 100.');
      return;
    }

    ref.read(setupControllerProvider.notifier).addManualOffer(
          cardId: _cardId!,
          categoryId: _category!.id,
          rate: rate,
        );
    context.pop();
  }

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll('ё', 'е').trim();
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/ids.dart';
import '../../data/providers.dart';
import '../../domain/models/category.dart';
import '../../domain/models/monthly_offer.dart';
import '../home/home_providers.dart';

/// Ручное добавление предложения банка: категория и процент.
///
/// До распознавания скриншотов это единственный способ завести категории,
/// а после — способ поправить то, что распозналось неверно. Поэтому нужен
/// всегда, а не только на время разработки.
Future<bool> showAddOfferSheet(
  BuildContext context, {
  required String cardId,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _AddOfferSheet(cardId: cardId),
  );
  return saved ?? false;
}

class _AddOfferSheet extends ConsumerStatefulWidget {
  const _AddOfferSheet({required this.cardId});

  final String cardId;

  @override
  ConsumerState<_AddOfferSheet> createState() => _AddOfferSheetState();
}

class _AddOfferSheetState extends ConsumerState<_AddOfferSheet> {
  final _searchController = TextEditingController();
  final _rateController = TextEditingController(text: '5');

  Category? _picked;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _searchController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final categories = ref.watch(categoriesProvider);
    final taken = ref.watch(cardOffersProvider(widget.cardId)).value ?? const [];
    final takenIds = taken.map((o) => o.categoryId).toSet();

    final query = _normalize(_searchController.text);
    final available = categories
        .where((cat) => !takenIds.contains(cat.id))
        .where((cat) => query.isEmpty || _normalize(cat.name).contains(query))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.screen,
                Spacing.x4,
                Spacing.screen,
                Spacing.x3,
              ),
              child: Text(
                _picked == null ? 'Какая категория' : 'Какой процент',
                style: AppText.blockTitle.copyWith(color: c.text),
              ),
            ),
            Expanded(
              child: _picked == null
                  ? _buildPicker(c, available)
                  : _buildRate(c),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker(AppColors c, List<Category> available) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.screen,
            0,
            Spacing.screen,
            Spacing.x3,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Поиск категории',
              prefixIcon: Icon(Icons.search, size: 20),
            ),
          ),
        ),
        Expanded(
          child: available.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.x8),
                    child: Text(
                      'Все категории справочника уже заведены для этой карты.',
                      textAlign: TextAlign.center,
                      style: AppText.caption.copyWith(color: c.textSecondary),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.screen,
                    0,
                    Spacing.screen,
                    Spacing.x6,
                  ),
                  itemCount: available.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: c.border),
                  itemBuilder: (context, i) {
                    final cat = available[i];
                    return InkWell(
                      onTap: () => setState(() => _picked = cat),
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: Dimens.minTapTarget,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          cat.name,
                          style: AppText.body.copyWith(color: c.text),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRate(AppColors c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screen,
        0,
        Spacing.screen,
        Spacing.x6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _picked!.name,
            style: AppText.bodyStrong.copyWith(color: c.text),
          ),
          const SizedBox(height: Spacing.x4),
          TextField(
            controller: _rateController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            decoration: InputDecoration(suffixText: '%', errorText: _error),
          ),
          const SizedBox(height: Spacing.x2),
          Text(
            'Процент, который банк предлагает по этой категории в этом месяце.',
            style: AppText.label.copyWith(color: c.textSecondary),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _picked = null),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                  child: const Text('Назад'),
                ),
              ),
              const SizedBox(width: Spacing.x3),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                  child: const Text('Добавить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final rate = double.tryParse(
      _rateController.text.trim().replaceAll(',', '.'),
    );
    if (rate == null || rate <= 0 || rate > 100) {
      setState(() => _error = 'Введите процент больше 0 и не больше 100.');
      return;
    }

    setState(() => _saving = true);

    final monthKey = ref.read(currentMonthProvider);
    await ref.read(offerRepositoryProvider).saveAll([
      MonthlyOffer(
        id: Ids.generate(),
        cardId: widget.cardId,
        monthKey: monthKey,
        categoryId: _picked!.id,
        rate: rate,
        source: OfferSource.manual,
      ),
    ]);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll('ё', 'е').trim();
}

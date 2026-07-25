import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/ids.dart';
import '../../core/widgets/mc_chip.dart';
import '../../data/providers.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/models/selection.dart';
import '../home/home_providers.dart';
import 'add_offer_sheet.dart';

/// А4 · Карточка банка — редактирование.
///
/// Название банка и продукта, базовый процент, лимит категорий, чипы
/// доступных категорий с отметкой выбранных и удаление карты.
class CardEditScreen extends ConsumerStatefulWidget {
  const CardEditScreen({super.key, required this.cardId});

  final String cardId;

  @override
  ConsumerState<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends ConsumerState<CardEditScreen> {
  final _productController = TextEditingController();
  final _rateController = TextEditingController();

  PaymentCard? _card;
  String _bankName = '';
  int _bankColor = 0xFF6B665C;
  int _slotLimit = 3;
  bool _loading = true;
  bool _dirty = false;
  String? _rateError;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _productController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final card = await ref.read(cardRepositoryProvider).byId(widget.cardId);
    if (card == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final bank = await ref.read(bankRepositoryProvider).byId(card.bankId);
    if (!mounted) return;
    setState(() {
      _card = card;
      _bankName = bank?.name ?? 'Банк';
      _bankColor = bank?.colorValue ?? _bankColor;
      _slotLimit = card.slotLimit;
      _productController.text = card.productName;
      _rateController.text = _rateText(card.baseRate);
      _loading = false;
    });
  }

  static String _rateText(double rate) => rate == rate.roundToDouble()
      ? rate.round().toString()
      : rate.toString().replaceAll('.', ',');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Карта банка')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_card == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Карта банка')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.x8),
            child: Text(
              'Карта не найдена. Возможно, она была удалена.',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта банка'),
        actions: [
          TextButton(
            onPressed: _dirty ? _save : null,
            child: Text(
              'Готово',
              style: AppText.caption.copyWith(
                color: _dirty ? c.text : c.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.screen,
            Spacing.x2,
            Spacing.screen,
            Spacing.x6,
          ),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.x3 + 2,
                vertical: Spacing.x3,
              ),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border.all(color: c.border),
                borderRadius: Radii.cardBorder,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(_bankColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(9)),
                    ),
                  ),
                  const SizedBox(width: Spacing.x3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Банк',
                        style: AppText.label.copyWith(color: c.textSecondary),
                      ),
                      Text(
                        _bankName,
                        style: AppText.bodyStrong.copyWith(color: c.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.x6),
            _Label('Название продукта'),
            const SizedBox(height: Spacing.x2 - 2),
            TextField(
              controller: _productController,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => _markDirty(),
            ),
            const SizedBox(height: Spacing.x6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Базовый процент'),
                      const SizedBox(height: Spacing.x2 - 2),
                      TextField(
                        controller: _rateController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.,]'),
                          ),
                        ],
                        onChanged: (_) {
                          if (_rateError != null) _rateError = null;
                          _markDirty();
                        },
                        decoration: InputDecoration(
                          suffixText: '%',
                          errorText: _rateError,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Лимит категорий'),
                      const SizedBox(height: Spacing.x2 - 2),
                      Container(
                        height: Dimens.minTapTarget,
                        padding: const EdgeInsets.only(
                          left: Spacing.x3 + 2,
                          right: Spacing.x1 + 2,
                        ),
                        decoration: BoxDecoration(
                          color: c.surface,
                          border: Border.all(color: c.border, width: 1.5),
                          borderRadius: Radii.fieldBorder,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$_slotLimit',
                                style: AppText.body.copyWith(color: c.text),
                              ),
                            ),
                            _Step(
                              icon: Icons.remove,
                              onTap: _slotLimit > 1
                                  ? () {
                                      setState(() => _slotLimit--);
                                      _markDirty();
                                    }
                                  : null,
                            ),
                            const SizedBox(width: 2),
                            _Step(
                              icon: Icons.add,
                              onTap: _slotLimit < 10
                                  ? () {
                                      setState(() => _slotLimit++);
                                      _markDirty();
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.x8),
            _CategoryChips(cardId: widget.cardId, slotLimit: _slotLimit),
            const SizedBox(height: Spacing.x8),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Удалить карту'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, Dimens.minTapTarget),
                foregroundColor: c.error,
                side: BorderSide(color: c.error, width: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  Future<void> _save() async {
    final raw = _rateController.text.trim().replaceAll(',', '.');
    final rate = double.tryParse(raw);
    if (rate == null || rate < 0 || rate > 100) {
      setState(() => _rateError = 'Введите процент от 0 до 100.');
      return;
    }

    final product = _productController.text.trim();
    await ref.read(cardRepositoryProvider).save(
          _card!.copyWith(
            productName: product.isEmpty ? 'Основная' : product,
            baseRate: rate,
            slotLimit: _slotLimit,
          ),
        );

    if (!mounted) return;
    // Список карт не пересобираем вручную: он живёт на потоке Isar и
    // обновится сам. Инвалидация прямо перед закрытием экрана роняла бы
    // обновление в середину сборки кадра перехода.
    context.pop();
  }

  Future<void> _confirmDelete() async {
    final c = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить карту?'),
        content: Text(
          'Вместе с картой удалятся её предложения и выбранные категории. '
          'Отменить это действие нельзя.',
          style: AppText.caption.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Удалить', style: TextStyle(color: c.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(cardRepositoryProvider).delete(widget.cardId);
    if (!mounted) return;
    // Список карт не пересобираем вручную: он живёт на потоке Isar и
    // обновится сам. Инвалидация прямо перед закрытием экрана роняла бы
    // обновление в середину сборки кадра перехода.
    context.pop();
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppText.label.copyWith(color: context.colors.textSecondary),
      );
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: onTap == null ? 0.4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.surface2,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Icon(icon, size: 18, color: c.text),
        ),
      ),
    );
  }
}

/// Категории кэшбэка этой карты.
///
/// Чипы показывают предложения банка на текущий месяц. Отмеченные —
/// выбранные категории. Когда лимит выбран, остальные чипы гаснут:
/// банк всё равно не даст включить больше.
class _CategoryChips extends ConsumerWidget {
  const _CategoryChips({required this.cardId, required this.slotLimit});

  final String cardId;
  final int slotLimit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final offers = ref.watch(cardOffersProvider(cardId)).value ?? const [];
    final selected =
        ref.watch(cardSelectionsProvider(cardId)).value ?? const <String>{};
    final categories = ref.watch(categoriesProvider).value ?? const [];

    final nameById = {for (final cat in categories) cat.id: cat.name};
    final full = selected.length >= slotLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Категории кэшбэка',
                style: AppText.bodyStrong.copyWith(color: c.text),
              ),
            ),
            Text(
              'Выбрано ${selected.length} из $slotLimit',
              style: AppText.label.copyWith(
                color: full ? c.textSecondary : c.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.x2 - 2),
        Text(
          offers.isEmpty
              ? 'Предложений банка на этот месяц пока нет. Добавьте их '
                  'вручную или загрузите скриншоты.'
              : full
                  ? 'Лимит выбран. Чтобы включить другую категорию, '
                      'снимите одну из выбранных.'
                  : 'Отметьте категории с повышенным кэшбэком. '
                      'Можно выбрать до $slotLimit.',
          style: AppText.label.copyWith(
            color: c.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: Spacing.x3 + 2),
        if (offers.isNotEmpty)
          Wrap(
            spacing: Spacing.x2,
            runSpacing: Spacing.x2,
            children: [
              for (final offer in offers)
                McChip(
                  label: nameById[offer.categoryId] ?? offer.categoryId,
                  percent: offer.rate,
                  state: selected.contains(offer.categoryId)
                      ? ChipState.selected
                      : full
                          ? ChipState.disabled
                          : ChipState.unselected,
                  onTap: () => _toggle(
                    ref,
                    offer.categoryId,
                    selected.contains(offer.categoryId),
                  ),
                ),
            ],
          ),
        const SizedBox(height: Spacing.x3 + 2),
        OutlinedButton.icon(
          onPressed: () async {
            final added = await showAddOfferSheet(context, cardId: cardId);
            if (added) {
              ref.invalidate(cardOffersProvider(cardId));
            }
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Добавить категорию'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, Dimens.minTapTarget),
          ),
        ),
      ],
    );
  }

  /// Снять отметку можно всегда, поставить — только пока есть свободный слот.
  ///
  /// Выбор сохраняется со статусом userChosen: это решение человека,
  /// а не предложение алгоритма, и путать их нельзя.
  Future<void> _toggle(
    WidgetRef ref,
    String categoryId,
    bool isSelected,
  ) async {
    final monthKey = ref.read(currentMonthProvider);
    final repo = ref.read(selectionRepositoryProvider);
    final all = await repo.forMonth(monthKey);

    if (isSelected) {
      final existing = all
          .where((s) => s.cardId == cardId && s.categoryId == categoryId)
          .firstOrNull;
      if (existing != null) await repo.delete(existing.id);
    } else {
      // Та же категория в другом банке — сгоревший слот: в магазине
      // человек платит один раз и одной картой. Забираем её сюда.
      for (final s in all.where((s) => s.categoryId == categoryId)) {
        await repo.delete(s.id);
      }
      await repo.saveAll([
        Selection(
          id: Ids.generate(),
          cardId: cardId,
          monthKey: monthKey,
          categoryId: categoryId,
          status: SelectionStatus.userChosen,
        ),
      ]);
    }

    ref
      ..invalidate(cardSelectionsProvider(cardId))
      ..invalidate(activeCategoriesProvider)
      ..invalidate(selectionCountProvider(monthKey));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/known_banks.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/ids.dart';
import '../../data/providers.dart';
import '../../domain/models/bank.dart';
import '../../domain/models/payment_card.dart';

/// В3 · Первая карта.
///
/// Шаг 1 — выбор банка из списка с поиском. Шаг 2 — название продукта,
/// базовый процент и лимит категорий. Этим же экраном добавляются
/// и последующие карты с экрана «Мои карты».
class FirstCardScreen extends ConsumerStatefulWidget {
  const FirstCardScreen({super.key});

  @override
  ConsumerState<FirstCardScreen> createState() => _FirstCardScreenState();
}

class _FirstCardScreenState extends ConsumerState<FirstCardScreen> {
  final _searchController = TextEditingController();
  final _productController = TextEditingController();
  final _rateController = TextEditingController(text: '1');

  String? _bankName;
  int? _bankColor;
  int _slotLimit = 3;
  bool _saving = false;
  String? _rateError;

  bool get _onDetailsStep => _bankName != null;

  @override
  void dispose() {
    _searchController.dispose();
    _productController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Шаг ${_onDetailsStep ? 2 : 1} из 2',
          style: AppText.caption.copyWith(color: c.textSecondary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_onDetailsStep) {
              setState(() {
                _bankName = null;
                _bankColor = null;
              });
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _onDetailsStep ? _buildDetails(c) : _buildBankPicker(c),
            ),
            // На первом шаге банк выбирается нажатием строки, поэтому
            // кнопки внизу там нет — иначе она была бы мёртвой.
            if (_onDetailsStep)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.x6,
                  Spacing.x3,
                  Spacing.x6,
                  Spacing.x6,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: const Text('Сохранить карту'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankPicker(AppColors c) {
    final query = _searchController.text;
    final results = KnownBanks.search(query);
    final canAddCustom = query.trim().isNotEmpty && results.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.x6,
            0,
            Spacing.x6,
            Spacing.x3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выберите банк',
                style: AppText.screenTitle.copyWith(
                  color: c.text,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: Spacing.x3 + 2),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Поиск по названию',
                  prefixIcon: Icon(Icons.search, size: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: canAddCustom
              ? _CustomBankPrompt(
                  query: query.trim(),
                  onAdd: () =>
                      _pickBank(query.trim(), KnownBanks.fallbackColor),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.screen,
                    0,
                    Spacing.screen,
                    Spacing.x4,
                  ),
                  itemCount: results.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: c.border),
                  itemBuilder: (context, i) {
                    final bank = results[i];
                    return InkWell(
                      onTap: () => _pickBank(bank.name, bank.colorValue),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 56),
                        padding:
                            const EdgeInsets.symmetric(vertical: Spacing.x2),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(bank.colorValue),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.x3),
                            Expanded(
                              child: Text(
                                bank.name,
                                style: AppText.body.copyWith(
                                  color: c.text,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: c.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDetails(AppColors c) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.x6,
        Spacing.x1,
        Spacing.x6,
        Spacing.x4,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.x3 + 2,
            vertical: Spacing.x3,
          ),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: Radii.cardBorder,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(_bankColor ?? KnownBanks.fallbackColor),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
              ),
              const SizedBox(width: Spacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _bankName!,
                      style: AppText.bodyStrong.copyWith(color: c.text),
                    ),
                    Text(
                      'Выбранный банк',
                      style: AppText.label.copyWith(
                        color: c.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _bankName = null;
                  _bankColor = null;
                }),
                child: Text(
                  'Изменить',
                  style: AppText.caption.copyWith(
                    color: c.textSecondary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.x6),
        const _FieldLabel('Название продукта'),
        const SizedBox(height: Spacing.x2 - 2),
        TextField(
          controller: _productController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Например, Black'),
        ),
        const SizedBox(height: Spacing.x2 - 2),
        Text(
          'Как карта называется в приложении банка.',
          style: AppText.label.copyWith(color: c.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: Spacing.x6),
        const _FieldLabel('Базовый процент кэшбэка'),
        const SizedBox(height: Spacing.x2 - 2),
        TextField(
          controller: _rateController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          onChanged: (_) {
            if (_rateError != null) setState(() => _rateError = null);
          },
          decoration: InputDecoration(suffixText: '%', errorText: _rateError),
        ),
        const SizedBox(height: Spacing.x2 - 2),
        Text(
          'Сколько возвращается на любые покупки без выбранной категории.',
          style: AppText.label.copyWith(color: c.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: Spacing.x6),
        const _FieldLabel('Лимит категорий'),
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
              _StepButton(
                icon: Icons.remove,
                onTap:
                    _slotLimit > 1 ? () => setState(() => _slotLimit--) : null,
              ),
              const SizedBox(width: 2),
              _StepButton(
                icon: Icons.add,
                onTap:
                    _slotLimit < 10 ? () => setState(() => _slotLimit++) : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.x2 - 2),
        Text(
          'Сколько категорий повышенного кэшбэка банк даёт выбрать за месяц.',
          style: AppText.label.copyWith(color: c.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  void _pickBank(String name, int color) {
    setState(() {
      _bankName = name;
      _bankColor = color;
    });
  }

  Future<void> _save() async {
    final rate = _parseRate(_rateController.text);
    if (rate == null) {
      setState(() => _rateError = 'Введите процент от 0 до 100.');
      return;
    }

    setState(() => _saving = true);

    final bankName = _bankName!;
    final banks = ref.read(bankRepositoryProvider);

    // Банк заводится один раз: если карта того же банка уже есть,
    // переиспользуем его, иначе в списке появятся два одинаковых.
    final existing = await banks.all();
    Bank? match;
    for (final b in existing) {
      if (b.name == bankName) {
        match = b;
        break;
      }
    }

    final bankId = match?.id ?? Ids.generate();
    if (match == null) {
      await banks.save(
        Bank(
          id: bankId,
          name: bankName,
          colorValue: _bankColor ?? KnownBanks.fallbackColor,
        ),
      );
    }

    final product = _productController.text.trim();
    await ref.read(cardRepositoryProvider).save(
          PaymentCard(
            id: Ids.generate(),
            bankId: bankId,
            productName: product.isEmpty ? 'Основная' : product,
            baseRate: rate,
            slotLimit: _slotLimit,
          ),
        );

    if (!mounted) return;
    ref.invalidate(cardsProvider);
    context.pop();
  }

  static double? _parseRate(String raw) {
    final value = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (value == null || value < 0 || value > 100) return null;
    return value;
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.label.copyWith(
        color: context.colors.textSecondary,
        fontSize: 13,
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

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

class _CustomBankPrompt extends StatelessWidget {
  const _CustomBankPrompt({required this.query, required this.onAdd});

  final String query;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Банк не найден',
              style: AppText.bodyStrong.copyWith(color: c.text),
            ),
            const SizedBox(height: Spacing.x2),
            Text(
              'Такого банка нет в списке. Добавьте его вручную — '
              'укажите название сами.',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: Spacing.x3 + 2),
            OutlinedButton(
              onPressed: onAdd,
              child: Text('Добавить «$query»'),
            ),
          ],
        ),
      ),
    );
  }
}

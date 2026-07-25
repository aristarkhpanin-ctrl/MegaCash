import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers.dart';
import 'setup_controller.dart';

/// Б7 · Активация в банках.
///
/// Приложение с банками не интегрируется: включить категории человек
/// должен сам. Поэтому здесь список по банкам — что именно открыть
/// и что отметить. Без него настройка выглядит законченной, а кэшбэк
/// не начисляется, и виноватым окажется приложение.
class ActivationScreen extends ConsumerStatefulWidget {
  const ActivationScreen({super.key});

  @override
  ConsumerState<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends ConsumerState<ActivationScreen> {
  final _done = <String>{};
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final result = state.result;
    final categories = ref.watch(categoriesProvider);
    final nameById = {for (final cat in categories) cat.id: cat.name};
    final banks = ref.watch(cardsProvider).value ?? const [];
    final bankName = {for (final b in banks) b.card.id: b.bankName};

    final byCard = <String, List<String>>{};
    for (final a in result?.selected ?? const []) {
      (byCard[a.cardId] ??= []).add(
        '${nameById[a.categoryId] ?? a.categoryId} · ${Percent.format(a.rate)}',
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Активация')),
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
                    'Осталось включить категории в приложениях банков — '
                    'сделать это за вас МегаКэш не может. Откройте каждый '
                    'банк и отметьте то, что ниже.',
                    style: AppText.caption.copyWith(
                      color: c.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: Spacing.x4),
                  for (final entry in byCard.entries) ...[
                    _BankBlock(
                      bank: bankName[entry.key] ?? entry.key,
                      lines: entry.value,
                      done: _done.contains(entry.key),
                      onToggle: () => setState(() {
                        if (!_done.add(entry.key)) _done.remove(entry.key);
                      }),
                    ),
                    const SizedBox(height: Spacing.x3),
                  ],
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
                  onPressed: _saving ? null : _finish,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  // Отметки у банков — памятка для человека, а не условие:
                  // приложение всё равно не может проверить, включил он
                  // категории на самом деле или нет.
                  child: const Text('Всё включил'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final controller = ref.read(setupControllerProvider.notifier);
    await controller.commit();
    await controller.markActivated();
    if (!mounted) return;
    context.pushReplacement(Routes.setupDone);
  }
}

class _BankBlock extends StatelessWidget {
  const _BankBlock({
    required this.bank,
    required this.lines,
    required this.done,
    required this.onToggle,
  });

  final String bank;
  final List<String> lines;
  final bool done;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.x3 + 2),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: done ? c.success : c.border),
        borderRadius: Radii.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bank,
                  style: AppText.bodyStrong.copyWith(color: c.text),
                ),
              ),
              IconButton(
                tooltip: done ? 'Отменить отметку' : 'Отметить включённым',
                onPressed: onToggle,
                icon: Icon(
                  done ? Icons.check_circle : Icons.circle_outlined,
                  color: done ? c.success : c.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x1),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '• $line',
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bank_card.dart';
import '../../domain/answer/payment_answer.dart';
import 'home_providers.dart';

/// А2 · Какой картой платить.
///
/// Ответ на один вопрос, поэтому экран занят одной карточкой. Остальные
/// карты — узкими строками ниже: они нужны редко, для проверки.
class AnswerScreen extends ConsumerWidget {
  const AnswerScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final answer = ref.watch(paymentAnswerProvider(categoryId));

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: answer.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.x8),
              child: Text(
                'Не удалось собрать ответ.\n$e',
                textAlign: TextAlign.center,
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
            ),
          ),
          data: (data) => _Body(answer: data),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.answer});

  final PaymentAnswer answer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final best = answer.best;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screen,
        Spacing.x1 + 2,
        Spacing.screen,
        Spacing.x8,
      ),
      children: [
        Text(
          'ЧЕМ ПЛАТИТЬ',
          style: AppText.label.copyWith(
            color: c.textSecondary,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.48,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          answer.categoryName,
          style: AppText.screenTitle.copyWith(color: c.text, height: 1.12),
        ),
        const SizedBox(height: Spacing.x4 + 2),

        if (best == null)
          _NoCards(color: c.textSecondary)
        else ...[
          // Повышенного процента нет ни у одной карты — честно говорим
          // об этом и показываем лучший базовый. Промолчать нельзя:
          // человек решит, что 1% — это и есть предложенная выгода.
          if (answer.noElevated) ...[
            _Hint(
              text: 'Ни одна карта не даёт повышенный кэшбэк в этой '
                  'категории. Ниже — карта с лучшим базовым процентом.',
            ),
            const SizedBox(height: Spacing.x3 + 2),
            _SectionLabel('ЛУЧШИЙ БАЗОВЫЙ ПРОЦЕНТ'),
            const SizedBox(height: Spacing.x2 - 2),
            BankCard(
              bankName: best.bankName,
              productName: best.productName,
              percent: best.rate,
              bankColor: best.bankColor,
            ),
          ] else
            BankCard(
              bankName: best.bankName,
              productName: best.productName,
              percent: best.rate,
              bankColor: best.bankColor,
              variant: BankCardVariant.winner,
            ),

          if (answer.others.isNotEmpty) ...[
            const SizedBox(height: Spacing.x6 - 2),
            _SectionLabel(
              answer.others.length > 4
                  ? 'ОСТАЛЬНЫЕ КАРТЫ · ${answer.others.length}'
                  : 'ОСТАЛЬНЫЕ КАРТЫ',
            ),
            const SizedBox(height: Spacing.x2 + 2),
            for (final option in answer.others) ...[
              BankCard(
                bankName: option.bankName,
                productName: option.productName,
                percent: option.rate,
                bankColor: option.bankColor,
                variant: BankCardVariant.loser,
              ),
              const SizedBox(height: Spacing.x2),
            ],
          ],
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppText.label.copyWith(
          color: context.colors.textSecondary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.48,
        ),
      );
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x4,
        vertical: Spacing.x3 + 2,
      ),
      decoration: BoxDecoration(
        color: c.brandSubtle,
        borderRadius: Radii.cardBorder,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: c.text),
          const SizedBox(width: Spacing.x2 + 2),
          Expanded(
            child: Text(
              text,
              style: AppText.caption.copyWith(color: c.text, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoCards extends StatelessWidget {
  const _NoCards({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.x8),
        child: Text(
          'Карт пока нет — добавьте хотя бы одну, чтобы получить ответ.',
          textAlign: TextAlign.center,
          style: AppText.caption.copyWith(color: color, height: 1.45),
        ),
      );
}

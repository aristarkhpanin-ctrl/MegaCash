import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'setup_controller.dart';

/// Б3 · Распознавание.
///
/// Показывает ход работы: распознавание идёт секунды, и молчащий экран
/// человек примет за зависший. Отменить нельзя — прервать разбор на
/// середине значит получить половину предложений, что хуже, чем ничего.
class RecognizingScreen extends ConsumerStatefulWidget {
  const RecognizingScreen({super.key});

  @override
  ConsumerState<RecognizingScreen> createState() => _RecognizingScreenState();
}

class _RecognizingScreenState extends ConsumerState<RecognizingScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    await ref.read(setupControllerProvider.notifier).recognize();
    if (!mounted) return;
    context.pushReplacement(Routes.setupReview);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(setupControllerProvider);
    final total = state.imagesByCard.length;
    final done = state.recognizedCards;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.x8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    color: c.brand,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: Spacing.x6),
                Text(
                  'Распознаём категории',
                  style: AppText.blockTitle.copyWith(color: c.text),
                ),
                const SizedBox(height: Spacing.x2),
                Text(
                  total == 0
                      ? 'Готовим данные'
                      : 'Карта $done из $total. Всё происходит на телефоне, '
                          'скриншоты никуда не отправляются.',
                  textAlign: TextAlign.center,
                  style: AppText.caption.copyWith(
                    color: c.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

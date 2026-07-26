import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../data/providers.dart';

/// Г1 · Настройки.
///
/// Тема оформления, обновление справочника категорий, сброс всех данных
/// и «О приложении».
///
/// Резервное копирование и баннер появятся на шаге 8.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final mode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.screen,
            Spacing.x1,
            Spacing.screen,
            Spacing.x6,
          ),
          children: [
            const _SectionLabel('Оформление'),
            const SizedBox(height: Spacing.x2 + 2),
            Container(
              padding: const EdgeInsets.all(Spacing.x1),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border.all(color: c.border),
                borderRadius: Radii.cardBorder,
              ),
              child: Row(
                children: [
                  _ThemeOption(
                    icon: Icons.light_mode_outlined,
                    label: 'Светлая',
                    selected: mode == ThemeMode.light,
                    onTap: () => unawaited(notifier.set(ThemeMode.light)),
                  ),
                  const SizedBox(width: Spacing.x1 + 2),
                  _ThemeOption(
                    icon: Icons.dark_mode_outlined,
                    label: 'Тёмная',
                    selected: mode == ThemeMode.dark,
                    onTap: () => unawaited(notifier.set(ThemeMode.dark)),
                  ),
                  const SizedBox(width: Spacing.x1 + 2),
                  _ThemeOption(
                    icon: Icons.phone_android_outlined,
                    label: 'Системная',
                    selected: mode == ThemeMode.system,
                    onTap: () => unawaited(notifier.set(ThemeMode.system)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Spacing.x6),
            const _SectionLabel('Данные'),
            const SizedBox(height: Spacing.x2 + 2),
            const _RowGroup(
              children: [
                _SettingsRow(
                  icon: Icons.file_download_outlined,
                  title: 'Сохранить копию',
                  subtitle: 'Файл с картами и настройками',
                  enabled: false,
                ),
                _SettingsRow(
                  icon: Icons.file_upload_outlined,
                  title: 'Восстановить из копии',
                  subtitle: 'Заменит текущие данные',
                  enabled: false,
                ),
              ],
            ),

            const SizedBox(height: Spacing.x6),
            const _SectionLabel('Справочник категорий'),
            const SizedBox(height: Spacing.x2 + 2),
            _RowGroup(
              children: [
                _SettingsRow(
                  icon: Icons.sync,
                  title: 'Обновить справочник',
                  subtitle: 'Добавит новые формулировки банков',
                  onTap: () => _refreshDictionary(context, ref),
                ),
              ],
            ),
            const SizedBox(height: Spacing.x2 + 2),
            Text(
              'Единственное обращение к сети во всём приложении. Без него '
              'МегаКэш работает так же, только не узнаёт новые названия '
              'категорий.',
              style: AppText.label.copyWith(
                color: c.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: Spacing.x6),
            const _SectionLabel('Ещё'),
            const SizedBox(height: Spacing.x2 + 2),
            _RowGroup(
              children: [
                _SettingsRow(
                  icon: Icons.info_outline,
                  title: 'О приложении',
                  onTap: () => context.push(Routes.about),
                ),
                _SettingsRow(
                  icon: Icons.delete_outline,
                  title: 'Сбросить все данные',
                  danger: true,
                  onTap: () => _confirmReset(context, ref),
                ),
              ],
            ),
            const SizedBox(height: Spacing.x2 + 2),
            Text(
              'Сброс удалит все карты, предложения и выбранные категории. '
              'Отменить это нельзя.',
              style: AppText.label.copyWith(
                color: c.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshDictionary(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(categoryDictionaryProvider).refresh();
    messenger.showSnackBar(
      const SnackBar(content: Text('Справочник обновлён')),
    );
  }

  /// Стирание данных подтверждается отдельно: это единственное действие
  /// в приложении, которое нельзя отменить.
  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Сбросить все данные?'),
        content: const Text(
          'Удалятся все карты, предложения банков и выбранные категории. '
          'Восстановить их будет нельзя.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(settingsRepositoryProvider).clearEverything();
    ref.invalidate(cardsProvider);
    if (!context.mounted) return;
    context.go(Routes.home);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text.toUpperCase(),
        style: AppText.sectionLabel.copyWith(
          color: context.colors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Выбранный вариант — жёлтая заливка с тёмным текстом поверх.
    final fg = selected ? c.onBrand : c.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.x3 - 2,
            horizontal: Spacing.x1,
          ),
          decoration: BoxDecoration(
            color: selected ? c.brand : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(9)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(height: Spacing.x1 + 2),
              Text(
                label,
                style: AppText.label.copyWith(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowGroup extends StatelessWidget {
  const _RowGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
        rows.add(Divider(height: 1, color: c.border));
      }
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: Radii.cardBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.danger = false,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = danger ? c.error : c.text;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          color: c.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.x4 - 2,
            vertical: Spacing.x2 + 2,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(width: Spacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppText.body.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppText.label.copyWith(
                          color: c.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              if (!danger)
                Icon(Icons.chevron_right, size: 18, color: c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

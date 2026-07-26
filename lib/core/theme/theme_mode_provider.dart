import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/repositories/repositories.dart';

/// Выбранная пользователем тема оформления: светлая, тёмная, системная.
///
/// Переживает перезапуск: тема — это не мимолётное состояние экрана,
/// а решение человека о том, как приложение должно выглядеть.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    unawaited(_load());
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final saved =
        await ref.read(settingsRepositoryProvider).get(SettingKeys.themeMode);
    final mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
    if (mode != null) state = mode;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(settingsRepositoryProvider).set(
          SettingKeys.themeMode,
          switch (mode) {
            ThemeMode.light => 'light',
            ThemeMode.dark => 'dark',
            ThemeMode.system => 'system',
          },
        );
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

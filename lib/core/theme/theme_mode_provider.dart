import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Выбранная пользователем тема оформления: светлая, тёмная, системная.
///
/// Шаг 1: значение живёт только в памяти. На шаге 2, когда появится
/// хранилище, оно начнёт переживать перезапуск.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

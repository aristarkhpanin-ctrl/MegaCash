import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Слой `domain` не импортирует Flutter, Isar и любые платформенные пакеты.
///
/// Это не стилистика, а условие тестируемости: оптимизатор должен покрываться
/// обычными юнит-тестами без запуска приложения. Нарушение легко внести
/// автодополнением и не заметить, поэтому проверяется тестом.
void main() {
  const forbidden = <String>[
    'package:flutter/',
    'package:flutter_test/',
    'package:isar',
    'package:flutter_riverpod/',
    'package:go_router/',
    'package:path_provider/',
    'dart:ui',
    'dart:io',
  ];

  test('domain остаётся чистым Dart', () {
    final dir = Directory('lib/domain');
    expect(dir.existsSync(), isTrue, reason: 'папка lib/domain должна быть');

    final violations = <String>[];

    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('import ') && !line.startsWith('export ')) {
          continue;
        }
        for (final bad in forbidden) {
          if (line.contains(bad)) {
            violations.add('${entity.path}:${i + 1} → $line');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Запрещённые импорты в domain:\n${violations.join('\n')}',
    );
  });
}

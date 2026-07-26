import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/repositories/repositories.dart';

/// Пройден ли онбординг.
///
/// Загружается при старте приложения вместе с базой и справочником:
/// решать, какой экран показать первым, нужно до первого кадра, иначе
/// человек увидит главный экран и его подменят онбордингом.
final onboardingDoneProvider = Provider<bool>((ref) {
  throw UnimplementedError(
    'onboardingDoneProvider должен быть переопределён в ProviderScope',
  );
});

/// Отмечает онбординг пройденным.
Future<void> markOnboardingDone(WidgetRef ref) => ref
    .read(settingsRepositoryProvider)
    .setBool(SettingKeys.onboardingDone, value: true);

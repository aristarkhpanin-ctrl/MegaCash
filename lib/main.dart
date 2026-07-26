import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/local/isar_database.dart';
import 'data/providers.dart';
import 'data/local/isar_repositories.dart';
import 'data/remote/category_dictionary_impl.dart';
import 'domain/repositories/repositories.dart';
import 'features/onboarding/onboarding_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Приложение вертикальное: ответ у кассы читается с телефона в одной руке.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final isar = await IsarDatabase.open();
  final categories = await BundledCategoryDictionary().all();
  final settings = IsarSettingsRepository(isar);
  final onboardingDone =
      await settings.getBool(SettingKeys.onboardingDone);

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        categoriesProvider.overrideWithValue(categories),
        onboardingDoneProvider.overrideWithValue(onboardingDone),
      ],
      child: const MegaCashApp(),
    ),
  );
}

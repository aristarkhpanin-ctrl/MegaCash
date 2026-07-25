import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/local/isar_database.dart';
import 'data/providers.dart';
import 'data/remote/category_dictionary_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Приложение вертикальное: ответ у кассы читается с телефона в одной руке.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final isar = await IsarDatabase.open();
  final categories = await BundledCategoryDictionary().all();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        categoriesProvider.overrideWithValue(categories),
      ],
      child: const MegaCashApp(),
    ),
  );
}

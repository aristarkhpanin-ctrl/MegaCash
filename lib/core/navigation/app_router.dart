import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cards/card_edit_screen.dart';
import '../../features/cards/cards_screen.dart';
import '../../features/home/answer_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/first_card_screen.dart';
import '../../features/onboarding/gallery_permission_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/settings/about_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/setup/activation_screen.dart';
import '../../features/setup/manual_category_screen.dart';
import '../../features/setup/recognizing_screen.dart';
import '../../features/setup/recommendation_screen.dart';
import '../../features/setup/review_screen.dart';
import '../../features/setup/screenshots_screen.dart';
import '../../features/setup/setup_done_screen.dart';
import '../../features/setup/setup_start_screen.dart';
import '../../features/shell/main_shell.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _cardsKey = GlobalKey<NavigatorState>(debugLabel: 'cards');

/// Маршрутизация приложения.
///
/// Два раздела с нижней навигацией — «Кэшбэк» и «Карты» — живут в
/// [StatefulShellRoute] и сохраняют свой стек по отдельности. Всё остальное
/// открывается поверх, на корневом навигаторе: ответ, месячная настройка,
/// онбординг и настройки нижней навигации не показывают.
GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeKey,
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _cardsKey,
            routes: [
              GoRoute(
                path: Routes.cards,
                builder: (context, state) => const CardsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Группа А — поверх навигации.
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.answer,
        builder: (context, state) => const AnswerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.cardEdit,
        builder: (context, state) => CardEditScreen(
          cardId: state.uri.queryParameters['id'] ?? '',
        ),
      ),

      // Группа Б — месячная настройка.
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setup,
        builder: (context, state) => const SetupStartScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupScreenshots,
        builder: (context, state) => const ScreenshotsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupRecognizing,
        builder: (context, state) => const RecognizingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupReview,
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupManual,
        builder: (context, state) => const ManualCategoryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupRecommendation,
        builder: (context, state) => const RecommendationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupActivation,
        builder: (context, state) => const ActivationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.setupDone,
        builder: (context, state) => const SetupDoneScreen(),
      ),

      // Группа В — онбординг.
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.onboarding,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.onboardingPermission,
        builder: (context, state) => const GalleryPermissionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.onboardingFirstCard,
        builder: (context, state) => const FirstCardScreen(),
      ),

      // Группа Г — служебное.
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.about,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}

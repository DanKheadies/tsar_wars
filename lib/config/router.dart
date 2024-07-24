import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsar_wars/models/models.dart';
import 'package:tsar_wars/screens/screens.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'mainMenu',
      builder: (context, state) => const MainMenuScreen(
        key: Key('main menu'),
      ),
      routes: [
        GoRoute(
          path: 'play',
          // pageBuilder: (context, state) => buildPageTransition<void>(
          //   key: const ValueKey('play'),
          //   color: context.watch<Palette>().backgroundLevelSelection.color,
          //   child: const LevelSelectionScreen(
          //     key: Key('level selection'),
          //   ),
          // ),
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LevelSelectionScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          routes: [
            GoRoute(
              path: 'session/:level',
              // pageBuilder: (context, state) {
              //   final levelNumber = int.parse(state.pathParameters['level']!);
              //   final level = gameLevels[levelNumber - 1];
              //   return buildPageTransition<void>(
              //     key: const ValueKey('level'),
              //     color: context.watch<Palette>().backgroundPlaySession.color,
              //     child: GameScreen(level: level),
              //   );
              // },
              pageBuilder: (context, state) {
                final levelNumber = int.parse(state.pathParameters['level']!);
                final level = gameLevels[levelNumber - 1];
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: GameScreen(
                    level: level,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(
            key: Key('settings'),
          ),
        ),
      ],
    ),
  ],
);

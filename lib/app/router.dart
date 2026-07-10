import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/editor/editor_screen.dart';
import '../screens/export/export_screen.dart';
import '../screens/export/export_complete_screen.dart';
import '../screens/templates/templates_screen.dart';
import '../screens/settings/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/editor/:id',
      builder: (context, state) {
        final projectId = state.pathParameters['id']!;
        return EditorScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/export/:id',
      builder: (context, state) {
        final projectId = state.pathParameters['id']!;
        return ExportScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/export-complete',
      builder: (context, state) {
        final outputPath = state.extra as String? ?? '';
        return ExportCompleteScreen(outputPath: outputPath);
      },
    ),
    GoRoute(
      path: '/templates',
      builder: (context, state) => const TemplatesScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

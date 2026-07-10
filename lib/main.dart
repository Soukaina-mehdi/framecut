import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'models/project.dart';
import 'models/clip.dart';
import 'models/effect.dart';
import 'models/text_overlay.dart';
import 'models/audio_track.dart';
import 'models/export_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for mobile video editor
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style — light (minimalism)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive for local project storage
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(VideoClipAdapter());
  Hive.registerAdapter(EffectAdapter());
  Hive.registerAdapter(TextOverlayAdapter());
  Hive.registerAdapter(AudioTrackAdapter());
  Hive.registerAdapter(ExportSettingsAdapter());

  await Hive.openBox<Project>('projects');
  await Hive.openBox('settings');

  runApp(
    const ProviderScope(
      child: FrameCutApp(),
    ),
  );
}

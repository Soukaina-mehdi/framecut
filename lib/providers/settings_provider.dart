import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class AppSettings {
  final bool darkMode;
  final bool hapticsEnabled;
  final bool autoSave;
  final int autoSaveIntervalSec;
  final bool showWaveforms;
  final bool snapToGrid;
  final double defaultVolume;

  const AppSettings({
    this.darkMode = false,
    this.hapticsEnabled = true,
    this.autoSave = true,
    this.autoSaveIntervalSec = 30,
    this.showWaveforms = true,
    this.snapToGrid = true,
    this.defaultVolume = 1.0,
  });

  AppSettings copyWith({
    bool? darkMode,
    bool? hapticsEnabled,
    bool? autoSave,
    int? autoSaveIntervalSec,
    bool? showWaveforms,
    bool? snapToGrid,
    double? defaultVolume,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      autoSave: autoSave ?? this.autoSave,
      autoSaveIntervalSec: autoSaveIntervalSec ?? this.autoSaveIntervalSec,
      showWaveforms: showWaveforms ?? this.showWaveforms,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      defaultVolume: defaultVolume ?? this.defaultVolume,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  void _load() {
    final box = Hive.box('settings');
    state = AppSettings(
      darkMode: box.get('darkMode', defaultValue: false) as bool,
      hapticsEnabled: box.get('hapticsEnabled', defaultValue: true) as bool,
      autoSave: box.get('autoSave', defaultValue: true) as bool,
      autoSaveIntervalSec: box.get('autoSaveIntervalSec', defaultValue: 30) as int,
      showWaveforms: box.get('showWaveforms', defaultValue: true) as bool,
      snapToGrid: box.get('snapToGrid', defaultValue: true) as bool,
      defaultVolume: box.get('defaultVolume', defaultValue: 1.0) as double,
    );
  }

  Future<void> setDarkMode(bool value) async {
    state = state.copyWith(darkMode: value);
    await Hive.box('settings').put('darkMode', value);
  }

  Future<void> setHaptics(bool value) async {
    state = state.copyWith(hapticsEnabled: value);
    await Hive.box('settings').put('hapticsEnabled', value);
  }

  Future<void> setAutoSave(bool value) async {
    state = state.copyWith(autoSave: value);
    await Hive.box('settings').put('autoSave', value);
  }

  Future<void> setShowWaveforms(bool value) async {
    state = state.copyWith(showWaveforms: value);
    await Hive.box('settings').put('showWaveforms', value);
  }

  Future<void> setSnapToGrid(bool value) async {
    state = state.copyWith(snapToGrid: value);
    await Hive.box('settings').put('snapToGrid', value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

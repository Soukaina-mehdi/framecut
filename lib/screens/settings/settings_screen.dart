import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(
          color: Color(0xFF111111), fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'DM Sans',
        )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: ListView(padding: const EdgeInsets.symmetric(vertical: 12), children: [

        // ── APPEARANCE ──────────────────────────────────────────
        _SectionHeader(title: 'APPEARANCE'),
        _Card(children: [
          SwitchListTile(
            title: const Text('Dark Mode', style: _tileStyle),
            secondary: const Icon(Icons.dark_mode_outlined, size: 20, color: Color(0xFF555555)),
            value: settings.darkMode,
            activeColor: AppTheme.primary,
            onChanged: (v) => notifier.setDarkMode(v),
          ),
          _Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, size: 20, color: Color(0xFF555555)),
            title: const Text('App Info', style: _tileStyle),
            subtitle: const Text('FrameCut v1.0.0', style: _subtitleStyle),
            trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFFBBBBBB)),
            onTap: () {},
          ),
        ]),

        // ── EDITOR ───────────────────────────────────────────────
        _SectionHeader(title: 'EDITOR'),
        _Card(children: [
          SwitchListTile(
            title: const Text('Haptic Feedback', style: _tileStyle),
            secondary: const Icon(Icons.vibration_outlined, size: 20, color: Color(0xFF555555)),
            value: settings.haptics,
            activeColor: AppTheme.primary,
            onChanged: (v) => notifier.setHaptics(v),
          ),
          _Divider(),
          SwitchListTile(
            title: const Text('Auto-Save', style: _tileStyle),
            subtitle: const Text('Every 30 seconds', style: _subtitleStyle),
            secondary: const Icon(Icons.save_outlined, size: 20, color: Color(0xFF555555)),
            value: settings.autoSave,
            activeColor: AppTheme.primary,
            onChanged: (v) => notifier.setAutoSave(v),
          ),
          _Divider(),
          SwitchListTile(
            title: const Text('Show Waveforms', style: _tileStyle),
            secondary: const Icon(Icons.graphic_eq_outlined, size: 20, color: Color(0xFF555555)),
            value: settings.showWaveforms,
            activeColor: AppTheme.primary,
            onChanged: (v) => notifier.setShowWaveforms(v),
          ),
          _Divider(),
          SwitchListTile(
            title: const Text('Snap to Grid', style: _tileStyle),
            secondary: const Icon(Icons.grid_4x4_outlined, size: 20, color: Color(0xFF555555)),
            value: settings.snapToGrid,
            activeColor: AppTheme.primary,
            onChanged: (v) => notifier.setSnapToGrid(v),
          ),
        ]),

        // ── STORAGE ──────────────────────────────────────────────
        _SectionHeader(title: 'STORAGE'),
        _Card(children: [
          ListTile(
            leading: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFE74C3C)),
            title: const Text('Clear Temp Files', style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500,
              color: Color(0xFFE74C3C), fontFamily: 'DM Sans',
            )),
            subtitle: const Text('Cache size: 12.4 MB', style: _subtitleStyle),
            trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFFBBBBBB)),
            onTap: () {},
          ),
        ]),

        // ── ABOUT ─────────────────────────────────────────────────
        _SectionHeader(title: 'ABOUT'),
        _Card(children: [
          ListTile(
            leading: const Icon(Icons.video_library_outlined, size: 20, color: Color(0xFF555555)),
            title: const Text('FrameCut v1.0.0', style: _tileStyle),
            subtitle: const Text('Built with Flutter + pro_video_editor', style: _subtitleStyle),
          ),
          _Divider(),
          ListTile(
            leading: const Icon(Icons.star_outline_rounded, size: 20, color: Color(0xFF555555)),
            title: const Text('Features', style: _tileStyle),
            subtitle: const Text('60+ editing features', style: _subtitleStyle),
          ),
        ]),

        const SizedBox(height: 32),
      ]),
    );
  }
}

// ── Shared style constants ─────────────────────────────────────────────────
const _tileStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF111111), fontFamily: 'DM Sans');
const _subtitleStyle = TextStyle(fontSize: 12, color: Color(0xFF888888), fontFamily: 'DM Sans');

// ── Helper widgets ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(title, style: const TextStyle(
        fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0,
        color: Color(0xFF888888), fontFamily: 'DM Sans',
      )),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, margin: const EdgeInsets.only(left: 56), color: AppTheme.border);
}

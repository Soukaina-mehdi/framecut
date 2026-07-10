import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../models/export_settings.dart';
import '../../services/video_render_service.dart';

class ExportScreen extends ConsumerStatefulWidget {
  final String projectId;
  const ExportScreen({super.key, required this.projectId});
  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  String _preset = 'Custom';
  ExportResolution _res = ExportResolution.hd1080p;
  ExportFormat _fmt = ExportFormat.mp4;
  ExportFrameRate _fps = ExportFrameRate.fps30;
  double _bitrate = 8000;
  bool _subs = false, _stream = true;

  static const _presets = ['Custom','Instagram Reel','TikTok','YouTube Short','Twitter','4K Cinema'];
  static const _resolutions = [ExportResolution.p480,ExportResolution.p720,ExportResolution.hd1080p,ExportResolution.hd1080pHQ,ExportResolution.uhd4k];
  static const _resLabels = ['480p','720p','1080p','1080p HQ','4K'];
  static const _fpsVals = [ExportFrameRate.fps24,ExportFrameRate.fps25,ExportFrameRate.fps30,ExportFrameRate.fps60,ExportFrameRate.fps120];
  static const _fpsLabels = ['24fps','25fps','30fps','60fps','120fps'];

  void _applyPreset(String name) => setState(() {
    _preset = name;
    if (name == 'Instagram Reel') { _res = ExportResolution.hd1080p; _fps = ExportFrameRate.fps30; _fmt = ExportFormat.mp4; _bitrate = 6000; }
    else if (name == 'TikTok') { _res = ExportResolution.hd1080p; _fps = ExportFrameRate.fps30; _fmt = ExportFormat.mp4; _bitrate = 5000; }
    else if (name == 'YouTube Short') { _res = ExportResolution.hd1080p; _fps = ExportFrameRate.fps60; _fmt = ExportFormat.mp4; _bitrate = 10000; }
    else if (name == 'Twitter') { _res = ExportResolution.p720; _fps = ExportFrameRate.fps30; _fmt = ExportFormat.mp4; _bitrate = 4000; }
    else if (name == '4K Cinema') { _res = ExportResolution.uhd4k; _fps = ExportFrameRate.fps24; _fmt = ExportFormat.mov; _bitrate = 40000; }
  });

  String _bitrateLabel(double k) => k >= 1000 ? '${(k/1000).toStringAsFixed(0)} Mbps' : '${k.toStringAsFixed(0)} kbps';

  Future<void> _startExport() async {
    final settings = ExportSettings(preset: ExportPreset.custom, presetName: _preset,
        resolution: _res, format: _fmt, frameRate: _fps, bitrate: _bitrate.toInt(),
        burnSubtitles: _subs, optimizeForStreaming: _stream);
    showModalBottomSheet(
      context: context, isDismissible: false, backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _ExportProgressSheet(projectId: widget.projectId, settings: settings,
        onComplete: (path) { Navigator.of(context).pop(); context.push('/export-complete', extra: path); }),
    );
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 10),
    child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
        color: Color(0xFF666666), letterSpacing: 0.8, fontFamily: 'DM Sans')));

  Widget _chips<T>(List<T> vals, List<String> labs, T sel, void Function(T) onTap) =>
    Wrap(spacing: 8, runSpacing: 8, children: List.generate(vals.length, (i) {
      final on = vals[i] == sel;
      return GestureDetector(onTap: () => onTap(vals[i]), child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: on ? AppTheme.primary : AppTheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: on ? AppTheme.primary : AppTheme.border)),
        child: Text(labs[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
            color: on ? Colors.white : const Color(0xFF111111), fontFamily: 'DM Sans')),
      ));
    }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF111111)), onPressed: () => context.pop()),
        title: const Text('Export Video', style: TextStyle(color: Color(0xFF111111), fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'DM Sans')),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppTheme.border)),
      ),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(20), children: [
          _label('PRESET'), _chips<String>(_presets, _presets, _preset, _applyPreset), const SizedBox(height: 24),
          _label('RESOLUTION'), _chips<ExportResolution>(_resolutions, _resLabels, _res, (v) => setState(() => _res = v)), const SizedBox(height: 24),
          _label('FORMAT'),
          _FormatSegmented(selected: _fmt, onChanged: (v) => setState(() => _fmt = v)),
          const SizedBox(height: 24),
          _label('FRAME RATE'), _chips<ExportFrameRate>(_fpsVals, _fpsLabels, _fps, (v) => setState(() => _fps = v)), const SizedBox(height: 24),
          _label('QUALITY'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Bitrate', style: TextStyle(fontSize: 14, fontFamily: 'DM Sans')),
            Text(_bitrateLabel(_bitrate), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'DM Sans')),
          ]),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: AppTheme.primary,
                inactiveTrackColor: AppTheme.border, thumbColor: AppTheme.primary,
                overlayColor: AppTheme.primary.withOpacity(0.1)),
            child: Slider(min: 1000, max: 50000, divisions: 49, value: _bitrate,
                onChanged: (v) => setState(() { _bitrate = v; _preset = 'Custom'; })),
          ),
          const SizedBox(height: 24),
          _label('OPTIONS'),
          Container(
            decoration: BoxDecoration(border: Border.all(color: AppTheme.border), borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              SwitchListTile(title: const Text('Burn Subtitles', style: TextStyle(fontSize: 14, fontFamily: 'DM Sans')),
                  value: _subs, activeColor: AppTheme.primary, onChanged: (v) => setState(() => _subs = v)),
              Divider(height: 1, color: AppTheme.border),
              SwitchListTile(
                  title: const Text('Optimize for Streaming', style: TextStyle(fontSize: 14, fontFamily: 'DM Sans')),
                  subtitle: const Text('Moves metadata to start of file', style: TextStyle(fontSize: 12, fontFamily: 'DM Sans')),
                  value: _stream, activeColor: AppTheme.primary, onChanged: (v) => setState(() => _stream = v)),
            ]),
          ),
          const SizedBox(height: 32),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(onPressed: _startExport,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111111), foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
              child: const Text('Export', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'DM Sans')),
            ))),
      ]),
    );
  }
}

class _FormatSegmented extends StatelessWidget {
  final ExportFormat selected;
  final void Function(ExportFormat) onChanged;
  const _FormatSegmented({required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final fmts = [ExportFormat.mp4, ExportFormat.mov, ExportFormat.gif];
    final labs = ['MP4', 'MOV', 'GIF'];
    return Container(height: 40,
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8)),
      child: Row(children: List.generate(fmts.length, (i) {
        final on = fmts[i] == selected;
        return Expanded(child: GestureDetector(onTap: () => onChanged(fmts[i]),
          child: Container(margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: on ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: on ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)] : []),
            alignment: Alignment.center,
            child: Text(labs[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: on ? const Color(0xFF111111) : const Color(0xFF888888), fontFamily: 'DM Sans')))));
      })));
  }
}

class _ExportProgressSheet extends StatefulWidget {
  final String projectId;
  final ExportSettings settings;
  final void Function(String) onComplete;
  const _ExportProgressSheet({required this.projectId, required this.settings, required this.onComplete});
  @override
  State<_ExportProgressSheet> createState() => _ExportProgressSheetState();
}

class _ExportProgressSheetState extends State<_ExportProgressSheet> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  String _status = 'Preparing…';
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _runExport();
  }
  Future<void> _runExport() async {
    setState(() => _status = 'Encoding video…');
    try {
      final path = await VideoRenderService().renderProject(projectId: widget.projectId, settings: widget.settings);
      setState(() => _status = 'Finalizing…');
      await Future.delayed(const Duration(milliseconds: 600));
      widget.onComplete(path);
    } catch (e) { setState(() => _status = 'Error: $e'); }
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 24),
      const Text('Exporting…', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'DM Sans')),
      const SizedBox(height: 8),
      Text(_status, style: const TextStyle(fontSize: 13, color: Color(0xFF888888), fontFamily: 'DM Sans')),
      const SizedBox(height: 20),
      AnimatedBuilder(animation: _anim, builder: (_, __) => ClipRRect(borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(value: _anim.value, backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation(AppTheme.primary), minHeight: 6))),
      const SizedBox(height: 28),
    ]));
}

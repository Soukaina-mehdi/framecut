import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../models/clip.dart';
import '../../../models/audio_track.dart';
import '../../../models/text_overlay.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';

class SubtitlesTool extends ConsumerStatefulWidget {
  const SubtitlesTool({super.key});
  @override
  ConsumerState<SubtitlesTool> createState() => _SubtitlesToolState();
}

class _SubtitlesToolState extends ConsumerState<SubtitlesTool> {
  final _textCtrl = TextEditingController();
  final _startCtrl = TextEditingController(text: '00:00');
  final _endCtrl = TextEditingController(text: '00:03');
  double _fontSize = 16.0;

  @override
  void dispose() {
    _textCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final overlays = state.selectedClip?.textOverlays ?? [];

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.closed_caption, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Subtitles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 6),
          TextField(
            controller: _textCtrl,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Enter caption text...',
              hintStyle: const TextStyle(color: Colors.white38),
              contentPadding: const EdgeInsets.all(8),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentColor), borderRadius: BorderRadius.circular(4)),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              isDense: true,
            ),
          ),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: _timeField('Start', _startCtrl)),
            const SizedBox(width: 6),
            Expanded(child: _timeField('End', _endCtrl)),
            const SizedBox(width: 6),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Size', style: TextStyle(color: Colors.white54, fontSize: 10)),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5), activeTrackColor: AppTheme.accentColor, inactiveTrackColor: const Color(0xFF2A2A2A), thumbColor: AppTheme.accentColor),
                  child: Slider(value: _fontSize, min: 10, max: 32, onChanged: (v) => setState(() => _fontSize = v)),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 4),
          if (overlays.isNotEmpty) Expanded(
            child: ListView.builder(
              itemCount: overlays.length,
              itemBuilder: (ctx, i) => Container(
                margin: const EdgeInsets.only(bottom: 3),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4), color: const Color(0xFF1A1A1A)),
                child: Row(children: [
                  Expanded(child: Text(overlays[i].text, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  GestureDetector(
                    onTap: () {
                      final clip = state.selectedClip;
                      if (clip == null) return;
                      final updated = overlays.where((o) => o.id != overlays[i].id).toList();
                      ref.read(editorProvider.notifier).updateClip(clip.copyWith(textOverlays: updated));
                    },
                    child: const Icon(Icons.close, color: Colors.white38, size: 14),
                  ),
                ]),
              ),
            ),
          ) else const SizedBox(),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: _textCtrl.text.isEmpty ? null : () {
                ref.read(editorProvider.notifier).addTextOverlay(TextOverlay(
                  id: const Uuid().v4(),
                  text: _textCtrl.text,
                  animation: 'fade',
                  durationSec: 3.0,
                  x: 0.5,
                  y: 0.9,
                  fontSize: _fontSize,
                ));
                _textCtrl.clear();
              },
              child: const Text('Add Caption', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeField(String label, TextEditingController ctrl) => TextField(
    controller: ctrl,
    style: const TextStyle(color: Colors.white, fontSize: 11),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentColor), borderRadius: BorderRadius.circular(4)),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      isDense: true,
    ),
  );
}

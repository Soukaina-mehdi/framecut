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

class PitchTool extends ConsumerStatefulWidget {
  const PitchTool({super.key});
  @override
  ConsumerState<PitchTool> createState() => _PitchToolState();
}

class _PitchToolState extends ConsumerState<PitchTool> {
  int _semitones = 0;

  static const _noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  static const _presets = [-12, -5, 0, 5, 12];

  String _noteName(int semitones) {
    final baseNote = 0; // C
    final noteIndex = ((baseNote + semitones) % 12 + 12) % 12;
    return _noteNames[noteIndex];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.music_note, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Pitch Shift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.accentColor),
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.accentColor.withOpacity(0.1),
              ),
              child: Text(_noteName(_semitones), style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Text('Semitones:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            Text(
              _semitones == 0 ? '0' : (_semitones > 0 ? '+$_semitones' : '$_semitones'),
              style: TextStyle(color: _semitones == 0 ? Colors.white : AppTheme.accentColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]),
          Slider(
            value: _semitones.toDouble(),
            min: -12,
            max: 12,
            divisions: 24,
            activeColor: AppTheme.accentColor,
            inactiveColor: const Color(0xFF2A2A2A),
            onChanged: (v) => setState(() => _semitones = v.round()),
          ),
          Row(children: [
            const Text('Presets:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            for (final p in _presets)
              GestureDetector(
                onTap: () => setState(() => _semitones = p),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _semitones == p ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                    border: Border.all(color: _semitones == p ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(p >= 0 ? '+$p' : '$p', style: TextStyle(color: _semitones == p ? Colors.white : Colors.white60, fontSize: 11)),
                ),
              ),
          ]),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'pitch',
                  params: {'semitones': _semitones},
                ));
              },
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Apply Pitch Shift'),
            ),
          ),
        ],
      ),
    );
  }
}

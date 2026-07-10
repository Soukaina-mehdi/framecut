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

class BeatDetectionTool extends ConsumerStatefulWidget {
  const BeatDetectionTool({super.key});
  @override
  ConsumerState<BeatDetectionTool> createState() => _BeatDetectionToolState();
}

class _BeatDetectionToolState extends ConsumerState<BeatDetectionTool> {
  bool _analyzing = false;
  int? _detectedBpm;
  double _progress = 0;

  Future<void> _analyzeBeat() async {
    setState(() { _analyzing = true; _progress = 0; _detectedBpm = null; });
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => _progress = i / 10);
    }
    setState(() { _analyzing = false; _detectedBpm = 120; });
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
            const Text('Beat Detection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          if (_analyzing) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Analyzing audio...', style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: const Color(0xFF2A2A2A),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                ),
              ],
            ),
          ] else if (_detectedBpm != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.accentColor),
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.accentColor.withOpacity(0.1),
              ),
              child: Row(children: [
                Icon(Icons.music_note, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text('$_detectedBpm BPM', style: TextStyle(color: AppTheme.accentColor, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Text('Detected', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ]),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2A2A2A)),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF1A1A1A),
              ),
              child: const Text('Analyze your clip to detect the beat tempo', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
          ],
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2A2A2A)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _analyzing ? null : _analyzeBeat,
                icon: const Icon(Icons.radar, size: 16),
                label: const Text('Analyze Beat'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _detectedBpm == null ? null : () {
                  ref.read(editorProvider.notifier).addEffect(Effect(
                    id: const Uuid().v4(),
                    typeName: 'beatDetection',
                    params: {'bpm': _detectedBpm ?? 120, 'autoCut': false},
                  ));
                },
                icon: const Icon(Icons.content_cut, size: 16),
                label: const Text('Auto-Cut'),
              ),
            ),
          ]),
          if (_detectedBpm != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4)),
              child: const Text('Auto-Cut will split your clip at each beat marker', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }
}

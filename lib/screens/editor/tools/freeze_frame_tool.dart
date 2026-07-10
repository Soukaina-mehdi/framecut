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

class FreezeFrameTool extends ConsumerStatefulWidget {
  const FreezeFrameTool({super.key});
  @override
  ConsumerState<FreezeFrameTool> createState() => _FreezeFrameToolState();
}

class _FreezeFrameToolState extends ConsumerState<FreezeFrameTool> {
  double _duration = 2.0;

  String _formatTime(double sec) {
    final m = sec ~/ 60;
    final s = (sec % 60).toStringAsFixed(1);
    return '${m.toString().padLeft(2, '0')}:${s.padLeft(4, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final clip = state.selectedClip;
    final playhead = state.playheadSec;

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.pause_circle_outline, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Freeze Frame', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF1A1A1A),
            ),
            child: Row(children: [
              const Icon(Icons.access_time, color: Colors.white54, size: 16),
              const SizedBox(width: 8),
              Text(
                'Freeze at: ${_formatTime(playhead)}',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          SliderRow(
            label: 'Duration',
            value: _duration,
            min: 0.5,
            max: 5.0,
            onChanged: (v) => setState(() => _duration = v),
            displayValue: '${_duration.toStringAsFixed(1)}s',
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF1A1A1A),
            ),
            child: Text(
              'Clip will freeze for ${_duration.toStringAsFixed(1)}s at ${_formatTime(playhead)}',
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: clip == null ? null : () {
                ref.read(editorProvider.notifier).updateClip(
                  clip.copyWith(freezeAtSec: playhead, freezeDurationSec: _duration),
                );
              },
              child: const Text('Freeze at Current Position'),
            ),
          ),
        ],
      ),
    );
  }
}

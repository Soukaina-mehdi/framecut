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

class KeyframeTool extends ConsumerStatefulWidget {
  const KeyframeTool({super.key});
  @override
  ConsumerState<KeyframeTool> createState() => _KeyframeToolState();
}

class _KeyframeToolState extends ConsumerState<KeyframeTool> {
  int? _selectedKfIndex;
  double _x = 0, _y = 0, _scale = 1.0, _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final clip = state.selectedClip;
    final keyframes = (clip?.keyframes ?? []) as List;
    final playhead = state.playheadSec;

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              const Text('Keyframes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: clip == null ? null : () {
                  final updated = List<Map<String, dynamic>>.from(keyframes.map((e) => Map<String, dynamic>.from(e as Map)));
                  updated.add({'time': playhead, 'x': 0.0, 'y': 0.0, 'scale': 1.0, 'opacity': 1.0});
                  updated.sort((a, b) => (a['time'] as double).compareTo(b['time'] as double));
                  ref.read(editorProvider.notifier).updateClip(clip.copyWith(keyframes: updated));
                },
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add Keyframe', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF1A1A1A),
            ),
            child: Stack(
              children: [
                for (int i = 0; i < keyframes.length; i++)
                  Positioned(
                    left: ((keyframes[i]['time'] as double? ?? 0) / (clip?.durationSec ?? 1)).clamp(0.0, 1.0) *
                        (MediaQuery.of(context).size.width - 48),
                    top: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedKfIndex = i;
                          final kf = keyframes[i] as Map;
                          _x = (kf['x'] as num?)?.toDouble() ?? 0;
                          _y = (kf['y'] as num?)?.toDouble() ?? 0;
                          _scale = (kf['scale'] as num?)?.toDouble() ?? 1.0;
                          _opacity = (kf['opacity'] as num?)?.toDouble() ?? 1.0;
                        });
                      },
                      child: Icon(Icons.diamond, color: _selectedKfIndex == i ? AppTheme.accentColor : Colors.white60, size: 16),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _selectedKfIndex == null
                ? const Center(child: Text('Tap a keyframe dot to edit', style: TextStyle(color: Colors.white38, fontSize: 12)))
                : Column(
                    children: [
                      SliderRow(label: 'X', value: _x, min: -1, max: 1, onChanged: (v) => setState(() => _x = v)),
                      SliderRow(label: 'Y', value: _y, min: -1, max: 1, onChanged: (v) => setState(() => _y = v)),
                      SliderRow(label: 'Scale', value: _scale, min: 0.1, max: 3, onChanged: (v) => setState(() => _scale = v)),
                      SliderRow(label: 'Opacity', value: _opacity, min: 0, max: 1, onChanged: (v) => setState(() => _opacity = v)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

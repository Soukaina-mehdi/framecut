import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

class TrimTool extends ConsumerStatefulWidget {
  const TrimTool({super.key});
  @override
  ConsumerState<TrimTool> createState() => _TrimToolState();
}

class _TrimToolState extends ConsumerState<TrimTool> {
  double _startTrim = 0.0;
  double _endTrim = 10.0;

  void _applyTrim() {
    final state = ref.read(editorProvider);
    final clip = state.selectedClip;
    final idx = state.selectedClipIndex;
    if (clip == null || idx < 0) return;
    final updated = clip.copyWith(
      startTrimSec: _startTrim,
      endTrimSec: _endTrim,
    );
    ref.read(editorProvider.notifier).updateClip(idx, updated);
  }

  String _fmt(double sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toStringAsFixed(1).padLeft(4, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final clip = ref.watch(editorProvider).selectedClip;
    final duration = clip?.durationSec ?? 10.0;
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Trim'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('In: ${_fmt(_startTrim)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Out: ${_fmt(_endTrim)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Dur: ${_fmt(_endTrim - _startTrim)}',
                  style: const TextStyle(color: AppTheme.accent, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          SliderRow(
            label: 'Start',
            value: _startTrim,
            min: 0,
            max: _endTrim - 0.1,
            onChanged: (v) => setState(() { _startTrim = v; _applyTrim(); }),
          ),
          SliderRow(
            label: 'End',
            value: _endTrim,
            min: _startTrim + 0.1,
            max: duration,
            onChanged: (v) => setState(() { _endTrim = v; _applyTrim(); }),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF2A2A2A)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () =>
                  ref.read(editorProvider.notifier).splitClipAtPlayhead(),
              icon: const Icon(Icons.content_cut, size: 16),
              label: const Text('Split at Playhead',
                  style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

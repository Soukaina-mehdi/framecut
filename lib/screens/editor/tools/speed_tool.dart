import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';
import '../../../models/clip.dart';

class SpeedTool extends ConsumerStatefulWidget {
  const SpeedTool({super.key});
  @override
  ConsumerState<SpeedTool> createState() => _SpeedToolState();
}

class _SpeedToolState extends ConsumerState<SpeedTool> {
  double _speed = 1.0;

  static const _presets = [0.25, 0.5, 1.0, 1.5, 2.0, 4.0, 8.0];

  void _setSpeed(double v) {
    setState(() => _speed = v);
    final state = ref.read(editorProvider);
    final clip = state.selectedClip;
    final idx = state.selectedClipIndex;
    if (clip == null || idx < 0) return;
    ref.read(editorProvider.notifier)
        .updateClip(idx, clip.copyWith(playbackSpeed: v));
  }

  String _presetLabel(double v) {
    if (v == v.truncate()) return '${v.toInt()}x';
    return '${v}x';
  }

  @override
  Widget build(BuildContext context) {
    final clip = ref.watch(editorProvider).selectedClip;
    final origDur = clip?.durationSec ?? 10.0;
    final newDur = origDur / _speed;

    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Speed'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_speed.toStringAsFixed(2)}x',
                  style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text(
                '${origDur.toStringAsFixed(1)}s → ${newDur.toStringAsFixed(1)}s',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presets.map((p) {
                final isSelected = (_speed - p).abs() < 0.001;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => _setSpeed(p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accent
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accent
                              : const Color(0xFF2A2A2A),
                        ),
                      ),
                      child: Text(_presetLabel(p),
                          style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          SliderRow(
            label: 'Fine',
            value: _speed,
            min: 0.1,
            max: 8.0,
            displayFormat: (v) => '${v.toStringAsFixed(2)}x',
            onChanged: _setSpeed,
          ),
        ],
      ),
    );
  }
}

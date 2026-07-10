import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';
import '../../../models/clip.dart';

class TransitionsTool extends ConsumerStatefulWidget {
  const TransitionsTool({super.key});
  @override
  ConsumerState<TransitionsTool> createState() => _TransitionsToolState();
}

class _TransitionsToolState extends ConsumerState<TransitionsTool> {
  String _selected = 'None';
  double _duration = 0.5;

  static const _types = [
    'None', 'Dissolve', 'Fade Black', 'Fade White',
    'Slide L', 'Slide R', 'Wipe', 'Push',
  ];

  void _apply(String type) {
    setState(() => _selected = type);
    final state = ref.read(editorProvider);
    final clip = state.selectedClip;
    final idx = state.selectedClipIndex;
    if (clip == null || idx < 0) return;
    ref.read(editorProvider.notifier).updateClip(
          idx,
          clip.copyWith(
            transitionTypeName: type == 'None' ? null : type,
            transitionDurationSec: _duration,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Transitions'),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.45,
              ),
              itemCount: _types.length,
              itemBuilder: (_, i) {
                final t = _types[i];
                final isSelected = _selected == t;
                return GestureDetector(
                  onTap: () => _apply(t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accent.withOpacity(0.15)
                          : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: isSelected
                              ? AppTheme.accent
                              : const Color(0xFF2A2A2A)),
                    ),
                    child: Center(
                      child: Text(t,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isSelected
                                  ? AppTheme.accent
                                  : Colors.white70,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    ),
                  ),
                );
              },
            ),
          ),
          SliderRow(
            label: 'Duration',
            value: _duration,
            min: 0.2,
            max: 2.0,
            displayFormat: (v) => '${v.toStringAsFixed(1)}s',
            onChanged: (v) {
              setState(() => _duration = v);
              if (_selected != 'None') _apply(_selected);
            },
          ),
        ],
      ),
    );
  }
}

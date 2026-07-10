import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

const _directions = ['radial', 'horizontal', 'vertical'];
const _dirLabels = ['Radial', 'Horizontal', 'Vertical'];

class ChromaticAberrationTool extends ConsumerStatefulWidget {
  const ChromaticAberrationTool({super.key});

  @override
  ConsumerState<ChromaticAberrationTool> createState() =>
      _ChromaticAberrationToolState();
}

class _ChromaticAberrationToolState
    extends ConsumerState<ChromaticAberrationTool> {
  double _intensity = 0.3;
  int _dirIdx = 0;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'chromaticAberration',
      params: {
        'intensity': _intensity,
        'direction': _directions[_dirIdx],
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Chromatic Aberration'),
          SliderRow(
            label: 'Intensity',
            value: _intensity,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _intensity = v);
              _apply();
            },
          ),
          const SizedBox(height: 14),
          const Text('Direction',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_directions.length, (i) {
              final sel = _dirIdx == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _dirIdx = i);
                    _apply();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? AppTheme.accent : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: sel
                              ? AppTheme.accent
                              : const Color(0xFF2A2A2A)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _dirLabels[i],
                      style: TextStyle(
                        color: sel ? Colors.black : Colors.white70,
                        fontSize: 12,
                        fontWeight:
                            sel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          _DirectionIcon(direction: _directions[_dirIdx]),
        ],
      ),
    );
  }
}

class _DirectionIcon extends StatelessWidget {
  final String direction;
  const _DirectionIcon({required this.direction});

  @override
  Widget build(BuildContext context) {
    final icon = direction == 'radial'
        ? Icons.blur_circular
        : direction == 'horizontal'
            ? Icons.swap_horiz
            : Icons.swap_vert;
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 6),
        Text(
          'Mode: ${direction[0].toUpperCase()}${direction.substring(1)} shift',
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}

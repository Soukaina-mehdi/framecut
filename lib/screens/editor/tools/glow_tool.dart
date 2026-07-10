import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

const _tints = [
  {'label': 'White', 'color': Color(0xFFFFFFFF)},
  {'label': 'Warm', 'color': Color(0xFFFFD580)},
  {'label': 'Cool', 'color': Color(0xFF80C8FF)},
  {'label': 'Gold', 'color': Color(0xFFFFAA00)},
  {'label': 'Pink', 'color': Color(0xFFFF80C0)},
];

class GlowTool extends ConsumerStatefulWidget {
  const GlowTool({super.key});

  @override
  ConsumerState<GlowTool> createState() => _GlowToolState();
}

class _GlowToolState extends ConsumerState<GlowTool> {
  double _radius = 0.3;
  double _intensity = 0.5;
  double _threshold = 0.7;
  int _tintIdx = 0;

  void _apply() {
    final tint = _tints[_tintIdx]['color'] as Color;
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'glow',
      params: {
        'radius': _radius,
        'intensity': _intensity,
        'threshold': _threshold,
        'tint': tint.value,
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
          const SectionHeader(title: 'Glow'),
          SliderRow(
            label: 'Radius',
            value: _radius,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _radius = v);
              _apply();
            },
          ),
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
          SliderRow(
            label: 'Threshold',
            value: _threshold,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _threshold = v);
              _apply();
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Tint  ',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              ...List.generate(_tints.length, (i) {
                final sel = _tintIdx == i;
                final col = _tints[i]['color'] as Color;
                return GestureDetector(
                  onTap: () {
                    setState(() => _tintIdx = i);
                    _apply();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    margin: const EdgeInsets.only(right: 8),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: col,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sel ? Colors.white : const Color(0xFF2A2A2A),
                        width: sel ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Text(
                _tints[_tintIdx]['label'] as String,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

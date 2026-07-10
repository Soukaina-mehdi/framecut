import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

const _presets = [
  'Teal Orange', 'Kodak', 'Fuji Velvia', 'Cinematic',
  'Matte', 'Bleach', 'Vintage', 'Fade',
];

class LutTool extends ConsumerStatefulWidget {
  const LutTool({super.key});

  @override
  ConsumerState<LutTool> createState() => _LutToolState();
}

class _LutToolState extends ConsumerState<LutTool> {
  String? _selected;
  double _intensity = 0.8;

  void _apply(String preset) {
    setState(() => _selected = preset);
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'lut',
      params: {'preset': preset, 'intensity': _intensity},
    ));
  }

  void _onIntensityChanged(double v) {
    setState(() => _intensity = v);
    if (_selected != null) _apply(_selected!);
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
          const SectionHeader(title: 'LUT Presets'),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final p = _presets[i];
                final sel = _selected == p;
                return GestureDetector(
                  onTap: () => _apply(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppTheme.accent : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? AppTheme.accent : const Color(0xFF2A2A2A),
                      ),
                    ),
                    child: Text(
                      p,
                      style: TextStyle(
                        color: sel ? Colors.black : Colors.white70,
                        fontSize: 12,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SliderRow(
            label: 'Intensity',
            value: _intensity,
            min: 0.0,
            max: 1.0,
            onChanged: _onIntensityChanged,
          ),
          const SizedBox(height: 8),
          if (_selected != null)
            Text(
              'Applied: $_selected',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

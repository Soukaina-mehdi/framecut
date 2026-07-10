import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';
import '../../../models/effect.dart';

class ColorGradingTool extends ConsumerStatefulWidget {
  const ColorGradingTool({super.key});
  @override
  ConsumerState<ColorGradingTool> createState() => _ColorGradingToolState();
}

class _ColorGradingToolState extends ConsumerState<ColorGradingTool> {
  double _brightness = 0.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _hue = 0.0;
  double _exposure = 0.0;
  double _temperature = 0.0;

  void _applyGrading() {
    ref.read(editorProvider.notifier).addEffect(
          Effect(
            id: const Uuid().v4(),
            typeName: 'colorGrading',
            params: {
              'brightness': _brightness,
              'contrast': _contrast,
              'saturation': _saturation,
              'hue': _hue,
              'exposure': _exposure,
              'temperature': _temperature,
            },
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
          const SectionHeader(title: 'Color Grading'),
          Expanded(
            child: ListView(
              children: [
                SliderRow(
                  label: 'Brightness',
                  value: _brightness,
                  min: -1,
                  max: 1,
                  onChanged: (v) {
                    setState(() => _brightness = v);
                    _applyGrading();
                  },
                ),
                SliderRow(
                  label: 'Contrast',
                  value: _contrast,
                  min: 0,
                  max: 2,
                  onChanged: (v) {
                    setState(() => _contrast = v);
                    _applyGrading();
                  },
                ),
                SliderRow(
                  label: 'Saturation',
                  value: _saturation,
                  min: 0,
                  max: 2,
                  onChanged: (v) {
                    setState(() => _saturation = v);
                    _applyGrading();
                  },
                ),
                SliderRow(
                  label: 'Hue',
                  value: _hue,
                  min: -180,
                  max: 180,
                  displayFormat: (v) => '${v.toStringAsFixed(0)}°',
                  onChanged: (v) {
                    setState(() => _hue = v);
                    _applyGrading();
                  },
                ),
                SliderRow(
                  label: 'Exposure',
                  value: _exposure,
                  min: -2,
                  max: 2,
                  onChanged: (v) {
                    setState(() => _exposure = v);
                    _applyGrading();
                  },
                ),
                SliderRow(
                  label: 'Temperature',
                  value: _temperature,
                  min: -100,
                  max: 100,
                  displayFormat: (v) => '${v.toStringAsFixed(0)}K',
                  onChanged: (v) {
                    setState(() => _temperature = v);
                    _applyGrading();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

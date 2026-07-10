import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

class DehazeTool extends ConsumerStatefulWidget {
  const DehazeTool({super.key});

  @override
  ConsumerState<DehazeTool> createState() => _DehazeToolState();
}

class _DehazeToolState extends ConsumerState<DehazeTool> {
  double _amount = 0.5;
  double _exposure = 0.0;
  double _contrast = 0.0;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'dehaze',
      params: {
        'amount': _amount,
        'exposure': _exposure,
        'contrast': _contrast,
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
          const SectionHeader(title: 'Dehaze'),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.blur_on, color: Colors.white38, size: 14),
              const SizedBox(width: 6),
              const Text(
                'Removes atmospheric haze from footage',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderRow(
            label: 'Dehaze Amount',
            value: _amount,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _amount = v);
              _apply();
            },
          ),
          SliderRow(
            label: 'Exposure',
            value: _exposure,
            min: -1.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _exposure = v);
              _apply();
            },
          ),
          SliderRow(
            label: 'Contrast Boost',
            value: _contrast,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _contrast = v);
              _apply();
            },
          ),
        ],
      ),
    );
  }
}

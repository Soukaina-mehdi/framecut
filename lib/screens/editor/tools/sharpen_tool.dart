import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

class SharpenTool extends ConsumerStatefulWidget {
  const SharpenTool({super.key});

  @override
  ConsumerState<SharpenTool> createState() => _SharpenToolState();
}

class _SharpenToolState extends ConsumerState<SharpenTool> {
  double _luma = 1.0;
  double _chroma = 0.5;
  double _radius = 3.0;
  bool _clarity = false;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'sharpen',
      params: {
        'luma': _luma,
        'chroma': _chroma,
        'radius': _radius,
        'clarity': _clarity,
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
          const SectionHeader(title: 'Sharpen'),
          SliderRow(
            label: 'Luma Amount',
            value: _luma,
            min: -2.0,
            max: 2.0,
            onChanged: (v) {
              setState(() => _luma = v);
              _apply();
            },
          ),
          SliderRow(
            label: 'Chroma Amount',
            value: _chroma,
            min: -2.0,
            max: 2.0,
            onChanged: (v) {
              setState(() => _chroma = v);
              _apply();
            },
          ),
          SliderRow(
            label: 'Radius',
            value: _radius,
            min: 1.0,
            max: 10.0,
            onChanged: (v) {
              setState(() => _radius = v);
              _apply();
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Clarity Mode',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 2),
                  Text('Stronger unsharp mask',
                      style:
                          TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
              const Spacer(),
              Switch(
                value: _clarity,
                onChanged: (v) {
                  setState(() => _clarity = v);
                  _apply();
                },
                activeColor: AppTheme.accent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

class MotionBlurTool extends ConsumerStatefulWidget {
  const MotionBlurTool({super.key});
  @override
  ConsumerState<MotionBlurTool> createState() => _MotionBlurToolState();
}

class _MotionBlurToolState extends ConsumerState<MotionBlurTool> {
  String _type = 'radial';
  double _strength = 0.5;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.motion_photos_on, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Motion Blur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Text('Type:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 10),
            _typeBtn('Radial', 'radial'),
            const SizedBox(width: 8),
            _typeBtn('Directional', 'directional'),
          ]),
          const SizedBox(height: 8),
          SliderRow(label: 'Strength', value: _strength, min: 0, max: 1, onChanged: (v) => setState(() => _strength = v)),
          AnimatedOpacity(
            opacity: _type == 'directional' ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: _type != 'directional',
              child: SliderRow(
                label: 'Angle',
                value: _angle,
                min: 0,
                max: 360,
                onChanged: (v) => setState(() => _angle = v),
                displayValue: '${_angle.round()}°',
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'motionBlur',
                  params: {'type': _type, 'strength': _strength, 'angle': _angle.round()},
                ));
              },
              child: const Text('Apply Motion Blur'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeBtn(String label, String value) {
    final selected = _type == value;
    return GestureDetector(
      onTap: () => setState(() => _type = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentColor : const Color(0xFF1A1A1A),
          border: Border.all(color: selected ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.white60, fontSize: 12)),
      ),
    );
  }
}

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

class ShakeTool extends ConsumerStatefulWidget {
  const ShakeTool({super.key});
  @override
  ConsumerState<ShakeTool> createState() => _ShakeToolState();
}

class _ShakeToolState extends ConsumerState<ShakeTool> with SingleTickerProviderStateMixin {
  double _intensity = 0.3;
  double _frequency = 5.0;
  String _type = 'random';
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  static const _types = [('Random', 'random'), ('Vertical', 'vertical'), ('Horizontal', 'horizontal')];

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..repeat(reverse: true);
    _shakeAnim = Tween<double>(begin: -4, end: 4).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

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
            const Icon(Icons.vibration, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Shake Effect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            AnimatedBuilder(
              animation: _shakeAnim,
              builder: (ctx, child) => Transform.translate(
                offset: Offset(_type != 'vertical' ? _shakeAnim.value * _intensity * 2 : 0, _type != 'horizontal' ? _shakeAnim.value * _intensity * 2 : 0),
                child: const Icon(Icons.videocam, color: Colors.white54, size: 22),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          SliderRow(label: 'Intensity', value: _intensity, min: 0, max: 1, onChanged: (v) => setState(() => _intensity = v)),
          SliderRow(label: 'Frequency', value: _frequency, min: 1, max: 10, onChanged: (v) => setState(() { _frequency = v; _shakeCtrl.duration = Duration(milliseconds: (300 / (_frequency / 5)).round()); }), displayValue: '${_frequency.round()} Hz'),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Type:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            ..._types.map((t) => GestureDetector(
              onTap: () => setState(() => _type = t.$2),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _type == t.$2 ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                  border: Border.all(color: _type == t.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(t.$1, style: TextStyle(color: _type == t.$2 ? Colors.white : Colors.white60, fontSize: 11)),
              ),
            )),
          ]),
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
                  typeName: 'shake',
                  params: {'intensity': _intensity, 'frequency': _frequency.round(), 'type': _type},
                ));
              },
              child: const Text('Apply Shake'),
            ),
          ),
        ],
      ),
    );
  }
}

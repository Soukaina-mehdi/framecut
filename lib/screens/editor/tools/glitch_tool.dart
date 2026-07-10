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

class GlitchTool extends ConsumerStatefulWidget {
  const GlitchTool({super.key});
  @override
  ConsumerState<GlitchTool> createState() => _GlitchToolState();
}

class _GlitchToolState extends ConsumerState<GlitchTool> with SingleTickerProviderStateMixin {
  double _intensity = 0.5;
  double _frequency = 5.0;
  bool _rgbShift = true;
  bool _scanLines = false;
  bool _noise = true;
  late AnimationController _glitchCtrl;

  @override
  void initState() {
    super.initState();
    _glitchCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glitchCtrl.dispose();
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
            const Icon(Icons.broken_image, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Glitch Effect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            AnimatedBuilder(
              animation: _glitchCtrl,
              builder: (ctx, _) => Stack(alignment: Alignment.center, children: [
                Transform.translate(offset: Offset(_glitchCtrl.value * _intensity * 6, 0), child: const Icon(Icons.broken_image, color: Colors.red, size: 22, semanticLabel: '')),
                Transform.translate(offset: Offset(-_glitchCtrl.value * _intensity * 6, 1), child: const Icon(Icons.broken_image, color: Colors.cyan, size: 22, semanticLabel: '')),
                const Icon(Icons.broken_image, color: Colors.white, size: 22),
              ]),
            ),
          ]),
          const SizedBox(height: 8),
          SliderRow(label: 'Intensity', value: _intensity, min: 0, max: 1, onChanged: (v) => setState(() => _intensity = v)),
          SliderRow(label: 'Frequency', value: _frequency, min: 1, max: 20, onChanged: (v) => setState(() => _frequency = v), displayValue: '${_frequency.round()}/s'),
          const SizedBox(height: 6),
          Row(children: [
            _toggleChip('RGB Shift', _rgbShift, (v) => setState(() => _rgbShift = v)),
            const SizedBox(width: 6),
            _toggleChip('Scan Lines', _scanLines, (v) => setState(() => _scanLines = v)),
            const SizedBox(width: 6),
            _toggleChip('Digital Noise', _noise, (v) => setState(() => _noise = v)),
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
                  typeName: 'glitch',
                  params: {
                    'intensity': _intensity,
                    'frequency': _frequency.round(),
                    'rgbShift': _rgbShift,
                    'scanLines': _scanLines,
                    'noise': _noise,
                  },
                ));
              },
              child: const Text('Apply Glitch'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip(String label, bool value, ValueChanged<bool> onChanged) => GestureDetector(
    onTap: () => onChanged(!value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: value ? AppTheme.accentColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
        border: Border.all(color: value ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(value ? Icons.check_box : Icons.check_box_outline_blank, color: value ? AppTheme.accentColor : Colors.white38, size: 13),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: value ? Colors.white : Colors.white54, fontSize: 10)),
      ]),
    ),
  );
}

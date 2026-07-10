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

class ChromaKeyTool extends ConsumerStatefulWidget {
  const ChromaKeyTool({super.key});
  @override
  ConsumerState<ChromaKeyTool> createState() => _ChromaKeyToolState();
}

class _ChromaKeyToolState extends ConsumerState<ChromaKeyTool> {
  String _selectedColor = '00FF00';
  double _similarity = 0.3;
  double _blend = 0.1;
  bool _enabled = true;

  static const _colors = [
    ('Green', '00FF00', Color(0xFF00FF00)),
    ('Blue', '0000FF', Color(0xFF0000FF)),
    ('Custom', 'FF00FF', Color(0xFFFF00FF)),
  ];

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
            const Icon(Icons.blur_off, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Chroma Key', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(children: [
              const Text('Enable', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Switch(
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
                activeColor: AppTheme.accentColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ]),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            for (final c in _colors) ...[
              GestureDetector(
                onTap: () => setState(() => _selectedColor = c.$2),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _selectedColor == c.$2 ? c.$3.withOpacity(0.3) : const Color(0xFF1A1A1A),
                    border: Border.all(color: _selectedColor == c.$2 ? c.$3 : const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(children: [
                    Container(width: 10, height: 10, color: c.$3),
                    const SizedBox(width: 4),
                    Text(c.$1, style: TextStyle(color: _selectedColor == c.$2 ? Colors.white : Colors.white54, fontSize: 11)),
                  ]),
                ),
              ),
            ],
          ]),
          const SizedBox(height: 8),
          SliderRow(label: 'Similarity', value: _similarity, min: 0, max: 1, onChanged: (v) => setState(() => _similarity = v)),
          SliderRow(label: 'Blend/Spill', value: _blend, min: 0, max: 1, onChanged: (v) => setState(() => _blend = v)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: _enabled ? () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'chromaKey',
                  params: {'color': _selectedColor, 'similarity': _similarity, 'blend': _blend},
                ));
              } : null,
              child: const Text('Apply Chroma Key'),
            ),
          ),
        ],
      ),
    );
  }
}

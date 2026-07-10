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

class WatermarkTool extends ConsumerStatefulWidget {
  const WatermarkTool({super.key});
  @override
  ConsumerState<WatermarkTool> createState() => _WatermarkToolState();
}

class _WatermarkToolState extends ConsumerState<WatermarkTool> {
  String _path = '';
  double _opacity = 0.8;
  double _size = 0.15;
  String _position = 'br';
  bool _alwaysVisible = true;

  static const _positions = [
    ('TL', 'tl'), ('TR', 'tr'),
    ('C', 'center'),
    ('BL', 'bl'), ('BR', 'br'),
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
            const Icon(Icons.branding_watermark, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Watermark', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(children: [
              const Text('Always', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Switch(value: _alwaysVisible, onChanged: (v) => setState(() => _alwaysVisible = v), activeColor: AppTheme.accentColor, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ]),
          ]),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _path = '/path/to/logo.png'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _path.isEmpty ? const Color(0xFF2A2A2A) : AppTheme.accentColor),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF1A1A1A),
              ),
              child: Row(children: [
                Icon(Icons.image, color: _path.isEmpty ? Colors.white38 : AppTheme.accentColor, size: 16),
                const SizedBox(width: 8),
                Text(_path.isEmpty ? 'Import Logo (PNG)' : 'logo.png loaded ✓', style: TextStyle(color: _path.isEmpty ? Colors.white38 : Colors.white, fontSize: 12)),
              ]),
            ),
          ),
          const SizedBox(height: 6),
          SliderRow(label: 'Opacity', value: _opacity, min: 0, max: 1, onChanged: (v) => setState(() => _opacity = v)),
          SliderRow(label: 'Size', value: _size, min: 0.05, max: 0.5, onChanged: (v) => setState(() => _size = v)),
          const SizedBox(height: 4),
          Row(children: [
            const Text('Position:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            for (final p in _positions)
              GestureDetector(
                onTap: () => setState(() => _position = p.$2),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 32,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _position == p.$2 ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                    border: Border.all(color: _position == p.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(child: Text(p.$1, style: TextStyle(color: _position == p.$2 ? Colors.white : Colors.white54, fontSize: 10))),
                ),
              ),
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
                  typeName: 'watermark',
                  params: {'path': _path, 'opacity': _opacity, 'position': _position, 'size': _size},
                ));
              },
              child: const Text('Apply Watermark'),
            ),
          ),
        ],
      ),
    );
  }
}

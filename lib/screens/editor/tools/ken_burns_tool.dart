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

class KenBurnsTool extends ConsumerStatefulWidget {
  const KenBurnsTool({super.key});
  @override
  ConsumerState<KenBurnsTool> createState() => _KenBurnsToolState();
}

class _KenBurnsToolState extends ConsumerState<KenBurnsTool> {
  String _direction = 'zoomIn';
  String _speed = 'medium';
  bool _loop = false;

  static const _directions = [
    ('Zoom In', 'zoomIn', Icons.zoom_in),
    ('Zoom Out', 'zoomOut', Icons.zoom_out),
    ('Pan Left', 'panLeft', Icons.arrow_back),
    ('Pan Right', 'panRight', Icons.arrow_forward),
    ('Diagonal', 'diagonal', Icons.north_east),
  ];

  static const _speeds = [('Slow', 'slow'), ('Medium', 'medium'), ('Fast', 'fast')];

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
            const Icon(Icons.pan_tool_alt, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Ken Burns', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          const Text('Direction:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _directions.map((d) => GestureDetector(
              onTap: () => setState(() => _direction = d.$2),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _direction == d.$2 ? AppTheme.accentColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
                  border: Border.all(color: _direction == d.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(children: [
                  Icon(d.$3, color: _direction == d.$2 ? AppTheme.accentColor : Colors.white54, size: 18),
                  const SizedBox(height: 2),
                  Text(d.$1, style: TextStyle(color: _direction == d.$2 ? Colors.white : Colors.white54, fontSize: 10)),
                ]),
              ),
            )).toList()),
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Text('Speed:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            ..._speeds.map((s) => GestureDetector(
              onTap: () => setState(() => _speed = s.$2),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _speed == s.$2 ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                  border: Border.all(color: _speed == s.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(s.$1, style: TextStyle(color: _speed == s.$2 ? Colors.white : Colors.white60, fontSize: 11)),
              ),
            )),
            const Spacer(),
            Row(children: [
              const Text('Loop', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Switch(value: _loop, onChanged: (v) => setState(() => _loop = v), activeColor: AppTheme.accentColor, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ]),
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
                  typeName: 'kenBurns',
                  params: {'direction': _direction, 'speed': _speed, 'loop': _loop},
                ));
              },
              child: const Text('Apply Ken Burns'),
            ),
          ),
        ],
      ),
    );
  }
}

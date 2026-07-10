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

class PipTool extends ConsumerStatefulWidget {
  const PipTool({super.key});
  @override
  ConsumerState<PipTool> createState() => _PipToolState();
}

class _PipToolState extends ConsumerState<PipTool> {
  double _size = 0.25;
  String _position = 'tr';
  String? _pipClipName;

  static const _sizePresets = [
    ('Small 25%', 0.25),
    ('Medium 40%', 0.40),
    ('Large 60%', 0.60),
  ];

  static const _positions = [
    ('TL', 'tl'), ('TR', 'tr'),
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
            const Icon(Icons.picture_in_picture, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Picture-in-Picture', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _pipClipName = 'video_clip.mp4'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.accentColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(children: [
                  const Icon(Icons.add, color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  const Text('Add PIP', style: TextStyle(color: Colors.white, fontSize: 11)),
                ]),
              ),
            ),
          ]),
          if (_pipClipName != null) ...[
            const SizedBox(height: 4),
            Text('PIP: $_pipClipName', style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
          const SizedBox(height: 8),
          Row(children: [
            const Text('Size:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            for (final p in _sizePresets)
              GestureDetector(
                onTap: () => setState(() => _size = p.$2),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _size == p.$2 ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                    border: Border.all(color: _size == p.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(p.$1, style: TextStyle(color: _size == p.$2 ? Colors.white : Colors.white54, fontSize: 10)),
                ),
              ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Position:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              height: 48,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                shrinkWrap: true,
                children: _positions.map((p) => GestureDetector(
                  onTap: () => setState(() => _position = p.$2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _position == p.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(child: Text(p.$1, style: const TextStyle(color: Colors.white, fontSize: 8))),
                  ),
                )).toList(),
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
                  typeName: 'pip',
                  params: {'size': _size, 'position': _position},
                ));
              },
              child: const Text('Apply PIP'),
            ),
          ),
        ],
      ),
    );
  }
}

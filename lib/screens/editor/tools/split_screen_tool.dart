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

class SplitScreenTool extends ConsumerStatefulWidget {
  const SplitScreenTool({super.key});
  @override
  ConsumerState<SplitScreenTool> createState() => _SplitScreenToolState();
}

class _SplitScreenToolState extends ConsumerState<SplitScreenTool> {
  String _layout = '2h';
  String _path2 = '';

  static const _layouts = [
    ('2-up Horiz', '2h', Icons.horizontal_distribute),
    ('2-up Vert', '2v', Icons.vertical_distribute),
    ('4-up Grid', '4g', Icons.grid_view),
    ('Side by Side', 'sbs', Icons.view_agenda),
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
            const Icon(Icons.view_column, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Split Screen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          const Text('Layout:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Row(children: [
            for (final l in _layouts)
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _layout = l.$2),
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _layout == l.$2 ? AppTheme.accentColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
                      border: Border.all(color: _layout == l.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(children: [
                      Icon(l.$3, color: _layout == l.$2 ? AppTheme.accentColor : Colors.white54, size: 18),
                      const SizedBox(height: 2),
                      Text(l.$1, style: TextStyle(color: _layout == l.$2 ? Colors.white : Colors.white54, fontSize: 9), textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _path2 = '/path/to/video2.mp4'),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: _path2.isEmpty ? const Color(0xFF2A2A2A) : AppTheme.accentColor, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF1A1A1A),
              ),
              child: Row(children: [
                Icon(Icons.video_library, color: _path2.isEmpty ? Colors.white38 : AppTheme.accentColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  _path2.isEmpty ? 'Import Second Video' : 'video2.mp4',
                  style: TextStyle(color: _path2.isEmpty ? Colors.white38 : Colors.white, fontSize: 12),
                ),
              ]),
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
                  typeName: 'splitScreen',
                  params: {'layout': _layout, 'path2': _path2},
                ));
              },
              child: const Text('Apply Split Screen'),
            ),
          ),
        ],
      ),
    );
  }
}

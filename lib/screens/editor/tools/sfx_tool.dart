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

class SfxTool extends ConsumerStatefulWidget {
  const SfxTool({super.key});
  @override
  ConsumerState<SfxTool> createState() => _SfxToolState();
}

class _SfxToolState extends ConsumerState<SfxTool> {
  String? _lastAdded;

  static const _sfxList = [
    ('Whoosh', Icons.air),
    ('Snap', Icons.bolt),
    ('Pop', Icons.bubble_chart),
    ('Boom', Icons.flash_on),
    ('Swoosh', Icons.compare_arrows),
    ('Bell', Icons.notifications),
    ('Clap', Icons.waving_hand),
    ('Ding', Icons.circle_notifications),
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
            const Icon(Icons.surround_sound, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Sound Effects', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            if (_lastAdded != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Added: $_lastAdded', style: TextStyle(color: AppTheme.accentColor, fontSize: 10)),
              ),
            ],
          ]),
          const SizedBox(height: 6),
          const Text('Tap to add to timeline:', style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sfxList.map((sfx) {
                  final name = sfx.$1;
                  final icon = sfx.$2;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _lastAdded = name);
                      ref.read(editorProvider.notifier).addAudioTrack(AudioTrack(
                        id: const Uuid().v4(),
                        name: name,
                        path: 'assets/sfx/${name.toLowerCase()}.mp3',
                        volume: 1.0,
                      ));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      width: 64,
                      decoration: BoxDecoration(
                        color: _lastAdded == name ? AppTheme.accentColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
                        border: Border.all(color: _lastAdded == name ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(icon, color: _lastAdded == name ? AppTheme.accentColor : Colors.white54, size: 24),
                        const SizedBox(height: 4),
                        Text(name, style: TextStyle(color: _lastAdded == name ? Colors.white : Colors.white60, fontSize: 10), textAlign: TextAlign.center),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4), color: const Color(0xFF1A1A1A)),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Colors.white38, size: 13),
              SizedBox(width: 6),
              Text('SFX are added at playhead position', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ]),
          ),
        ],
      ),
    );
  }
}

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

class AnimatedTextTool extends ConsumerStatefulWidget {
  const AnimatedTextTool({super.key});
  @override
  ConsumerState<AnimatedTextTool> createState() => _AnimatedTextToolState();
}

class _AnimatedTextToolState extends ConsumerState<AnimatedTextTool> {
  String _selectedAnimation = 'typewriter';
  final _textController = TextEditingController(text: 'Enter text here');
  double _duration = 2.0;

  static const _animations = [
    ('Typewriter', 'typewriter', Icons.keyboard),
    ('Slide In', 'slideIn', Icons.arrow_forward),
    ('Bounce', 'bounce', Icons.sports_basketball),
    ('Fade', 'fade', Icons.gradient),
    ('Glitch', 'glitch', Icons.broken_image),
    ('Neon', 'neon', Icons.lightbulb_outline),
  ];

  @override
  void dispose() {
    _textController.dispose();
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
            const Icon(Icons.text_fields, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Animated Text', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          TextField(
            controller: _textController,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Enter text...',
              hintStyle: const TextStyle(color: Colors.white38),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentColor), borderRadius: BorderRadius.circular(4)),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _animations.length,
              itemBuilder: (context, i) {
                final anim = _animations[i];
                final selected = _selectedAnimation == anim.$2;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAnimation = anim.$2),
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.accentColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
                      border: Border.all(color: selected ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(anim.$3, color: selected ? AppTheme.accentColor : Colors.white54, size: 20),
                      const SizedBox(height: 4),
                      Text(anim.$1, style: TextStyle(color: selected ? Colors.white : Colors.white54, fontSize: 9), textAlign: TextAlign.center),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          SliderRow(label: 'Duration', value: _duration, min: 0.5, max: 5.0, onChanged: (v) => setState(() => _duration = v), displayValue: '${_duration.toStringAsFixed(1)}s'),
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
                ref.read(editorProvider.notifier).addTextOverlay(TextOverlay(
                  id: const Uuid().v4(),
                  text: _textController.text,
                  animation: _selectedAnimation,
                  durationSec: _duration,
                  x: 0.5,
                  y: 0.5,
                ));
              },
              child: const Text('Add Animated Text'),
            ),
          ),
        ],
      ),
    );
  }
}

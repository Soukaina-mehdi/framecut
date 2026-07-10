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

class ColorMatchTool extends ConsumerStatefulWidget {
  const ColorMatchTool({super.key});
  @override
  ConsumerState<ColorMatchTool> createState() => _ColorMatchToolState();
}

class _ColorMatchToolState extends ConsumerState<ColorMatchTool> {
  int _referenceIndex = 0;
  double _strength = 0.8;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final clips = state.project?.clips ?? [];

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.color_lens, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Color Match', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Match color from reference clip',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Text('Reference Clip:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _referenceIndex.clamp(0, clips.isEmpty ? 0 : clips.length - 1),
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items: clips.isEmpty
                        ? [const DropdownMenuItem(value: 0, child: Text('No clips', style: TextStyle(color: Colors.white54)))]
                        : clips.asMap().entries.map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text('Clip ${e.key + 1}', style: const TextStyle(color: Colors.white)),
                            )).toList(),
                    onChanged: (v) => setState(() => _referenceIndex = v ?? 0),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          SliderRow(
            label: 'Strength',
            value: _strength,
            min: 0,
            max: 1,
            onChanged: (v) => setState(() => _strength = v),
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
              onPressed: clips.isEmpty ? null : () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'colorMatch',
                  params: {'referenceIndex': _referenceIndex, 'strength': _strength},
                ));
              },
              child: const Text('Apply Color Match'),
            ),
          ),
        ],
      ),
    );
  }
}

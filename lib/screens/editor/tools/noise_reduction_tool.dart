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

class NoiseReductionTool extends ConsumerStatefulWidget {
  const NoiseReductionTool({super.key});
  @override
  ConsumerState<NoiseReductionTool> createState() => _NoiseReductionToolState();
}

class _NoiseReductionToolState extends ConsumerState<NoiseReductionTool> {
  bool _enabled = true;
  double _strength = 0.5;
  String _profile = 'medium';

  static const _profiles = [
    ('Light', 'light'),
    ('Medium', 'medium'),
    ('Aggressive', 'aggressive'),
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
            const Icon(Icons.noise_aware, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Noise Reduction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          AnimatedOpacity(
            opacity: _enabled ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_enabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliderRow(label: 'Strength', value: _strength, min: 0, max: 1, onChanged: (v) => setState(() => _strength = v)),
                  const SizedBox(height: 8),
                  const Text('Profile:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(children: _profiles.map((p) => GestureDetector(
                    onTap: () => setState(() => _profile = p.$2),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _profile == p.$2 ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                        border: Border.all(color: _profile == p.$2 ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(p.$1, style: TextStyle(color: _profile == p.$2 ? Colors.white : Colors.white60, fontSize: 12)),
                    ),
                  )).toList()),
                ],
              ),
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
              onPressed: _enabled ? () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'noiseReduction',
                  params: {'strength': _strength, 'profile': _profile},
                ));
              } : null,
              child: const Text('Apply Noise Reduction'),
            ),
          ),
        ],
      ),
    );
  }
}

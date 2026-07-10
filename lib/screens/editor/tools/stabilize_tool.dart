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

class StabilizeTool extends ConsumerStatefulWidget {
  const StabilizeTool({super.key});
  @override
  ConsumerState<StabilizeTool> createState() => _StabilizeToolState();
}

class _StabilizeToolState extends ConsumerState<StabilizeTool> {
  double _strength = 0.7;
  double _smoothing = 0.5;
  bool _loading = false;

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
            const Icon(Icons.videocam_outlined, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Stabilize', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF1A1A1A),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline, color: Colors.white38, size: 14),
              const SizedBox(width: 6),
              const Expanded(
                child: Text('Reduces camera shake and jitter', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          SliderRow(label: 'Strength', value: _strength, min: 0, max: 1, onChanged: (v) => setState(() => _strength = v)),
          SliderRow(label: 'Smoothing', value: _smoothing, min: 0, max: 1, onChanged: (v) => setState(() => _smoothing = v)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _loading ? Colors.grey.shade800 : AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: _loading ? null : () async {
                setState(() => _loading = true);
                await Future.delayed(const Duration(milliseconds: 800));
                if (!mounted) return;
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'stabilize',
                  params: {'strength': _strength, 'smoothing': _smoothing},
                ));
                setState(() => _loading = false);
              },
              child: _loading
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Stabilize Clip'),
            ),
          ),
        ],
      ),
    );
  }
}

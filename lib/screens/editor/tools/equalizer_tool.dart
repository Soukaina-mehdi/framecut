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

class EqualizerTool extends ConsumerStatefulWidget {
  const EqualizerTool({super.key});
  @override
  ConsumerState<EqualizerTool> createState() => _EqualizerToolState();
}

class _EqualizerToolState extends ConsumerState<EqualizerTool> {
  final List<double> _bands = [0.0, 0.0, 0.0, 0.0, 0.0];
  static const _labels = ['80Hz', '250Hz', '1kHz', '4kHz', '12kHz'];
  static const _names = ['Bass', 'Low-Mid', 'Mid', 'High-Mid', 'Treble'];

  static const _presets = {
    'Flat': [0.0, 0.0, 0.0, 0.0, 0.0],
    'Bass Boost': [6.0, 3.0, 0.0, -1.0, -2.0],
    'Voice': [-2.0, 0.0, 4.0, 3.0, 1.0],
    'Pop': [1.0, 2.0, 4.0, 2.0, 1.0],
    'Rock': [4.0, 2.0, -1.0, 2.0, 4.0],
  };

  void _applyPreset(String name) {
    final values = _presets[name]!;
    setState(() {
      for (int i = 0; i < _bands.length; i++) _bands[i] = values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.equalizer, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Equalizer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 6),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(5, (i) => Expanded(
                child: Column(children: [
                  Text('${_bands[i].toStringAsFixed(0)}', style: const TextStyle(color: Colors.white54, fontSize: 9)),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          activeTrackColor: AppTheme.accentColor,
                          inactiveTrackColor: const Color(0xFF2A2A2A),
                          thumbColor: AppTheme.accentColor,
                        ),
                        child: Slider(
                          value: _bands[i],
                          min: -12,
                          max: 12,
                          onChanged: (v) => setState(() => _bands[i] = v),
                        ),
                      ),
                    ),
                  ),
                  Text(_labels[i], style: const TextStyle(color: Colors.white38, fontSize: 8)),
                  Text(_names[i], style: const TextStyle(color: Colors.white54, fontSize: 9)),
                ]),
              )),
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _presets.keys.map((name) => GestureDetector(
              onTap: () => _applyPreset(name),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFF1A1A1A),
                ),
                child: Text(name, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ),
            )).toList()),
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
                ref.read(editorProvider.notifier).addAudioTrack(AudioTrack(
                  id: const Uuid().v4(),
                  name: 'EQ Track',
                  path: '',
                  volume: 1.0,
                  eqBands: List<double>.from(_bands),
                ));
              },
              child: const Text('Apply EQ'),
            ),
          ),
        ],
      ),
    );
  }
}

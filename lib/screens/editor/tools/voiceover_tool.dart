import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/section_header.dart';
import '../../../models/audio_track.dart';

class VoiceoverTool extends ConsumerStatefulWidget {
  const VoiceoverTool({super.key});
  @override
  ConsumerState<VoiceoverTool> createState() => _VoiceoverToolState();
}

class _VoiceoverToolState extends ConsumerState<VoiceoverTool> {
  bool _isRecording = false;
  int _seconds = 0;
  // ignore: cancel_subscriptions
  dynamic _timer; // Would be Timer in real impl

  String get _timeDisplay {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _toggleRecording() {
    if (_isRecording) {
      // Stop recording — add voiceover track
      setState(() { _isRecording = false; });
      ref.read(editorProvider.notifier).addAudioTrack(
            AudioTrack(
              id: const Uuid().v4(),
              filePath: 'voiceover_${_timeDisplay}.m4a',
              volume: 1.0,
              fadeIn: false,
              fadeOut: false,
              typeName: 'voiceover',
            ),
          );
      setState(() => _seconds = 0);
    } else {
      setState(() { _isRecording = true; _seconds = 0; });
      // In a real app, start a Timer.periodic to increment _seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const SectionHeader(title: 'Voiceover'),
          const Spacer(),
          // Timer display
          Text(
            _timeDisplay,
            style: TextStyle(
              color: _isRecording ? Colors.redAccent : Colors.white54,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isRecording ? 'Recording…' : 'Tap to record',
            style: TextStyle(
              color: _isRecording ? Colors.redAccent : Colors.white38,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          // Big mic button
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? Colors.redAccent
                    : const Color(0xFF1E1E1E),
                border: Border.all(
                  color: _isRecording
                      ? Colors.redAccent
                      : const Color(0xFF2A2A2A),
                  width: 2,
                ),
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording ? Colors.white : Colors.white70,
                size: 28,
              ),
            ),
          ),
          const Spacer(),
          if (!_isRecording && _seconds == 0)
            const Text(
              'Recordings will be added as audio tracks',
              style: TextStyle(color: Colors.white24, fontSize: 11),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

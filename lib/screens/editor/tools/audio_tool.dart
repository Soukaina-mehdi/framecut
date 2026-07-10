import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';
import '../../../models/audio_track.dart';

class AudioTool extends ConsumerStatefulWidget {
  const AudioTool({super.key});
  @override
  ConsumerState<AudioTool> createState() => _AudioToolState();
}

class _AudioToolState extends ConsumerState<AudioTool> {
  double _volume = 1.0;
  bool _fadeIn = false;
  bool _fadeOut = false;
  final List<AudioTrack> _tracks = [];

  Future<void> _pickAudio() async {
    // file_picker integration — returns path on real device
    // Simulate adding a track for UI demonstration
    final track = AudioTrack(
      id: const Uuid().v4(),
      filePath: 'audio_${_tracks.length + 1}.mp3',
      volume: _volume,
      fadeIn: _fadeIn,
      fadeOut: _fadeOut,
      typeName: 'music',
    );
    setState(() => _tracks.add(track));
    ref.read(editorProvider.notifier).addAudioTrack(track);
  }

  Widget _buildTrackTile(AudioTrack t, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: AppTheme.accent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(t.filePath,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
          GestureDetector(
            onTap: () => setState(() => _tracks.removeAt(i)),
            child: const Icon(Icons.close, color: Colors.white38, size: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SectionHeader(title: 'Audio'),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E1E),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2A2A2A)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _pickAudio,
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Import', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          SliderRow(
            label: 'Volume',
            value: _volume,
            min: 0,
            max: 2,
            onChanged: (v) => setState(() => _volume = v),
          ),
          Row(
            children: [
              _toggleChip('Fade In', _fadeIn,
                  () => setState(() => _fadeIn = !_fadeIn)),
              const SizedBox(width: 8),
              _toggleChip('Fade Out', _fadeOut,
                  () => setState(() => _fadeOut = !_fadeOut)),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _tracks.isEmpty
                ? const Center(
                    child: Text('No audio tracks',
                        style:
                            TextStyle(color: Colors.white24, fontSize: 12)))
                : ListView.builder(
                    itemCount: _tracks.length,
                    itemBuilder: (_, i) => _buildTrackTile(_tracks[i], i),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppTheme.accent.withOpacity(0.15) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? AppTheme.accent : const Color(0xFF2A2A2A)),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? AppTheme.accent : Colors.white60,
                fontSize: 12)),
      ),
    );
  }
}

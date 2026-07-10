import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../app/theme.dart';
import '../../providers/editor_provider.dart';

class VideoPreview extends ConsumerStatefulWidget {
  const VideoPreview({super.key});

  @override
  ConsumerState<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends ConsumerState<VideoPreview> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  String? _loadedPath;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer(String path) async {
    if (_loadedPath == path) return;
    await _controller?.dispose();
    _controller = VideoPlayerController.file(File(path));
    await _controller!.initialize();
    _loadedPath = path;
    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final clip = state.selectedClip;

    if (clip != null) {
      _initPlayer(clip.path);
    }

    // Sync play/pause
    if (_initialized && _controller != null) {
      if (state.isPlaying && !_controller!.value.isPlaying) {
        _controller!.play();
      } else if (!state.isPlaying && _controller!.value.isPlaying) {
        _controller!.pause();
      }
    }

    return GestureDetector(
      onTap: () => ref.read(editorProvider.notifier).togglePlay(),
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video or placeholder
            if (_initialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              _buildPlaceholder(clip),

            // Playback overlay
            if (!state.isPlaying)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1.5),
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
              ),

            // Timeline position indicator
            Positioned(
              bottom: 8,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _formatTime(state.playheadSec),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),

            // Aspect ratio label
            Positioned(
              bottom: 8,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  state.project?.aspectRatioName ?? '9:16',
                  style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(dynamic clip) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              clip == null ? Icons.movie_outlined : Icons.hourglass_empty,
              size: 40,
              color: Colors.white24,
            ),
            const SizedBox(height: 8),
            Text(
              clip == null ? 'No clips in timeline' : 'Loading preview...',
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(double sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).floor().toString().padLeft(2, '0');
    final ms = ((sec % 1) * 10).floor().toString();
    return '$m:$s.$ms';
  }
}

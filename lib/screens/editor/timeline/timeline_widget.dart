import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/clip.dart';

class TimelineWidget extends ConsumerStatefulWidget {
  const TimelineWidget({super.key});

  @override
  ConsumerState<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends ConsumerState<TimelineWidget> {
  final ScrollController _scrollCtrl = ScrollController();
  static const double _pxPerSec = 40.0; // pixels per second at zoom 1x

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final clips = state.project?.clips ?? [];
    final zoom = state.timelineZoom;
    final ppx = _pxPerSec * zoom;
    final totalDuration = state.project?.totalDuration ?? 0;
    final totalWidth = (totalDuration * ppx) + 120;

    return Container(
      color: AppTheme.timelineBackground,
      child: Column(
        children: [
          // Time ruler + zoom
          _buildRuler(totalWidth, ppx, state.playheadSec, zoom),
          // Tracks
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollCtrl,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(
                      children: [
                        // Video track
                        _VideoTrack(clips: clips, ppx: ppx, selectedIndex: state.selectedClipIndex),
                        // Audio track indicator
                        if (state.project?.audioTracks.isNotEmpty ?? false)
                          _AudioTrackBar(ppx: ppx, totalDuration: totalDuration),
                      ],
                    ),
                  ),
                ),
                // Playhead
                _Playhead(
                  posX: state.playheadSec * ppx,
                  totalDuration: totalDuration,
                  ppx: ppx,
                  onSeek: (sec) => ref.read(editorProvider.notifier).seekTo(sec),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuler(double totalWidth, double ppx, double playheadSec, double zoom) {
    return Container(
      height: 22,
      color: const Color(0xFF0A0A0A),
      child: Stack(
        children: [
          // Ruler ticks — drawn via custom paint
          CustomPaint(
            size: Size(totalWidth, 22),
            painter: _RulerPainter(ppx: ppx),
          ),
          // Zoom controls
          Positioned(
            right: 8,
            top: 2,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => ref.read(editorProvider.notifier).setTimelineZoom(zoom - 0.5),
                  child: const Icon(Icons.remove, size: 14, color: Colors.white54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${zoom.toStringAsFixed(1)}x',
                    style: const TextStyle(fontSize: 9, color: Colors.white38),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(editorProvider.notifier).setTimelineZoom(zoom + 0.5),
                  child: const Icon(Icons.add, size: 14, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoTrack extends ConsumerWidget {
  final List<VideoClip> clips;
  final double ppx;
  final int selectedIndex;

  const _VideoTrack({required this.clips, required this.ppx, required this.selectedIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (clips.isEmpty) {
      return Container(
        height: 52,
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 12),
        child: const Text(
          'Import or add a video clip',
          style: TextStyle(color: Colors.white30, fontSize: 12),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          for (int i = 0; i < clips.length; i++)
            Positioned(
              left: clips[i].timelineStartSec * ppx,
              top: 4,
              child: _ClipBlock(
                clip: clips[i],
                ppx: ppx,
                isSelected: i == selectedIndex,
                onTap: () => ref.read(editorProvider.notifier).selectClip(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _ClipBlock extends StatelessWidget {
  final VideoClip clip;
  final double ppx;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClipBlock({required this.clip, required this.ppx, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = (clip.trimmedDuration * ppx).clamp(8.0, double.infinity);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white12 : AppTheme.timelineClip,
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF3A3A3A),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Stack(
            children: [
              if (clip.thumbnailPath != null && File(clip.thumbnailPath!).existsSync())
                Opacity(
                  opacity: 0.5,
                  child: Image.file(
                    File(clip.thumbnailPath!),
                    fit: BoxFit.cover,
                    width: width,
                    height: 52,
                  ),
                ),
              Positioned(
                bottom: 3,
                left: 4,
                right: 4,
                child: Text(
                  clip.name,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioTrackBar extends StatelessWidget {
  final double ppx;
  final double totalDuration;

  const _AudioTrackBar({required this.ppx, required this.totalDuration});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            width: totalDuration * ppx,
            height: 16,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A2A),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: const Color(0xFF2A5A3A), width: 1),
            ),
            child: const Row(
              children: [
                SizedBox(width: 4),
                Icon(Icons.music_note, size: 10, color: Color(0xFF4ADE80)),
                SizedBox(width: 3),
                Text('Audio', style: TextStyle(fontSize: 9, color: Color(0xFF4ADE80))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Playhead extends StatelessWidget {
  final double posX;
  final double totalDuration;
  final double ppx;
  final ValueChanged<double> onSeek;

  const _Playhead({
    required this.posX,
    required this.totalDuration,
    required this.ppx,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: posX,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: (d) {
          final newSec = ((posX + d.delta.dx) / ppx).clamp(0.0, totalDuration);
          onSeek(newSec);
        },
        child: SizedBox(
          width: 20,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double ppx;
  _RulerPainter({required this.ppx});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white24..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw second ticks
    double x = 0;
    int sec = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, size.height), Offset(x, size.height - (sec % 5 == 0 ? 10 : 5)), paint);
      if (sec % 5 == 0 && x > 2) {
        textPainter.text = TextSpan(
          text: '${sec}s',
          style: const TextStyle(fontSize: 8, color: Colors.white38),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x + 2, 2));
      }
      x += ppx;
      sec++;
    }
  }

  @override
  bool shouldRepaint(_RulerPainter old) => old.ppx != ppx;
}

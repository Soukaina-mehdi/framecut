import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_video_editor/pro_video_editor.dart';
import '../models/project.dart';
import '../models/clip.dart';
import '../models/export_settings.dart';
import 'ffmpeg_service.dart';

class RenderProgress {
  final double progress; // 0.0 – 1.0
  final String status;
  RenderProgress(this.progress, this.status);
}

class VideoRenderService {
  static final VideoRenderService _instance = VideoRenderService._internal();
  factory VideoRenderService() => _instance;
  VideoRenderService._internal();

  Stream<RenderProgress> renderProject({
    required Project project,
    required String outputPath,
  }) async* {
    yield RenderProgress(0.0, 'Preparing clips...');

    final segments = <VideoSegment>[];

    for (int i = 0; i < project.clips.length; i++) {
      final clip = project.clips[i];
      yield RenderProgress(
        (i / project.clips.length) * 0.3,
        'Processing clip ${i + 1}/${project.clips.length}...',
      );

      // Build transition
      ClipTransition? transition;
      if (clip.transitionType != TransitionType.none && i < project.clips.length - 1) {
        transition = _buildTransition(clip);
      }

      // Build color filters from effects
      final colorFilters = _buildColorFilters(clip);

      // Build transform
      final transform = _buildTransform(clip);

      segments.add(VideoSegment(
        video: EditorVideo.file(File(clip.path)),
        startTime: Duration(milliseconds: (clip.startTrimSec * 1000).toInt()),
        endTime: Duration(milliseconds: (clip.endTrimSec * 1000).toInt()),
        volume: clip.muted ? 0.0 : clip.volume,
        playbackSpeed: clip.playbackSpeed,
        reverseVideo: clip.reversed,
        transition: transition,
      ));
    }

    yield RenderProgress(0.3, 'Building audio tracks...');

    final audioTracks = project.audioTracks.map((t) {
      return VideoAudioTrack(path: t.path, volume: t.volume);
    }).toList();

    yield RenderProgress(0.4, 'Rendering video...');

    // Build settings from export config
    final settings = project.exportSettings;
    final size = settings.resolutionSize;

    final renderData = VideoRenderData(
      videoSegments: segments,
      audioTracks: audioTracks,
      outputFormat: settings.format == ExportFormat.mov
          ? VideoOutputFormat.mov
          : VideoOutputFormat.mp4,
      bitrate: settings.bitrate * 1000,
      maxFrameRate: settings.frameRateValue,
      enableAudio: true,
    );

    // Listen to render progress
    await for (final progress in ProVideoEditor.instance.progressStream) {
      yield RenderProgress(0.4 + progress.progress * 0.55, 'Rendering... ${(progress.progress * 100).toInt()}%');
    }

    yield RenderProgress(0.95, 'Saving file...');

    try {
      await ProVideoEditor.instance.renderVideoToFile(outputPath, renderData);
      yield RenderProgress(1.0, 'Done!');
    } catch (e) {
      yield RenderProgress(1.0, 'Render failed: $e');
    }
  }

  ClipTransition? _buildTransition(VideoClip clip) {
    final duration = Duration(milliseconds: clip.transitionDurationMs.toInt());
    switch (clip.transitionType) {
      case TransitionType.dissolve:
        return ClipTransition(type: ClipTransitionType.dissolve, duration: duration);
      case TransitionType.fadeToBlack:
        return ClipTransition(type: ClipTransitionType.fadeToBlack, duration: duration);
      case TransitionType.fadeToWhite:
        return ClipTransition(type: ClipTransitionType.fadeToWhite, duration: duration);
      case TransitionType.slideLeft:
        return ClipTransition(type: ClipTransitionType.slide, duration: duration, direction: ClipTransitionDirection.left);
      case TransitionType.slideRight:
        return ClipTransition(type: ClipTransitionType.slide, duration: duration, direction: ClipTransitionDirection.right);
      case TransitionType.wipe:
        return ClipTransition(type: ClipTransitionType.wipe, duration: duration);
      case TransitionType.push:
        return ClipTransition(type: ClipTransitionType.push, duration: duration);
      default:
        return null;
    }
  }

  List<ColorFilter> _buildColorFilters(VideoClip clip) {
    final filters = <ColorFilter>[];
    for (final effect in clip.effects) {
      final matrix = _effectToMatrix(effect.typeName, effect.params);
      if (matrix != null) {
        filters.add(ColorFilter(matrix: matrix));
      }
    }
    return filters;
  }

  List<double>? _effectToMatrix(String type, Map<String, dynamic> params) {
    switch (type) {
      case 'filter':
        return _namedFilterMatrix(params['preset'] as String? ?? 'none');
      case 'colorGrading':
        return _colorGradingMatrix(params);
      default:
        return null;
    }
  }

  List<double> _namedFilterMatrix(String preset) {
    switch (preset) {
      case 'bw':
        return [0.33,0.59,0.11,0,0, 0.33,0.59,0.11,0,0, 0.33,0.59,0.11,0,0, 0,0,0,1,0];
      case 'warm':
        return [1.1,0,0,0,15, 0,1.0,0,0,5, 0,0,0.85,0,-10, 0,0,0,1,0];
      case 'cool':
        return [0.85,0,0,0,-10, 0,1.0,0,0,5, 0,0,1.15,0,15, 0,0,0,1,0];
      case 'vivid':
        return [1.3,-0.1,-0.1,0,0, -0.1,1.3,-0.1,0,0, -0.1,-0.1,1.3,0,0, 0,0,0,1,0];
      case 'cinematic':
        return [1.1,0.05,0,0,-10, 0,0.95,0.05,0,-5, 0,0.05,1.05,0,10, 0,0,0,1,0];
      case 'fade':
        return [0.8,0,0,0,30, 0,0.8,0,0,30, 0,0,0.8,0,30, 0,0,0,1,0];
      case 'matte':
        return [0.9,0,0,0,20, 0,0.9,0,0,20, 0,0,0.85,0,25, 0,0,0,1,0];
      case 'grain': // placeholder
        return [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0];
      default:
        return [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0];
    }
  }

  List<double> _colorGradingMatrix(Map<String, dynamic> p) {
    final brightness = (p['brightness'] as double? ?? 0) * 50;
    final contrast = (p['contrast'] as double? ?? 1.0);
    final sat = (p['saturation'] as double? ?? 1.0);
    // Simplified combined matrix: contrast + brightness
    final t = (1.0 - contrast) / 2.0 * 255;
    return [
      contrast * sat, 0, 0, 0, brightness + t,
      0, contrast * sat, 0, 0, brightness + t,
      0, 0, contrast * sat, 0, brightness + t,
      0, 0, 0, 1, 0,
    ];
  }

  ExportTransform _buildTransform(VideoClip clip) {
    return ExportTransform(
      flipX: clip.flipHorizontal,
      flipY: clip.flipVertical,
      rotateTurns: (clip.rotation / 90).round() % 4,
      x: (clip.cropRect[0] * 1920).toInt().toDouble(),
      y: (clip.cropRect[1] * 1080).toInt().toDouble(),
      width: (clip.cropRect[2] * 1920).toInt().toDouble(),
      height: (clip.cropRect[3] * 1080).toInt().toDouble(),
    );
  }

  Future<List<String>> generateThumbnails(String videoPath, {int count = 5}) async {
    final info = await ProVideoEditor.instance.getMetadata(
      video: EditorVideo.file(File(videoPath)),
    );
    final duration = info.duration ?? 0;
    final step = duration ~/ (count + 1);
    final timestamps = List.generate(count, (i) => Duration(milliseconds: step * (i + 1)));

    final frames = await ProVideoEditor.instance.getThumbnails(
      ThumbnailConfigs(
        video: EditorVideo.file(File(videoPath)),
        outputFormat: ThumbnailFormat.jpeg,
        timestamps: timestamps,
        outputSize: const Size(160, 90),
        boxFit: ThumbnailBoxFit.cover,
      ),
    );
    // Save to temp files
    final dir = await getTemporaryDirectory();
    final paths = <String>[];
    for (int i = 0; i < frames.length; i++) {
      final path = '${dir.path}/thumb_${videoPath.hashCode}_$i.jpg';
      await File(path).writeAsBytes(frames[i]);
      paths.add(path);
    }
    return paths;
  }
}

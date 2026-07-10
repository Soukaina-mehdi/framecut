import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/clip.dart';
import '../models/effect.dart';
import '../models/text_overlay.dart';
import '../models/audio_track.dart';
import 'project_provider.dart';

enum ActiveTool {
  none, trim, filters, text, audio, transitions, speed, crop,
  colorGrading, stickers, voiceover, lut, hsl, curves, vignette,
  grain, chromaticAberration, glow, sharpen, dehaze, spotlight,
  colorMatch, keyframe, chromaKey, motionBlur, stabilize, reverse,
  freezeFrame, pip, splitScreen, equalizer, noiseReduction, pitch,
  beatDetection, sfx, animatedText, lowerThirds, subtitles, drawing,
  watermark, kenBurns, shake, glitch, slowMoRamp,
}

class EditorState {
  final Project? project;
  final int selectedClipIndex;
  final ActiveTool activeTool;
  final bool isPlaying;
  final double playheadSec;
  final double timelineZoom;
  final List<Project> history; // undo stack
  final List<Project> future;  // redo stack
  final bool isDirty;

  const EditorState({
    this.project,
    this.selectedClipIndex = 0,
    this.activeTool = ActiveTool.none,
    this.isPlaying = false,
    this.playheadSec = 0,
    this.timelineZoom = 1.0,
    this.history = const [],
    this.future = const [],
    this.isDirty = false,
  });

  EditorState copyWith({
    Project? project,
    int? selectedClipIndex,
    ActiveTool? activeTool,
    bool? isPlaying,
    double? playheadSec,
    double? timelineZoom,
    List<Project>? history,
    List<Project>? future,
    bool? isDirty,
  }) {
    return EditorState(
      project: project ?? this.project,
      selectedClipIndex: selectedClipIndex ?? this.selectedClipIndex,
      activeTool: activeTool ?? this.activeTool,
      isPlaying: isPlaying ?? this.isPlaying,
      playheadSec: playheadSec ?? this.playheadSec,
      timelineZoom: timelineZoom ?? this.timelineZoom,
      history: history ?? this.history,
      future: future ?? this.future,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  VideoClip? get selectedClip {
    if (project == null || project!.clips.isEmpty) return null;
    if (selectedClipIndex >= project!.clips.length) return null;
    return project!.clips[selectedClipIndex];
  }
}

class EditorNotifier extends StateNotifier<EditorState> {
  final Ref _ref;
  Timer? _autoSaveTimer;

  EditorNotifier(this._ref) : super(const EditorState());

  void loadProject(String projectId) {
    final project = _ref.read(projectsProvider.notifier).getById(projectId);
    if (project != null) {
      state = EditorState(project: project);
      _startAutoSave();
    }
  }

  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _autoSave();
    });
  }

  void _autoSave() {
    if (state.isDirty && state.project != null) {
      _ref.read(projectsProvider.notifier).updateProject(state.project!);
      state = state.copyWith(isDirty: false);
    }
  }

  // ── History (undo/redo) ──────────────────────────────────────────────────

  void _pushHistory() {
    if (state.project == null) return;
    final newHistory = [...state.history, state.project!];
    final trimmed = newHistory.length > 50 ? newHistory.sublist(newHistory.length - 50) : newHistory;
    state = state.copyWith(history: trimmed, future: [], isDirty: true);
  }

  bool get canUndo => state.history.isNotEmpty;
  bool get canRedo => state.future.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    final newHistory = List<Project>.from(state.history);
    final previous = newHistory.removeLast();
    state = state.copyWith(
      project: previous,
      history: newHistory,
      future: [...state.future, state.project!],
      isDirty: true,
    );
  }

  void redo() {
    if (!canRedo) return;
    final newFuture = List<Project>.from(state.future);
    final next = newFuture.removeLast();
    state = state.copyWith(
      project: next,
      history: [...state.history, state.project!],
      future: newFuture,
      isDirty: true,
    );
  }

  // ── Tool selection ──────────────────────────────────────────────────────

  void setActiveTool(ActiveTool tool) {
    state = state.copyWith(
      activeTool: state.activeTool == tool ? ActiveTool.none : tool,
    );
  }

  void closeTool() => state = state.copyWith(activeTool: ActiveTool.none);

  // ── Playback ────────────────────────────────────────────────────────────

  void togglePlay() => state = state.copyWith(isPlaying: !state.isPlaying);
  void pause() => state = state.copyWith(isPlaying: false);
  void seekTo(double sec) => state = state.copyWith(playheadSec: sec);

  // ── Clip operations ─────────────────────────────────────────────────────

  void selectClip(int index) => state = state.copyWith(selectedClipIndex: index);

  void addClip(VideoClip clip) {
    _pushHistory();
    final clips = [...state.project!.clips, clip];
    _updateClips(clips);
  }

  void removeClip(int index) {
    _pushHistory();
    final clips = List<VideoClip>.from(state.project!.clips)..removeAt(index);
    // Ripple edit: shift subsequent clips
    for (int i = index; i < clips.length; i++) {
      final prev = i == 0 ? 0.0 : clips[i - 1].timelineStartSec + clips[i - 1].trimmedDuration;
      clips[i].timelineStartSec = prev;
    }
    _updateClips(clips);
  }

  void reorderClip(int from, int to) {
    _pushHistory();
    final clips = List<VideoClip>.from(state.project!.clips);
    final clip = clips.removeAt(from);
    clips.insert(to, clip);
    _updateClips(clips);
  }

  void updateClip(int index, VideoClip updated) {
    _pushHistory();
    final clips = List<VideoClip>.from(state.project!.clips);
    clips[index] = updated;
    _updateClips(clips);
  }

  void splitClipAtPlayhead() {
    _pushHistory();
    final clip = state.selectedClip;
    if (clip == null) return;
    final splitSec = state.playheadSec - clip.timelineStartSec + clip.startTrimSec;
    if (splitSec <= clip.startTrimSec || splitSec >= clip.endTrimSec) return;

    final left = VideoClip(
      id: const Uuid().v4(),
      path: clip.path,
      name: clip.name,
      startTrimSec: clip.startTrimSec,
      endTrimSec: splitSec,
      durationSec: clip.durationSec,
      timelineStartSec: clip.timelineStartSec,
      playbackSpeed: clip.playbackSpeed,
    );
    final right = VideoClip(
      id: const Uuid().v4(),
      path: clip.path,
      name: clip.name,
      startTrimSec: splitSec,
      endTrimSec: clip.endTrimSec,
      durationSec: clip.durationSec,
      timelineStartSec: clip.timelineStartSec + left.trimmedDuration,
      playbackSpeed: clip.playbackSpeed,
    );

    final clips = List<VideoClip>.from(state.project!.clips);
    clips.replaceRange(state.selectedClipIndex, state.selectedClipIndex + 1, [left, right]);
    _updateClips(clips);
  }

  void addEffect(Effect effect) {
    final clip = state.selectedClip;
    if (clip == null) return;
    _pushHistory();
    final updated = VideoClip(
      id: clip.id, path: clip.path, name: clip.name,
      startTrimSec: clip.startTrimSec, endTrimSec: clip.endTrimSec,
      durationSec: clip.durationSec, timelineStartSec: clip.timelineStartSec,
      playbackSpeed: clip.playbackSpeed, effects: [...clip.effects, effect],
    );
    updateClip(state.selectedClipIndex, updated);
  }

  void addTextOverlay(TextOverlay overlay) {
    final clip = state.selectedClip;
    if (clip == null) return;
    _pushHistory();
    final updated = VideoClip(
      id: clip.id, path: clip.path, name: clip.name,
      startTrimSec: clip.startTrimSec, endTrimSec: clip.endTrimSec,
      durationSec: clip.durationSec, timelineStartSec: clip.timelineStartSec,
      playbackSpeed: clip.playbackSpeed,
      effects: clip.effects,
      textOverlays: [...clip.textOverlays, overlay],
    );
    updateClip(state.selectedClipIndex, updated);
  }

  void addAudioTrack(AudioTrack track) {
    _pushHistory();
    final tracks = [...state.project!.audioTracks, track];
    final updated = _cloneProject(audioTracks: tracks);
    state = state.copyWith(project: updated, isDirty: true);
  }

  void setTimelineZoom(double zoom) {
    state = state.copyWith(timelineZoom: zoom.clamp(0.5, 5.0));
  }

  void saveNow() {
    if (state.project != null) {
      _ref.read(projectsProvider.notifier).updateProject(state.project!);
      state = state.copyWith(isDirty: false);
    }
  }

  void _updateClips(List<VideoClip> clips) {
    final updated = _cloneProject(clips: clips);
    state = state.copyWith(project: updated, isDirty: true);
  }

  Project _cloneProject({List<VideoClip>? clips, List<AudioTrack>? audioTracks}) {
    final p = state.project!;
    return Project(
      id: p.id,
      name: p.name,
      createdAt: p.createdAt,
      updatedAt: DateTime.now(),
      clips: clips ?? p.clips,
      audioTracks: audioTracks ?? p.audioTracks,
      exportSettings: p.exportSettings,
      thumbnailPath: p.thumbnailPath,
      aspectRatioName: p.aspectRatioName,
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

final editorProvider = StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier(ref);
});

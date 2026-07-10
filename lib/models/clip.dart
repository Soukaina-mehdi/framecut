import 'package:hive/hive.dart';
import 'effect.dart';
import 'text_overlay.dart';

part 'clip.g.dart';

enum TransitionType {
  none,
  dissolve,
  fadeToBlack,
  fadeToWhite,
  slideLeft,
  slideRight,
  slideUp,
  wipe,
  push,
  zoom,
  bounce,
}

enum AspectRatio {
  original,
  ratio16x9,
  ratio9x16,
  ratio1x1,
  ratio4x3,
  ratio21x9,
}

@HiveType(typeId: 1)
class VideoClip extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String path;

  @HiveField(2)
  String name;

  @HiveField(3)
  double startTrimSec;

  @HiveField(4)
  double endTrimSec;

  @HiveField(5)
  double durationSec;

  @HiveField(6)
  double timelineStartSec;

  @HiveField(7)
  double playbackSpeed;

  @HiveField(8)
  bool reversed;

  @HiveField(9)
  double volume;

  @HiveField(10)
  bool muted;

  @HiveField(11)
  String transitionTypeName;

  @HiveField(12)
  double transitionDurationMs;

  @HiveField(13)
  List<Effect> effects;

  @HiveField(14)
  List<TextOverlay> textOverlays;

  @HiveField(15)
  // Crop: [x, y, w, h] normalized 0-1
  List<double> cropRect;

  @HiveField(16)
  double rotation;

  @HiveField(17)
  bool flipHorizontal;

  @HiveField(18)
  bool flipVertical;

  @HiveField(19)
  String aspectRatioName;

  @HiveField(20)
  String? thumbnailPath;

  @HiveField(21)
  double freezeAtSec;

  @HiveField(22)
  double freezeDurationSec;

  @HiveField(23)
  bool stabilized;

  @HiveField(24)
  // Keyframes: list of {time, x, y, scale, opacity}
  List<Map<String, dynamic>> keyframes;

  VideoClip({
    required this.id,
    required this.path,
    required this.name,
    this.startTrimSec = 0,
    required this.endTrimSec,
    required this.durationSec,
    this.timelineStartSec = 0,
    this.playbackSpeed = 1.0,
    this.reversed = false,
    this.volume = 1.0,
    this.muted = false,
    this.transitionTypeName = 'none',
    this.transitionDurationMs = 500,
    List<Effect>? effects,
    List<TextOverlay>? textOverlays,
    List<double>? cropRect,
    this.rotation = 0,
    this.flipHorizontal = false,
    this.flipVertical = false,
    this.aspectRatioName = 'original',
    this.thumbnailPath,
    this.freezeAtSec = -1,
    this.freezeDurationSec = 1,
    this.stabilized = false,
    List<Map<String, dynamic>>? keyframes,
  })  : effects = effects ?? [],
        textOverlays = textOverlays ?? [],
        cropRect = cropRect ?? [0, 0, 1, 1],
        keyframes = keyframes ?? [];

  TransitionType get transitionType => TransitionType.values.firstWhere(
        (e) => e.name == transitionTypeName,
        orElse: () => TransitionType.none,
      );

  double get trimmedDuration => (endTrimSec - startTrimSec) / playbackSpeed;
}

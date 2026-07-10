import 'package:hive/hive.dart';

part 'text_overlay.g.dart';

enum TextAnimation {
  none,
  fadeIn,
  slideInLeft,
  slideInRight,
  slideInUp,
  typewriter,
  bounce,
  glitch,
  neon,
  scale,
}

enum TextAlignment {
  left,
  center,
  right,
}

@HiveType(typeId: 3)
class TextOverlay extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  double x;

  @HiveField(3)
  double y;

  @HiveField(4)
  double fontSize;

  @HiveField(5)
  int colorValue;

  @HiveField(6)
  int backgroundColorValue;

  @HiveField(7)
  bool bold;

  @HiveField(8)
  bool italic;

  @HiveField(9)
  String fontFamily;

  @HiveField(10)
  String animationName;

  @HiveField(11)
  double startSec;

  @HiveField(12)
  double endSec;

  @HiveField(13)
  String alignmentName;

  @HiveField(14)
  double rotation;

  @HiveField(15)
  double opacity;

  TextOverlay({
    required this.id,
    required this.text,
    this.x = 0.5,
    this.y = 0.5,
    this.fontSize = 32,
    this.colorValue = 0xFFFFFFFF,
    this.backgroundColorValue = 0x00000000,
    this.bold = false,
    this.italic = false,
    this.fontFamily = 'DMSans',
    this.animationName = 'none',
    this.startSec = 0,
    this.endSec = 3,
    this.alignmentName = 'center',
    this.rotation = 0,
    this.opacity = 1.0,
  });

  TextAnimation get animation => TextAnimation.values.firstWhere(
        (e) => e.name == animationName,
        orElse: () => TextAnimation.none,
      );

  TextAlignment get alignment => TextAlignment.values.firstWhere(
        (e) => e.name == alignmentName,
        orElse: () => TextAlignment.center,
      );
}

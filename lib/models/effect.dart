import 'package:hive/hive.dart';

part 'effect.g.dart';

enum EffectType {
  filter,
  lut,
  colorGrading,
  hsl,
  curves,
  vignette,
  grain,
  chromaticAberration,
  glow,
  sharpen,
  dehaze,
  spotlight,
  motionBlur,
  stabilize,
  chromaKey,
  glitch,
  shake,
  kenBurns,
  zoom,
  pan,
  slowMoRamp,
}

@HiveType(typeId: 2)
class Effect extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String typeName;

  @HiveField(2)
  Map<String, dynamic> params;

  Effect({
    required this.id,
    required this.typeName,
    required this.params,
  });

  EffectType get type => EffectType.values.firstWhere(
        (e) => e.name == typeName,
        orElse: () => EffectType.filter,
      );
}

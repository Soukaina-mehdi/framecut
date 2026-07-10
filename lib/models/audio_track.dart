import 'package:hive/hive.dart';

part 'audio_track.g.dart';

enum AudioTrackType {
  music,
  voiceover,
  sfx,
}

@HiveType(typeId: 4)
class AudioTrack extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String path;

  @HiveField(2)
  String name;

  @HiveField(3)
  String typeName;

  @HiveField(4)
  double volume;

  @HiveField(5)
  double startSec;

  @HiveField(6)
  double endSec;

  @HiveField(7)
  bool fadeIn;

  @HiveField(8)
  bool fadeOut;

  @HiveField(9)
  double pitchSemitones;

  @HiveField(10)
  bool noiseReduced;

  @HiveField(11)
  List<double> eqBands; // 5-band EQ: bass, low-mid, mid, high-mid, treble

  AudioTrack({
    required this.id,
    required this.path,
    required this.name,
    this.typeName = 'music',
    this.volume = 1.0,
    this.startSec = 0,
    this.endSec = 0,
    this.fadeIn = false,
    this.fadeOut = false,
    this.pitchSemitones = 0,
    this.noiseReduced = false,
    List<double>? eqBands,
  }) : eqBands = eqBands ?? [0, 0, 0, 0, 0];

  AudioTrackType get type => AudioTrackType.values.firstWhere(
        (e) => e.name == typeName,
        orElse: () => AudioTrackType.music,
      );
}

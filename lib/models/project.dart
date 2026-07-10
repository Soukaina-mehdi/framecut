import 'package:hive/hive.dart';
import 'clip.dart';
import 'audio_track.dart';
import 'export_settings.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  List<VideoClip> clips;

  @HiveField(5)
  List<AudioTrack> audioTracks;

  @HiveField(6)
  ExportSettings exportSettings;

  @HiveField(7)
  String? thumbnailPath;

  @HiveField(8)
  double totalDurationSec;

  @HiveField(9)
  String aspectRatioName; // '16:9', '9:16', '1:1', '4:3'

  @HiveField(10)
  bool isTemplate;

  @HiveField(11)
  String templateCategory;

  Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    List<VideoClip>? clips,
    List<AudioTrack>? audioTracks,
    ExportSettings? exportSettings,
    this.thumbnailPath,
    this.totalDurationSec = 0,
    this.aspectRatioName = '9:16',
    this.isTemplate = false,
    this.templateCategory = '',
  })  : clips = clips ?? [],
        audioTracks = audioTracks ?? [],
        exportSettings = exportSettings ?? ExportSettings();

  double get totalDuration {
    if (clips.isEmpty) return 0;
    double total = 0;
    for (final clip in clips) {
      total += clip.trimmedDuration;
    }
    return total;
  }
}

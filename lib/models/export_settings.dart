import 'package:hive/hive.dart';

part 'export_settings.g.dart';

enum ExportResolution { p480, p720, p1080, p1080High, p4k }
enum ExportFormat { mp4, mov, gif }
enum ExportFrameRate { fps24, fps25, fps30, fps60, fps120 }
enum ExportPreset { custom, instagramReel, tiktok, youtubeShort, twitter, cinema4k }

@HiveType(typeId: 5)
class ExportSettings extends HiveObject {
  @HiveField(0)
  String resolutionName;

  @HiveField(1)
  String formatName;

  @HiveField(2)
  String frameRateName;

  @HiveField(3)
  String presetName;

  @HiveField(4)
  int bitrate; // kbps

  @HiveField(5)
  bool burnSubtitles;

  @HiveField(6)
  bool optimizeForStreaming;

  ExportSettings({
    this.resolutionName = 'p1080',
    this.formatName = 'mp4',
    this.frameRateName = 'fps30',
    this.presetName = 'custom',
    this.bitrate = 8000,
    this.burnSubtitles = false,
    this.optimizeForStreaming = true,
  });

  ExportResolution get resolution => ExportResolution.values.firstWhere(
        (e) => e.name == resolutionName,
        orElse: () => ExportResolution.p1080,
      );

  ExportFormat get format => ExportFormat.values.firstWhere(
        (e) => e.name == formatName,
        orElse: () => ExportFormat.mp4,
      );

  ExportFrameRate get frameRate => ExportFrameRate.values.firstWhere(
        (e) => e.name == frameRateName,
        orElse: () => ExportFrameRate.fps30,
      );

  int get frameRateValue {
    switch (frameRate) {
      case ExportFrameRate.fps24: return 24;
      case ExportFrameRate.fps25: return 25;
      case ExportFrameRate.fps30: return 30;
      case ExportFrameRate.fps60: return 60;
      case ExportFrameRate.fps120: return 120;
    }
  }

  Map<String, int> get resolutionSize {
    switch (resolution) {
      case ExportResolution.p480: return {'w': 854, 'h': 480};
      case ExportResolution.p720: return {'w': 1280, 'h': 720};
      case ExportResolution.p1080: return {'w': 1920, 'h': 1080};
      case ExportResolution.p1080High: return {'w': 1920, 'h': 1080};
      case ExportResolution.p4k: return {'w': 3840, 'h': 2160};
    }
  }
}

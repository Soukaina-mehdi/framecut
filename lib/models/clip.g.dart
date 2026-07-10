// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'clip.dart';

class VideoClipAdapter extends TypeAdapter<VideoClip> {
  @override
  final int typeId = 1;

  @override
  VideoClip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoClip(
      id: fields[0] as String,
      path: fields[1] as String,
      name: fields[2] as String,
      startTrimSec: fields[3] as double? ?? 0,
      endTrimSec: fields[4] as double,
      durationSec: fields[5] as double,
      timelineStartSec: fields[6] as double? ?? 0,
      playbackSpeed: fields[7] as double? ?? 1.0,
      reversed: fields[8] as bool? ?? false,
      volume: fields[9] as double? ?? 1.0,
      muted: fields[10] as bool? ?? false,
      transitionTypeName: fields[11] as String? ?? 'none',
      transitionDurationMs: fields[12] as double? ?? 500,
      effects: (fields[13] as List?)?.cast<Effect>(),
      textOverlays: (fields[14] as List?)?.cast<TextOverlay>(),
      cropRect: (fields[15] as List?)?.cast<double>(),
      rotation: fields[16] as double? ?? 0,
      flipHorizontal: fields[17] as bool? ?? false,
      flipVertical: fields[18] as bool? ?? false,
      aspectRatioName: fields[19] as String? ?? 'original',
      thumbnailPath: fields[20] as String?,
      freezeAtSec: fields[21] as double? ?? -1,
      freezeDurationSec: fields[22] as double? ?? 1,
      stabilized: fields[23] as bool? ?? false,
      keyframes: (fields[24] as List?)?.cast<Map<String, dynamic>>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoClip obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.path)
      ..writeByte(2)..write(obj.name)
      ..writeByte(3)..write(obj.startTrimSec)
      ..writeByte(4)..write(obj.endTrimSec)
      ..writeByte(5)..write(obj.durationSec)
      ..writeByte(6)..write(obj.timelineStartSec)
      ..writeByte(7)..write(obj.playbackSpeed)
      ..writeByte(8)..write(obj.reversed)
      ..writeByte(9)..write(obj.volume)
      ..writeByte(10)..write(obj.muted)
      ..writeByte(11)..write(obj.transitionTypeName)
      ..writeByte(12)..write(obj.transitionDurationMs)
      ..writeByte(13)..write(obj.effects)
      ..writeByte(14)..write(obj.textOverlays)
      ..writeByte(15)..write(obj.cropRect)
      ..writeByte(16)..write(obj.rotation)
      ..writeByte(17)..write(obj.flipHorizontal)
      ..writeByte(18)..write(obj.flipVertical)
      ..writeByte(19)..write(obj.aspectRatioName)
      ..writeByte(20)..write(obj.thumbnailPath)
      ..writeByte(21)..write(obj.freezeAtSec)
      ..writeByte(22)..write(obj.freezeDurationSec)
      ..writeByte(23)..write(obj.stabilized)
      ..writeByte(24)..write(obj.keyframes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoClipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

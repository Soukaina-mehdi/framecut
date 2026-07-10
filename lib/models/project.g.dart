// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'project.dart';

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      clips: (fields[4] as List?)?.cast<VideoClip>(),
      audioTracks: (fields[5] as List?)?.cast<AudioTrack>(),
      exportSettings: fields[6] as ExportSettings?,
      thumbnailPath: fields[7] as String?,
      totalDurationSec: fields[8] as double? ?? 0,
      aspectRatioName: fields[9] as String? ?? '9:16',
      isTemplate: fields[10] as bool? ?? false,
      templateCategory: fields[11] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.createdAt)
      ..writeByte(3)..write(obj.updatedAt)
      ..writeByte(4)..write(obj.clips)
      ..writeByte(5)..write(obj.audioTracks)
      ..writeByte(6)..write(obj.exportSettings)
      ..writeByte(7)..write(obj.thumbnailPath)
      ..writeByte(8)..write(obj.totalDurationSec)
      ..writeByte(9)..write(obj.aspectRatioName)
      ..writeByte(10)..write(obj.isTemplate)
      ..writeByte(11)..write(obj.templateCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'export_settings.dart';

class ExportSettingsAdapter extends TypeAdapter<ExportSettings> {
  @override
  final int typeId = 5;

  @override
  ExportSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExportSettings(
      resolutionName: fields[0] as String? ?? 'p1080',
      formatName: fields[1] as String? ?? 'mp4',
      frameRateName: fields[2] as String? ?? 'fps30',
      presetName: fields[3] as String? ?? 'custom',
      bitrate: fields[4] as int? ?? 8000,
      burnSubtitles: fields[5] as bool? ?? false,
      optimizeForStreaming: fields[6] as bool? ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, ExportSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)..write(obj.resolutionName)
      ..writeByte(1)..write(obj.formatName)
      ..writeByte(2)..write(obj.frameRateName)
      ..writeByte(3)..write(obj.presetName)
      ..writeByte(4)..write(obj.bitrate)
      ..writeByte(5)..write(obj.burnSubtitles)
      ..writeByte(6)..write(obj.optimizeForStreaming);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

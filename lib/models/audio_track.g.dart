// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'audio_track.dart';

class AudioTrackAdapter extends TypeAdapter<AudioTrack> {
  @override
  final int typeId = 4;

  @override
  AudioTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioTrack(
      id: fields[0] as String,
      path: fields[1] as String,
      name: fields[2] as String,
      typeName: fields[3] as String? ?? 'music',
      volume: fields[4] as double? ?? 1.0,
      startSec: fields[5] as double? ?? 0,
      endSec: fields[6] as double? ?? 0,
      fadeIn: fields[7] as bool? ?? false,
      fadeOut: fields[8] as bool? ?? false,
      pitchSemitones: fields[9] as double? ?? 0,
      noiseReduced: fields[10] as bool? ?? false,
      eqBands: (fields[11] as List?)?.cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, AudioTrack obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.path)
      ..writeByte(2)..write(obj.name)
      ..writeByte(3)..write(obj.typeName)
      ..writeByte(4)..write(obj.volume)
      ..writeByte(5)..write(obj.startSec)
      ..writeByte(6)..write(obj.endSec)
      ..writeByte(7)..write(obj.fadeIn)
      ..writeByte(8)..write(obj.fadeOut)
      ..writeByte(9)..write(obj.pitchSemitones)
      ..writeByte(10)..write(obj.noiseReduced)
      ..writeByte(11)..write(obj.eqBands);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'effect.dart';

class EffectAdapter extends TypeAdapter<Effect> {
  @override
  final int typeId = 2;

  @override
  Effect read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Effect(
      id: fields[0] as String,
      typeName: fields[1] as String,
      params: (fields[2] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Effect obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.typeName)
      ..writeByte(2)..write(obj.params);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

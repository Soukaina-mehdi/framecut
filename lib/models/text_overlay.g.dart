// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'text_overlay.dart';

class TextOverlayAdapter extends TypeAdapter<TextOverlay> {
  @override
  final int typeId = 3;

  @override
  TextOverlay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextOverlay(
      id: fields[0] as String,
      text: fields[1] as String,
      x: fields[2] as double? ?? 0.5,
      y: fields[3] as double? ?? 0.5,
      fontSize: fields[4] as double? ?? 32,
      colorValue: fields[5] as int? ?? 0xFFFFFFFF,
      backgroundColorValue: fields[6] as int? ?? 0x00000000,
      bold: fields[7] as bool? ?? false,
      italic: fields[8] as bool? ?? false,
      fontFamily: fields[9] as String? ?? 'DMSans',
      animationName: fields[10] as String? ?? 'none',
      startSec: fields[11] as double? ?? 0,
      endSec: fields[12] as double? ?? 3,
      alignmentName: fields[13] as String? ?? 'center',
      rotation: fields[14] as double? ?? 0,
      opacity: fields[15] as double? ?? 1.0,
    );
  }

  @override
  void write(BinaryWriter writer, TextOverlay obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.text)
      ..writeByte(2)..write(obj.x)
      ..writeByte(3)..write(obj.y)
      ..writeByte(4)..write(obj.fontSize)
      ..writeByte(5)..write(obj.colorValue)
      ..writeByte(6)..write(obj.backgroundColorValue)
      ..writeByte(7)..write(obj.bold)
      ..writeByte(8)..write(obj.italic)
      ..writeByte(9)..write(obj.fontFamily)
      ..writeByte(10)..write(obj.animationName)
      ..writeByte(11)..write(obj.startSec)
      ..writeByte(12)..write(obj.endSec)
      ..writeByte(13)..write(obj.alignmentName)
      ..writeByte(14)..write(obj.rotation)
      ..writeByte(15)..write(obj.opacity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextOverlayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

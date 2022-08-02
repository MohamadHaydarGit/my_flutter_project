// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clicked_button.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClickedButtonAdapter extends TypeAdapter<ClickedButton> {
  @override
  final int typeId = 5;

  @override
  ClickedButton read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClickedButton(
      clicked: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ClickedButton obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.clicked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClickedButtonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

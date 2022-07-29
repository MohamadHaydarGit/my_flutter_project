// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lastUpdate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LastUpdateAdapter extends TypeAdapter<LastUpdate> {
  @override
  final int typeId = 3;

  @override
  LastUpdate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastUpdate(
      name: fields[0] as String,
      time: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LastUpdate obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastUpdateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

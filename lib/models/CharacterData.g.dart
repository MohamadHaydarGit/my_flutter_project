// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CharacterData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterDataAdapter extends TypeAdapter<CharacterData> {
  @override
  final int typeId = 0;

  @override
  CharacterData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterData(
      name: fields[0] as String,
      imageUrl: fields[1] as String,
      localImagePath: fields[2] as String,
      bodyImage: fields[3] as String,
      order: fields[5] as int,
      details: (fields[4] as Map).cast<dynamic, dynamic>(),
      selected: fields[6] as bool,
      docID: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.localImagePath)
      ..writeByte(3)
      ..write(obj.bodyImage)
      ..writeByte(4)
      ..write(obj.details)
      ..writeByte(5)
      ..write(obj.order)
      ..writeByte(6)
      ..write(obj.selected)
      ..writeByte(7)
      ..write(obj.docID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userLikes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLikesAdapter extends TypeAdapter<UserLikes> {
  @override
  final int typeId = 4;

  @override
  UserLikes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLikes(
      characterId: fields[0] as String,
      userId: fields[1] as String,
      favorite: fields[2] as bool,
      docID: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserLikes obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.characterId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.favorite)
      ..writeByte(3)
      ..write(obj.docID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLikesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

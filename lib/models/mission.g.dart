// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MissionAdapter extends TypeAdapter<Mission> {
  @override
  final int typeId = 2;

  @override
  Mission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mission(
      city_id: fields[0] as String,
      character_id: fields[1] as String,
      missionId: fields[2] as String?,
      endDate: fields[3] as DateTime,
      successfulMissions: fields[4] as int,
      cancelledMissions: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Mission obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.city_id)
      ..writeByte(1)
      ..write(obj.character_id)
      ..writeByte(2)
      ..write(obj.missionId)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.successfulMissions)
      ..writeByte(5)
      ..write(obj.cancelledMissions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

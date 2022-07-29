// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CityAdapter extends TypeAdapter<City> {
  @override
  final int typeId = 1;

  @override
  City read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return City(
      adminName: fields[0] as String,
      cityName: fields[1] as String,
      country: fields[2] as String,
      lat: fields[3] as double,
      lng: fields[4] as double,
      population: fields[5] as int,
      docID: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, City obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.adminName)
      ..writeByte(1)
      ..write(obj.cityName)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lng)
      ..writeByte(5)
      ..write(obj.population)
      ..writeByte(6)
      ..write(obj.docID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

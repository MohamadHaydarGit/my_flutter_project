
import 'package:hive/hive.dart';
part 'city.g.dart';

@HiveType(typeId: 1)
class City{
  @HiveField(0)
  late String adminName;
  @HiveField(1)
  late String cityName;
  @HiveField(2)
  late String country;
  @HiveField(3)
  late double lat;
  @HiveField(4)
  late double lng;
  @HiveField(5)
  late int population;
  @HiveField(6)
  late String docID;

  City({required this.adminName,required this.cityName,required this.country,required this.lat,required this.lng, required this.population,required this.docID});
}
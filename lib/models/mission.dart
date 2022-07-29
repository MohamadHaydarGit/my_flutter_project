import 'package:hive/hive.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
part 'mission.g.dart';

@HiveType(typeId: 2)
class Mission extends HiveObject  {
  @HiveField(0)
  late String city_id;
  @HiveField(1)
  late String character_id;
  @HiveField(2)
  late String? missionId;
  @HiveField(3)
  late DateTime endDate;
  @HiveField(4)
  late int successfulMissions;
  @HiveField(5)
  late int cancelledMissions;

  Mission({required this.city_id, required this.character_id, required this.missionId, required this.endDate, required this.successfulMissions, required this.cancelledMissions});
}
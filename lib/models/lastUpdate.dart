
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'lastUpdate.g.dart';

@HiveType(typeId: 3)
class LastUpdate extends HiveObject{
  @HiveField(0)
  late String name;
  @HiveField(1)
  late DateTime time;

  LastUpdate({required this.name,required this.time});


}
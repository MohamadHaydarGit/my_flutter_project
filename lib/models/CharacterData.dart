import 'dart:convert';
import 'package:hive/hive.dart';
part 'CharacterData.g.dart';

@HiveType(typeId: 0)
class CharacterData extends HiveObject{
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String imageUrl;
  @HiveField(2)
  late String localImagePath;
  @HiveField(3)
  late String bodyImage;
  @HiveField(4)
  late Map details;
  @HiveField(5)
  late int order;
  @HiveField(6)
  late bool selected;
  @HiveField(7)
  late String docID;


  CharacterData({required this.name, required this.imageUrl, required this.localImagePath, required this.bodyImage,required this.order,required this.details,required this.selected,required this.docID}) ;


  // factory CharacterData.fromJson(Map<String, dynamic> jsonData) {
  //   return CharacterData(
  //     name: jsonData['name'],
  //     imageUrl: jsonData['imageUrl'],
  //     localImagePath: jsonData['localImagePath'],
  //     bodyImage: jsonData['bodyImage'],
  //     selected: jsonData['selected'],
  //     details: jsonData['details'],
  //     order: jsonData['order'],
  //     docID: jsonData['docID'],
  //   );
  // }
  //
  // static Map<String, dynamic> toMap(CharacterData characterData) => {
  //   'name': characterData.name,
  //   'imageUrl': characterData.imageUrl,
  //   'localImagePath': characterData.localImagePath,
  //   'bodyImage': characterData.bodyImage,
  //   'details': characterData.details,
  //   'order': characterData.order,
  //   'selected':characterData.selected,
  //   'docID': characterData.docID,
  // };
  //
  // static String encode(List<CharacterData> charactersList) => json.encode(
  //   charactersList
  //       .map<Map<String, dynamic>>((characterData) => CharacterData.toMap(characterData))
  //       .toList(),
  // );
  //
  // static List<CharacterData> decode(String charactersList) =>
  //     (json.decode(charactersList) as List<dynamic>)
  //         .map<CharacterData>((item) => CharacterData.fromJson(item))
  //         .toList();

}
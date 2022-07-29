import 'package:hive/hive.dart';
part 'userLikes.g.dart';

@HiveType(typeId: 4)
class UserLikes extends HiveObject{
  @HiveField(0)
  late String characterId;
  @HiveField(1)
  late String userId;
  @HiveField(2)
  late bool favorite;
  @HiveField(3)
  late String docID;

  UserLikes({required this.characterId, required this.userId, required this.favorite, required this.docID});


}






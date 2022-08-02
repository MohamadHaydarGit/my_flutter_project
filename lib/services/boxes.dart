import 'package:hive/hive.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:turtle_ninja/models/city.dart';
import 'package:turtle_ninja/models/clicked_button.dart';
import 'package:turtle_ninja/models/lastUpdate.dart';
import 'package:turtle_ninja/models/userLikes.dart';

import '../models/mission.dart';

class Boxes{
  static Box<CharacterData> getCharacterData() =>
      Hive.box<CharacterData>('characterData');

  static Box<City> getCities() =>
      Hive.box<City>('cities');

  static Box<Mission> getMissions() =>
      Hive.box<Mission>('M');

  static Box<LastUpdate> getLastUpdates() =>
      Hive.box<LastUpdate>('lastUpdate');

  static Box<UserLikes> getUserLikes() =>
      Hive.box<UserLikes>('userLikes');

  static Box<ClickedButton> getClick() =>
      Hive.box<ClickedButton>('clickedButton');

}
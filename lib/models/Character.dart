

import 'package:turtle_ninja/models/CharacterData.dart';


class Selected_Character{
  static final Selected_Character _singleton = Selected_Character._internal();
  CharacterData selectedCh=CharacterData(name: 'n', imageUrl: 'i', localImagePath: 'l', bodyImage: 'b', order: 1, details: {},selected: false ,docID: 'd');

  factory Selected_Character() {

    return _singleton;
  }

  Selected_Character._internal();
}
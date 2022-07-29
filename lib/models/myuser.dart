import 'dart:convert';

import 'package:turtle_ninja/models/enums.dart';

class MyUser{

  late final String uid;
  MyUser({required this.uid});

}

class UserSettings{
  late double volume;
  late int option;
  late String shape;
  late String sort;

  UserSettings({required this.volume, required this.option, required this.shape,required this.sort});


  factory UserSettings.fromJson(Map<String, dynamic> jsonData) {
    return UserSettings(
      volume: jsonData['volume'],
      option: jsonData['option'],
      shape: jsonData['shape'],
      sort: jsonData['sort'],
    );
  }

  static Map<String, dynamic> toMap(UserSettings userSettings) => {
    'volume': userSettings.volume,
    'option': userSettings.option,
    'shape': userSettings.shape,
    'sort': userSettings.sort,
  };

  static String encode(UserSettings userSettings) => json.encode(
          UserSettings.toMap(userSettings),
  );

  static UserSettings decode(String userSettings) {
    Map<String, dynamic> m= json.decode(userSettings);
    return UserSettings.fromJson(m);
  }
}

class SettingsConf{
  late double volume;
  late Option option;
  late Shape shape;

  SettingsConf({required this.volume, required this.option, required this.shape});
}
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:turtle_ninja/models/lastUpdate.dart';
import 'package:turtle_ninja/shared/loader.dart';
import '../helpers/dialogHelper.dart';
import '../models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/myuser.dart';
import '../services/boxes.dart';
import '../services/database.dart';

class Loading extends StatefulWidget {
  late bool notAuth;
  late bool registered;
  late bool biometric;
  Loading({required this.notAuth,required this.registered, required this.biometric});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {


Map settings={};
  Future<void> setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? date = prefs.getString('update_date');
    date ??= DateTime.now().toUtc().toIso8601String();
    DateTime dateTime = DateTime.parse(date).toLocal();
    int currentDay = DateTime.now().day;
    if(widget.registered == true){
     await GetIt.I.get<DataBaseService>().updateUserSettingsData(0.5,1,"circle","order");
     await GetIt.I.get<DataBaseService>().newUser();
    }

    if(widget.notAuth == true || widget.registered==true || widget.biometric==true){
      await GetIt.I.get<DataBaseService>().UpdateData();
    }
    else if (dateTime.day != currentDay) {
      await GetIt.I.get<DataBaseService>().UpdateData();
    }

    DateTime LastCharacterUpdate = await GetIt.I.get<DataBaseService>().getCharactersLastUpdate();
    DateTime LastCitiesUpdate = await GetIt.I.get<DataBaseService>().getCitiesLastUpdate();

    final timeBox = Boxes.getLastUpdates();
    print(timeBox.values.toList());
    LastUpdate storedChTime= timeBox.values.where((c) => c.name=="characters").first;
    LastUpdate storedCtTime= timeBox.values.where((c) => c.name=="cities").first;

    if(storedChTime.time.isBefore(LastCharacterUpdate)){
      await  GetIt.I.get<DataBaseService>().updateCharacterData();
    }

    if(storedCtTime.time.isBefore(LastCitiesUpdate)){
      await  GetIt.I.get<DataBaseService>().updateCities();
    }





    String? userSettingsString = prefs.getString('user_settings_key');
    UserSettings userSettings = UserSettings.decode(userSettingsString!);

      if (userSettings.option == 1) {
        settings['selectedOption'] = Option.ONE;
      }
      else if (userSettings.option == 4) {
        settings['selectedOption'] = Option.FOUR;
      }
      else if (userSettings.option == 6) {
        settings['selectedOption'] = Option.SIX;
      }
      else {
        settings['selectedOption'] = Option.ONE;
      }

      if (userSettings.shape == "circle") {
        settings['selectedShape'] = Shape.CIRCLE;
      }
      else if (userSettings.shape == "square") {
        settings['selectedShape'] = Shape.SQUARE;
      }

      else {
        settings['selectedShape'] = Shape.CIRCLE;
      }
      if (userSettings.volume == null) {
        settings['selectedVolume'] = 1;
      }
      else {
        settings['selectedVolume'] = userSettings.volume;
      }
      if(userSettings.sort == 'order') {
        settings['sort'] = Sort.ORDER;
      }
      else if (userSettings.sort == 'alphabetical'){
        settings['sort'] = Sort.ALPHABETICAL;
      }
      else if (userSettings.sort == 'cities'){
        settings['sort'] = Sort.CITIES;
      }
      else if (userSettings.sort == 'favorites'){
        settings['sort'] = Sort.FAVORITES;
      }
      else{
        settings['sort'] = Sort.ORDER;
      }

      //final String? charactersString = await prefs.getString('characters_list_key');

      // final List<CharacterData> charactersList = CharacterData.decode(charactersString!);
      //
      // settings['characters']=charactersList;


      //print("Settings :"+settings['characters']);

      Navigator.pushReplacementNamed(context, '/home', arguments: settings);

  }

  late String? uid;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uid=Provider.of<MyUser?>(context)?.uid;
    GetIt.I.get<DataBaseService>().uid=uid!;

    setPreferences();

    return Loader();
  }



}


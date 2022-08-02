import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:turtle_ninja/models/lastUpdate.dart';
import 'package:turtle_ninja/pages/home/homePage.dart';
import 'package:turtle_ninja/shared/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mission.dart';
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




      //final String? charactersString = await prefs.getString('characters_list_key');

      // final List<CharacterData> charactersList = CharacterData.decode(charactersString!);
      //
      // settings['characters']=charactersList;


      //print("Settings :"+settings['characters']);

    List<Mission> missionsList = Boxes.getMissions().values.toList().cast<Mission>();
    DateTime currentTime = DateTime.now();

    missionsList.forEach((mission) async {
      if(currentTime.isAfter(mission.endDate) && mission.city_id != 'DefaultLocation'){
        await GetIt.I.get<DataBaseService>().missionEnd(
            mission, Boxes.getCharacterData().get(mission.character_id)!);
      }
      else if(currentTime.isBefore(mission.endDate)){
        Future.delayed(Duration(seconds: daysBetween(currentTime,mission.endDate)),() async {
          await GetIt.I.get<DataBaseService>().missionEnd(
              mission, Boxes.getCharacterData().get(mission.character_id)!);

        });

      }
    });



      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NinjaCard()));

  }

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(
      from.year, from.month, from.day, from.hour, from.minute, from.second);
  to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
  return to.difference(from).inSeconds;
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


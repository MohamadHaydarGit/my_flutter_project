import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtle_ninja/drawer/drawer.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_ninja/player/player.dart';
import 'package:turtle_ninja/services/firebaseDynamicLink.dart';
import 'package:turtle_ninja/services/localNotificationService.dart';
import '../../connection/connectionStatusSingleton.dart';
import '../../models/enums.dart';
import '../../models/myuser.dart';
import '../../services/auth.dart';
import '../../services/boxes.dart';
import '../../services/database.dart';
import '../../shared/loader.dart';
import '../../shared/tmntLogo.dart';
import '../settingsPage.dart';
import 'character_pageview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class NinjaCard extends StatefulWidget {
  NinjaCard({Key? key}) : super(key:key);
  @override
  State<NinjaCard> createState() => NinjaCardState();
}

class NinjaCardState extends State<NinjaCard> {

  Map settings = {};

  bool hasInternet = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);


    FireBaseDynamicLinkService.initDynamicLink(context);

    ///gives you the message on which user taps and open the app
    ///from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message){
      if(message != null){
        final routeFormMessage = message.data["route"];
        print(routeFormMessage);
      }

    });

    ///foregroud work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification !=null){
        print(message.notification!.body);
        print(message.notification!.title);

      }

      LocalNotificationService.display(message);

    });

    ///when the app is in backgroud and opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFormMessage = message.data["route"];
      print(routeFormMessage);


    });



    Player.player.setAsset('assets/Teenage Mutant Ninja Turtles Theme.mp3');
    Player.player.setLoopMode(LoopMode.one);
    Player.player.play();

  }


  final DataBaseService databaseService = GetIt.I.get<DataBaseService>();
  final AuthService _auth = GetIt.I.get<AuthService>();

  @override
  Widget build(BuildContext context) {

      // return StreamProvider<List<CharacterData>?>.value(
      //   initialData: null,
      //   value: databaseService.characters,
       /*  child:*/return Scaffold(
          drawer: MyDrawer(),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [
             // Text(GetIt.I.get<DataBaseService>().uid),


              // TextButton.icon(
              //   onPressed: () async {
              //     dynamic result = await Navigator.push(context, PageTransition(
              //         child: Settings(data: settings,player:player),
              //         type: PageTransitionType.rightToLeft,
              //         childCurrent:widget,
              //         duration: Duration(milliseconds: 600),
              //         reverseDuration: Duration(milliseconds: 600),
              //
              //     ));
              //     setState(() {
              //       settings = {
              //         'selectedOption': result['selectedOption'],
              //         'selectedShape': result['selectedShape'],
              //         'selectedVolume': result['selectedVolume'],
              //         'sort':result['sort'],
              //       };
              //     });
              //   },
              //   icon: Icon(
              //     Icons.settings,
              //     color: Colors.white,
              //     size: 90.h,
              //   ),
              //   label: Text(
              //     '',
              //   ),
              // ),
            ],
            title: Logo(),
            centerTitle: true,
            backgroundColor: Colors.green[800],
            elevation: 0.0.h,
          ),
          body:FutureBuilder<void>(
            future: getSettings(),
            builder:(
                BuildContext context,
                AsyncSnapshot<void> snapshot,
            ) {
              if(snapshot.connectionState == ConnectionState.done)
            return  CharacterList(settings);
              else{
                return Scaffold();
              }
            }
// other arguments
          ),

        );

    }

    Future<void> getSettings() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userSettingsString = await prefs.getString('user_settings_key');
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
      Player.player.setVolume(settings['selectedVolume']);

    }

  }


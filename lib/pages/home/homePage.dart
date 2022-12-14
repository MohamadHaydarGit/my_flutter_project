import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  State<NinjaCard> createState() => _NinjaCardState();
}

class _NinjaCardState extends State<NinjaCard> {
  final player = AudioPlayer();
  Map settings = {};

  bool hasInternet = false;

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



    player.setAsset('assets/Teenage Mutant Ninja Turtles Theme.mp3');
    player.setLoopMode(LoopMode.one);
    player.play();

  }


  final DataBaseService databaseService = GetIt.I.get<DataBaseService>();
  final AuthService _auth = GetIt.I.get<AuthService>();

  @override
  Widget build(BuildContext context) {

        Text(GetIt.I.get<DataBaseService>().uid);
      settings = settings.isNotEmpty ? settings : ModalRoute.of(context)!.settings.arguments as Map;
      player.setVolume(settings['selectedVolume']);


      // return StreamProvider<List<CharacterData>?>.value(
      //   initialData: null,
      //   value: databaseService.characters,
       /*  child:*/return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () async {
                SharedPreferences preferences = await SharedPreferences.getInstance();
                Boxes.getCities().deleteAll(Boxes.getCities().keys);
                Boxes.getCharacterData().deleteAll(Boxes.getCharacterData().keys);
                Boxes.getMissions().deleteAll(Boxes.getMissions().keys);
                Boxes.getUserLikes().deleteAll(Boxes.getUserLikes().keys);
                //Boxes.getLastUpdates().deleteAll(Boxes.getLastUpdates().keys);
                await preferences.clear();
                player.stop();
                await _auth.signOut();
                Navigator.pushReplacementNamed(context,'/');

              },
              icon: Icon(
                Icons.logout,
                size: 90.h,
              ),
              label: Text(
                '',
              ),
            ),
            actions: [
             // Text(GetIt.I.get<DataBaseService>().uid),


              TextButton.icon(
                onPressed: () async {
                  dynamic result = await Navigator.push(context, PageTransition(
                      child: Settings(data: settings,player:player),
                      type: PageTransitionType.rightToLeft,
                      childCurrent:widget,
                      duration: Duration(milliseconds: 600),
                      reverseDuration: Duration(milliseconds: 600),

                  ));
                  setState(() {
                    settings = {
                      'selectedOption': result['selectedOption'],
                      'selectedShape': result['selectedShape'],
                      'selectedVolume': result['selectedVolume'],
                      'sort':result['sort'],
                    };
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 90.h,
                ),
                label: Text(
                  '',
                ),
              ),
            ],
            title: Logo(),
            centerTitle: true,
            backgroundColor: Colors.green[800],
            elevation: 0.0.h,
          ),
          body: CharacterList(settings),

        );

    }

  }


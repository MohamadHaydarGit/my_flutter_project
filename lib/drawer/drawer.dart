import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtle_ninja/pages/board/board.dart';
import 'package:turtle_ninja/pages/home/homePage.dart';
import 'package:turtle_ninja/pages/settingsPage.dart';

import '../pages/map/homeMap.dart';
import '../player/player.dart';
import '../services/auth.dart';
import '../services/boxes.dart';

class MyDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          padding: padding,
          children: <Widget>[
            SizedBox(height: 200.h,),
            buildMenuItem(
              text: "Home",
              icon: Icons.home,
              onclicked: () => selectedItem(context,0),
            ),
            SizedBox(height: 70.h,),
            buildMenuItem(
              text: "Map",
              icon: Icons.map,
              onclicked: ()=>selectedItem(context, 1),
            ),
            SizedBox(height: 70.h,),
            buildMenuItem(
              text: "LeaderBoard",
              icon: Icons.leaderboard,
              onclicked: ()=>selectedItem(context, 2),
            ),

            SizedBox(height: 70.h,),
            Divider(),
            SizedBox(height: 70.h,),

            buildMenuItem(text: "settings", icon: Icons.settings,onclicked: ()=>selectedItem(context, 3)),

            SizedBox(height: 70.h,),

            buildMenuItem(text: "Logout", icon: Icons.logout,onclicked: ()async=>selectedItem(context, 4)),



          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onclicked,
}) {
    final color = Colors.green[800];

    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(text, style: TextStyle(color: color),),
      onTap: onclicked

    );

  }

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();
    switch(index){
      case 0:

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NinjaCard()));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeMap()));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Board()));
        break;
      case 3:
         Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings()));

        break;
      case 4:{
            SharedPreferences preferences = await SharedPreferences.getInstance();
            Boxes.getCities().deleteAll(Boxes.getCities().keys);
            Boxes.getCharacterData().deleteAll(Boxes.getCharacterData().keys);
            Boxes.getMissions().deleteAll(Boxes.getMissions().keys);
            Boxes.getUserLikes().deleteAll(Boxes.getUserLikes().keys);
            //Boxes.getLastUpdates().deleteAll(Boxes.getLastUpdates().keys);
            await preferences.clear();
            Player.player.stop();
            await  GetIt.I.get<AuthService>().signOut();
            Navigator.pushReplacementNamed(context,'/');
      };


    }
  }

}

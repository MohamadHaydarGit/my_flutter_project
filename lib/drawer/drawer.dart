import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turtle_ninja/pages/home/homePage.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          padding: padding,
          children: <Widget>[
            SizedBox(height: 96.h,),
            buildMenuItem(
              text: "Home",
              icon: Icons.home,
              onclicked: () => selectedItem(context,0),
            ),
            SizedBox(height: 96.h,),
            buildMenuItem(
              text: "Map",
              icon: Icons.map,
            ),
            SizedBox(height: 96.h,),
            buildMenuItem(
              text: "LeaderBoard",
              icon: Icons.leaderboard,
            ),
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

  void selectedItem(BuildContext context, int index){
    switch(index){
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NinjaCard()));
        break;
    }
  }

}

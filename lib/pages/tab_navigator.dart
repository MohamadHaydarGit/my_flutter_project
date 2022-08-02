import 'package:flutter/material.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:turtle_ninja/pages/board/board.dart';
import 'package:turtle_ninja/pages/home/homePage.dart';
import 'package:turtle_ninja/pages/map/HomeMap.dart';
import 'package:turtle_ninja/pages/map/map.dart';
import 'package:turtle_ninja/services/boxes.dart';

import '../models/tab_item.dart';

class TabNavigatorRoutes {
  static const String homepage = '/homepage';
  static const String detail = '/homepage/detail';
  static const String settings = '/homepage/settings';
  static const String map = '/map';
  static const String board = '/board';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey,required this.keyHomePage, required this.keyBoard, required this.keyHomeMap ,required this.tabItem, required this.data,});
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<HomeMapState>? keyHomeMap;
  final GlobalKey<NinjaCardState>? keyHomePage;
  final GlobalKey<BoardState>? keyBoard;
  final TabItem tabItem;
  Map data={};

  @override
  Widget build(BuildContext context) {
    Widget child ;
    if(tabItem == TabItem.home)
      child = NinjaCard(settings: data,);
    else if(tabItem == TabItem.map)
      child = HomeMap(key: keyHomeMap,);
    else if(tabItem == TabItem.board)
      child = Board(key: keyBoard,);
    else
      child = NinjaCard(settings: data);

    return Navigator(
      observers: [
        HeroController(),
      ],
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child
        );
      },
    );
  }
}
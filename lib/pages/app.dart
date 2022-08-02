import 'package:flutter/material.dart';
import 'package:turtle_ninja/pages/home/bottomNavigation.dart';
import 'package:turtle_ninja/models/tab_item.dart';
import 'package:turtle_ninja/pages/home/homePage.dart';
import 'package:turtle_ninja/pages/map/HomeMap.dart';
import 'package:turtle_ninja/pages/tab_navigator.dart';

import 'board/board.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  var _currentTab = TabItem.home;
  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.map: GlobalKey<NavigatorState>(),
    TabItem.board: GlobalKey<NavigatorState>(),
  };
  final keyHomePage = GlobalKey<NinjaCardState>();
  final keyHomeMap = GlobalKey<HomeMapState>();
  final keyBoard = GlobalKey<BoardState>();

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      if(tabItem == TabItem.map){
        keyHomeMap.currentState!.setState(() {});
      }
      if(tabItem == TabItem.board){
        keyBoard.currentState!.setState(() {});
      }
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);

    } else {

      setState(() {
        _currentTab = tabItem;
      });

    }
  }
  Map settings={};

  @override
  Widget build(BuildContext context) {
    settings = settings.isNotEmpty ? settings : ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.home) {
            // select 'main' tab
            _selectTab(TabItem.home);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.map),
          _buildOffstageNavigator(TabItem.board),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
        keyBoard: keyBoard,
        keyHomeMap: keyHomeMap,
        keyHomePage: keyHomePage,
        data:settings,
      ),
    );
  }
}
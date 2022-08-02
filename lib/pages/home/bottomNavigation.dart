import 'package:flutter/material.dart';

import '../../models/tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey,

      currentIndex: currentTab.index,

      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.home),
        _buildItem(TabItem.map),
        _buildItem(TabItem.board),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    if(tabItem == TabItem.home) {
      return BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          color: _colorTabMatching(tabItem),
        ),
        label: tabName[tabItem],
      );
    }
    else if(tabItem == TabItem.map){
      return BottomNavigationBarItem(
        icon: Icon(
          Icons.map,
          color: _colorTabMatching(tabItem),
        ),
        label: tabName[tabItem],
      );
    }
    else{
      return BottomNavigationBarItem(

        icon: Icon(
          Icons.leaderboard,
          color: _colorTabMatching(tabItem),
        ),
        label: tabName[tabItem],
      );
    }
  }

  Color? _colorTabMatching(TabItem item) {
    return currentTab == item ? activeTabColor[item] : Colors.grey;
  }
}
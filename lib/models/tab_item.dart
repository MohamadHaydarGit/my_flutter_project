
import 'package:flutter/material.dart';

enum TabItem { home, map, board }

const Map<TabItem, String> tabName = {
  TabItem.home: 'home',
  TabItem.map: 'map',
  TabItem.board: 'board',
};

  Map<TabItem,Color?> activeTabColor = {
  TabItem.home: Colors.green[800],
  TabItem.map:  Colors.green[800],
  TabItem.board: Colors.green[800],
};
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/view/route/dataRoute.dart';
import 'package:xiaoming/src/view/route/homeRoute.dart';

final Widget myTabScaffold = CupertinoTabScaffold(
    tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        title: Text("Home"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.save),
        title: Text("Saved"),
      ),
    ]),
    tabBuilder: (BuildContext context, int index) {
      switch (index) {
        case 0:
          return CupertinoTabView(builder: (BuildContext context) {
            return HomeRoute();
          });
          break;
        case 1:
          return CupertinoTabView(builder: (BuildContext context) {
            return DataRoute();
          });
      }
    });
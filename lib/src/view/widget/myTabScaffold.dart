import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/dataRoute.dart';
import 'package:xiaoming/src/view/route/functionsRoute.dart';
import 'package:xiaoming/src/view/route/homeRoute.dart';

class MyTabScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        switch (UserData.nowPage) {
          case 0:
            bool isPop = false;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text(XiaomingLocalizations.of(context).outApp),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text(XiaomingLocalizations.of(context).quit),
                        onPressed: () {
                          isPop = true;
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Text(XiaomingLocalizations.of(context).cancel),
                        onPressed: () {
                          isPop = false;
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
            return isPop;
            break;
          case 1:
            UserData.nowPage = 0;
            Navigator.pop(UserData.pageContext);
            return false;
            break;
          case 2:
            Navigator.pop(UserData.pageContext);
            return false;
            break;
          case 3:
            UserData.nowPage = 0;
            Navigator.pop(UserData.pageContext);
            return false;
            break;
        }
      },
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text("Functions"),
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
                  return NewFunctionsRoute();
                });
              case 2:
                return CupertinoTabView(builder: (BuildContext context) {
                  return NewDataRoute();
                });
            }
          }),
    );
  }
}

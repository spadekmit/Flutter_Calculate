import 'package:flutter/material.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/dataRoute.dart';
import 'package:xiaoming/src/view/route/equationRoute.dart';
import 'package:xiaoming/src/view/route/methodRoute.dart';
import 'package:xiaoming/src/view/route/settingRoute.dart';

Widget buildDrawer({@required BuildContext context}) {
  return new Drawer(
    child: new ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: new Center(
              child: new Text(
                'K',
                style: TextStyle(fontSize: 35.0, fontStyle: FontStyle.italic),
              ),
            )),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(XiaomingLocalizations.of(context).setting),
          onTap: () => settingRoute(context),
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text(XiaomingLocalizations.of(context).savedFunction),
          onTap: () => popMethodRoute(context),
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text(XiaomingLocalizations.of(context).savedData),
          onTap: () => popdataRoute(context),
        ),
        ListTile(
          leading: Icon(Icons.extension),
          title: Text(XiaomingLocalizations.of(context).solveEquation),
          onTap: () => popEquationsRoute(context),
        ),
      ],
    ),
  );
}

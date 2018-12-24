import 'package:flutter/material.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/helpRoute.dart';

Widget buildMainAppBar({@required BuildContext context}) {
  return new AppBar(
    elevation: 1.0,
    title: new Text(XiaomingLocalizations.of(context).appName),
    actions: <Widget>[
      new IconButton(
        icon: new Icon(Icons.help),
        onPressed: () => pophelpRoute(context),
      ),
    ],
  );
}

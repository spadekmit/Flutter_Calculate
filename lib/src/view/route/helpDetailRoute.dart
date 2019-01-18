import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void popHelpDetailRoute(BuildContext context){
  Navigator.of(context).push(CupertinoPageRoute<void>(builder: (BuildContext context){
    return HelpDetailRoute();
  }));
}

class HelpDetailRoute extends StatefulWidget {
  @override
  _HelpDetailRouteState createState() => _HelpDetailRouteState();
}

class _HelpDetailRouteState extends State<HelpDetailRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("helpView",)),
    );
  }
}
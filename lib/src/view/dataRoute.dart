import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///保存的数据界面
void popdataRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    List<Card> tiles = <Card>[];
    if (UserData.matrixs.isNotEmpty) {
      UserData.matrixs.forEach((name, list) => tiles.add(new Card(
            color: Colors.cyan,
            child: new ListTile(
              title: new Text(name),
              subtitle: new Text(MatrixUtil.mtoString(list: list)),
            ),
          )));
    }
    if (UserData.dbs.isNotEmpty) {
      UserData.dbs.forEach((name, value) => tiles.add(new Card(
            color: Colors.green,
            child: new ListTile(
              title: new Text(name),
              subtitle: new Text(value.toString()),
            ),
          )));
    }
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles.reversed,
    ).toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(XiaomingLocalizations.of(context).saved_Data),
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

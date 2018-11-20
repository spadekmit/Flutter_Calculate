import 'package:flutter/material.dart';
import 'package:xiaoming/command/Matrix.dart';
import 'package:xiaoming/data/data.dart';
import 'package:xiaoming/language/xiaomingLocalizations.dart';

///保存的数据界面
void dataRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    List<Card> tiles = <Card>[];
    if (matrixs.isNotEmpty) {
      matrixs.forEach((name, list) => tiles.add(new Card(
            color: Colors.cyan,
            child: new ListTile(
              leading: new Text(name),
              title: new Text(mtoString(list: list)),
            ),
          )));
    }
    if (dbs.isNotEmpty) {
      dbs.forEach((name, value) => tiles.add(new Card(
            color: Colors.green,
            child: new ListTile(
              leading: new Text(name),
              title: new Text(value.toString()),
            ),
          )));
    }
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles.reversed,
    ).toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(XiaomingLocalizations.of(context).Saved_Data),
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

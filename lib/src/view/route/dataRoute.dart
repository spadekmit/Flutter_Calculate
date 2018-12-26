import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///保存的数据界面
void popdataRoute(BuildContext context) {
  Navigator.of(context)
      .push(new CupertinoPageRoute<void>(builder: (BuildContext context) {
    return new dataRoute();
  }));
}

class dataRoute extends StatefulWidget {
  @override
  _dataRouteState createState() => _dataRouteState();
}

class _dataRouteState extends State<dataRoute> {
  @override
  Widget build(BuildContext context) {
    ///处理清空按钮调用函数
    void _handleEmpty() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('请确认是否要删除所有已保存的数据'),
              actions: <Widget>[
                FlatButton(
                  child: Text(XiaomingLocalizations.of(context).delete),
                  onPressed: () {
                    setState(() {
                      UserData.dbs = new Map();
                      UserData.matrixs = new Map();
                      UserData.writeDb();
                      UserData.writeMatrix();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(XiaomingLocalizations.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    ///保存的浮点数和矩阵组成的卡片列表
    List<Card> tiles = <Card>[];

    ///加载矩阵列表
    if (UserData.matrixs.isNotEmpty) {
      UserData.matrixs.forEach((name, list) => tiles.add(new Card(
            color: Colors.cyan,
            child: new ListTile(
              title: new Text(name),
              subtitle: new Text(MatrixUtil.mtoString(list: list)),
            ),
          )));
    }

    ///加载浮点数列表
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
      tiles: tiles.reversed, //将后存入的数据显示在上方
    ).toList();

    return new Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: new Text(XiaomingLocalizations.of(context).saved_Data),
      ),
      body: new ListView(
        children: divided,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: _handleEmpty,
      ),
    );
  }
}

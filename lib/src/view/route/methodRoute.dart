import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/newMethodRoute.dart';

///保存的方法界面
void popmethodRoute(BuildContext context) {
  Navigator.of(context).push(new CupertinoPageRoute(builder: (context) {
    return MethodRoute();
  }));
}

class MethodRoute extends StatefulWidget {
  @override
  _MethodRouteState createState() => _MethodRouteState();
}

class _MethodRouteState extends State<MethodRoute> {
  @override
  Widget build(BuildContext context) {
    ///处理删除按钮回调
    void _handleDelete() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('请确认是否要删除所有已保存的自定义方法'),
              actions: <Widget>[
                FlatButton(
                  child: Text(XiaomingLocalizations.of(context).delete),
                  onPressed: () {
                    setState(() {
                      UserData.userFunctions = [];
                      UserData.writeUserFun();
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

    ///存储方法卡片列表
    final List<Widget> tiles = <Widget>[];
    Locale myLocale = Localizations.localeOf(context);
    String funName;
    String funDescrip;

    ///将内置方法及已保存的方法加载进tiles
    for (UserFunction u in UserData.userFunctions) {
      tiles.add(Dismissible(
        onDismissed: (item) {
          print(item.index);
        },
        key: Key(u.funName),
        child: Card(
          color: Colors.purple,
          child: new ListTile(
            leading: new Text(
              u.funName,
            ),
            title: new Text(
                '${u.funName}(${u.paras.toString().substring(1, u.paras.toString().length - 1)})'),
            subtitle: new Text(u.funCmds.toString()),
          ),
        ),
      ));
    }
    for (CmdMethod method in UserData.cmdMethods) {
      if (myLocale.countryCode == 'CH') {
        funName = method.name;
        funDescrip = method.methodDescription;
      } else {
        funName = method.ename;
        funDescrip = method.emethodDescription;
      }
      tiles.add(Card(
        color: Colors.yellow,
        child: ListTile(
          title: Text(
            funName,
          ),
          subtitle: Text(funDescrip),
        ),
      ));
    }
    
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: new Text(XiaomingLocalizations.of(context).savedFunction),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => popNewMethodRoute(context),
          )
        ],
      ),
      body: new ListView(
        children: divided,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: _handleDelete,
      ),
    );
  }
}

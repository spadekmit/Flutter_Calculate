import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///保存的方法界面
void popmethodRoute(BuildContext context) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
    return methodRoute();
  }));
}

class methodRoute extends StatefulWidget {
  @override
  _methodRouteState createState() => _methodRouteState();
}

class _methodRouteState extends State<methodRoute> {
  @override
  Widget build(BuildContext context) {

    void _handleDelete(){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('请确认是否要删除所有已保存的自定义方法'),
              actions: <Widget>[
                FlatButton(
                  child: Text('确认'),
                  onPressed: () {
                    setState(() {
                      UserData.userFunctions = [];
                      UserData.writeUserFun();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    final List<Card> tiles = <Card>[];
    Locale myLocale = Localizations.localeOf(context);
    String funName;
    String funDescrip;

    for (CmdMethod method in UserData.cmdMethods) {
      if (myLocale.countryCode == 'CH') {
        funName = method.name;
        funDescrip = method.methodDescription;
      } else {
        funName = method.Ename;
        funDescrip = method.EmethodDescription;
      }
      tiles.add(new Card(
        color: Colors.yellow,
        child: new ListTile(
          title: new Text(
            funName,
          ),
          subtitle: new Text(funDescrip),
        ),
      ));
    }
    for (UserFunction u in UserData.userFunctions) {
      tiles.add(new Card(
        color: Colors.purple,
        child: new ListTile(
          leading: new Text(
            u.funName,
          ),
          title: new Text(
              '${u.funName}(${u.paras.toString().substring(1, u.paras.toString().length - 1)})'),
          subtitle: new Text(u.funCmds.toString()),
        ),
      ));
    }
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: new AppBar(
          title: new Text(XiaomingLocalizations.of(context).saved_function)),
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

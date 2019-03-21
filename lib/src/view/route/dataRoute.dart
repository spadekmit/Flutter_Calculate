import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/DeleteButton.dart';

class DataRoute extends StatefulWidget {
  @override
  _DataRouteState createState() => _DataRouteState();
}

class _DataRouteState extends State<DataRoute> {
  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    ///处理清空按钮调用函数
    void _handleEmpty() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(XiaomingLocalizations.of(context).deleteAllData),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(XiaomingLocalizations.of(context).delete),
                  onPressed: () {
                    setState(() {
                      UserData.dbs = new Map();
                      UserData.matrixs = new Map();
                      UserData.deleteAllMatrix();
                      UserData.deleteAllNum();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(XiaomingLocalizations.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    void _handleDelete() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(XiaomingLocalizations.of(context).deleteAllMethod),
              actions: <Widget>[
                FlatButton(
                  child: Text(XiaomingLocalizations.of(context).delete),
                  onPressed: () {
                    setState(() {
                      UserData.userFunctions = [];
                      UserData.deleteAllUF();
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
    List<Dismissible> datas = <Dismissible>[];

    ///加载矩阵列表
    if (UserData.matrixs.isNotEmpty) {
      UserData.matrixs.forEach((name, list) => datas.add(Dismissible(
            key: Key(name),
            onDismissed: (item) {
              setState(() {
                UserData.matrixs.remove(name);
                UserData.deleteMatrix(name);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(XiaomingLocalizations.of(context).removeData),
                action: SnackBarAction(
                    label: XiaomingLocalizations.of(context).undo,
                    onPressed: () => setState(() {
                          UserData.matrixs[name] = list;
                          UserData.addMatrix(name, list);
                        })),
                duration: Duration(seconds: 2),
              ));
            },
            background: Container(
              color: Colors.red,
            ),
            child: Card(
              color: Colors.cyan,
              child: new ListTile(
                title: new Text(name),
                subtitle: new Text(MatrixUtil.mtoString(list: list)),
              ),
            ),
          )));
    }

    ///加载浮点数列表
    if (UserData.dbs.isNotEmpty) {
      UserData.dbs.forEach((name, value) => datas.add(Dismissible(
            key: Key(name),
            onDismissed: (item) {
              setState(() {
                UserData.dbs.remove(name);
                UserData.deleteNum(name);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(XiaomingLocalizations.of(context).removeData),
                action: SnackBarAction(
                    label: XiaomingLocalizations.of(context).undo,
                    onPressed: () => setState(() {
                          UserData.dbs[name] = value;
                          UserData.addNum(name, value);
                        })),
                duration: Duration(seconds: 2),
              ));
            },
            background: Container(
              color: Colors.red,
            ),
            child: Card(
              color: Colors.green,
              child: new ListTile(
                title: new Text(name),
                subtitle: new Text(value.toString()),
              ),
            ),
          )));
    }
    final List<Widget> divided1 = ListTile.divideTiles(
      context: context,
      tiles: datas.reversed, //将后存入的数据显示在上方
    ).toList();

    final List<Widget> methods = <Widget>[];
          Locale myLocale = Localizations.localeOf(context);
          String funName;
          String funDescrip;

          ///将内置方法及已保存的方法加载进tiles
          for (int index = 0; index < UserData.userFunctions.length; index ++) {
            var u = UserData.userFunctions[index];
            methods.add(Dismissible(
              onDismissed: (item) {
                var temp;
                setState(() {
                  temp = UserData.userFunctions.removeAt(index);
                  UserData.deleteUF(u.funName);
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(XiaomingLocalizations.of(context).removeUF),
                  action: SnackBarAction(label: XiaomingLocalizations.of(context).undo, onPressed: ()=>setState((){
                    UserData.userFunctions.insert(index, temp);
                    UserData.addUF(u.funName, u.paras, u.funCmds);
                  })),
                ));
              },
              background: Container(
                color: Colors.red,
              ),
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
            methods.add(Card(
              color: Colors.yellow,
              child: ListTile(
                title: Text(
                  funName,
                ),
                subtitle: Text(funDescrip),
              ),
            ));
          }
          final List<Widget> divided2 = ListTile.divideTiles(
            context: context,
            tiles: methods,
          ).toList();

    final Map<int, Widget> titles = const <int, Widget>{
      0: Text("Data"),
      1: Text("Method"),
    };

    Map<int, Widget> lists = <int, Widget>{
      0: ListView(
        children: divided1,
      ),
      1: ListView(
        children: divided2,
      ),
    };

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: DeleteButton(1, _handleEmpty),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          SizedBox(
            width: 500.0,
            child: CupertinoSegmentedControl<int>(
              children: titles,
              onValueChanged: (int newValue) {
                setState(() {
                  sharedValue = newValue;
                });
              },
              groupValue: sharedValue,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 450.0,
            width: 350.0,
            child: lists[sharedValue],
          ),
        ],
      ),
    );
  }
}

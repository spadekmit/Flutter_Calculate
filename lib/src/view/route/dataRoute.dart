import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/newMethodRoute.dart';
import 'package:xiaoming/src/view/widget/myButtons.dart';

///保存的数据与方法界面
class DataRoute extends StatefulWidget {
  @override
  _DataRouteState createState() => _DataRouteState();
}

class _DataRouteState extends State<DataRoute> {
  int _sharedValue = 0; //当前卡片序号

  @override
  void initState() {
    UserData.nowPage = 0;
    super.initState();
  }

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
                  isDestructiveAction: true,
                  child: Text(XiaomingLocalizations.of(context).delete),
                  onPressed: () {
                    setState(() {
                      UserData.dbs = new Map();
                      UserData.matrixs = new Map();
                      UserData.deleteAllMatrix();
                      UserData.deleteAllNum();
                      UserData.userFunctions = [];
                      UserData.deleteAllUF();
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text(XiaomingLocalizations.of(context).removeData),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: Text(XiaomingLocalizations.of(context).delete),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(XiaomingLocalizations.of(context).cancel),
                          onPressed: () {
                            setState(() {
                              UserData.matrixs[name] = list;
                              UserData.addMatrix(name, list);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text(XiaomingLocalizations.of(context).removeData),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: Text(XiaomingLocalizations.of(context).delete),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(XiaomingLocalizations.of(context).cancel),
                          onPressed: () {
                            setState(() {
                              UserData.dbs[name] = value;
                              UserData.addNum(name, value);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
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

    ///添加完分割线的数据列表
    final List<Widget> divided1 = ListTile.divideTiles(
      context: context,
      tiles: datas.reversed, //将后存入的数据显示在上方
    ).toList();

    ///保存的方法列表
    final List<Widget> methods = <Widget>[];
    Locale myLocale = Localizations.localeOf(context);
    String funName;
    String funDescrip;

    ///将内置方法及已保存的方法加载进methods
    for (int index = 0; index < UserData.userFunctions.length; index++) {
      var u = UserData.userFunctions[index];
      methods.add(Dismissible(
        onDismissed: (item) {
          var temp;
          setState(() {
            temp = UserData.userFunctions.removeAt(index);
            UserData.deleteUF(u.funName);
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text(XiaomingLocalizations.of(context).removeUF),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text(XiaomingLocalizations.of(context).delete),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(XiaomingLocalizations.of(context).cancel),
                      onPressed: () {
                        setState(() {
                          UserData.userFunctions.insert(index, temp);
                          UserData.addUF(u.funName, u.paras, u.funCmds);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
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

    ///添加完分隔线的方法列表
    final List<Widget> divided2 = ListTile.divideTiles(
      context: context,
      tiles: methods,
    ).toList();

    ///标题栏
    final Map<int, Widget> titles = const <int, Widget>{
      0: Text("Data"),
      1: Text("Method"),
    };

    ///内容栏
    Map<int, Widget> lists = <int, Widget>{
      0: CupertinoScrollbar(
        child: ListView(
          children: divided1,
        ),
      ),
      1: CupertinoScrollbar(
        child: ListView(
          children: divided2,
        ),
      )
    };

    ///保存的数据界面布局
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: buildTrailingBar(<Widget>[
          CupertinoButton(
            padding: const EdgeInsets.all(0.0),
            child: Icon(CupertinoIcons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (BuildContext context) {
                return NewMethodRoute();
              }));
            },
          ),
          SizedBox(
            width: 8.0,
          ),
          DeleteButton(1, _handleEmpty),
        ]),
        middle: Text("Saved"),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top + 90.0,
          ),
          SizedBox(
            width: 500.0,
            child: CupertinoSegmentedControl<int>(
              children: titles,
              onValueChanged: (int newValue) {
                setState(() {
                  _sharedValue = newValue;
                });
              },
              groupValue: _sharedValue,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 450.0,
            width: 350.0,
            child: lists[_sharedValue],
          ),
        ],
      ),
    );
  }
}

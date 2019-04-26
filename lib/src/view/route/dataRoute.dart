import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/data/userData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/newMethodRoute.dart';
import 'package:xiaoming/src/view/widget/myButtons.dart';

Widget _buildDataView() {
  return Provide<UserData>(
    builder: (context, child, ud) {
      ///保存的浮点数和矩阵组成的卡片列表
      List<Widget> datas = <Widget>[];

      ///加载矩阵列表
      if (ud.matrixs.isNotEmpty) {
        ud.matrixs.forEach((name, list) => datas.add(GestureDetector(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title:
                            Text(XiaomingLocalizations.of(context).removeData),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child:
                                Text(XiaomingLocalizations.of(context).delete),
                            onPressed: () {
                              ud.deleteMatrix(name);
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child:
                                Text(XiaomingLocalizations.of(context).cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
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
      if (ud.dbs.isNotEmpty) {
        ud.dbs.forEach((name, value) => datas.add(GestureDetector(
              key: Key(name),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title:
                            Text(XiaomingLocalizations.of(context).removeData),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child:
                                Text(XiaomingLocalizations.of(context).delete),
                            onPressed: () {
                              ud.deleteNum(name);
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child:
                                Text(XiaomingLocalizations.of(context).cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Card(
                color: Colors.green,
                child: new ListTile(
                  title: new Text(name),
                  subtitle: new Text(value.toString()),
                ),
              ),
            )));
      }

      return ListView.builder(
        itemBuilder: (context, index) => datas[index],
        itemCount: datas.length,
      );
    },
  );
}

Widget _buildMethodView() {
  return Provide<UserData>(
    builder: (context, child, ud) {
      ///保存的方法列表
      final List<Widget> methods = <Widget>[];
      Locale myLocale = Localizations.localeOf(context);
      String funName;
      String funDescrip;

      ///将内置方法及已保存的方法加载进methods
      for (int index = 0; index < ud.userFunctions.length; index++) {
        var u = ud.userFunctions[index];
        methods.add(GestureDetector(
          onLongPress: () {
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
                          ud.deleteUF(u.funName);
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

      return ListView.builder(
        itemBuilder: (context, index) => methods[index],
        itemCount: methods.length,
      );
    },
  );
}

///处理清空按钮调用函数
void _handleEmpty(BuildContext context) {
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
                Provide.value<UserData>(context)
                  ..deleteAllNum()
                  ..deleteAllMatrix()
                  ..deleteAllUF();
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

class AndDataRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingData.nowPage = 0;
    return DefaultTabController(
      length: 2, //tabBar的数量
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, isShow) => <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _handleEmpty(context),
                    ),
                  ],
                  title: Text("Saved"),
                  centerTitle: true,
                  pinned: false,
                  expandedHeight: 100.0,
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(TabBar(
                    labelColor: Colors.black,
                    indicatorColor: CupertinoColors.white,
                    tabs: <Widget>[
                      Tab(
                        text: "Data",
                      ),
                      Tab(
                        text: "Method",
                      ),
                    ],
                  )),
                  pinned: true,
                )
              ],
          body: TabBarView(
            children: <Widget>[
              _buildDataView(),
              _buildMethodView(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (BuildContext context) {
              return NewMethodRoute();
            }));
          },
        ),
      ),
    );
  }
}

///保存的数据与方法界面
class IOSDataRoute extends StatefulWidget {
  @override
  _IOSDataRouteState createState() => _IOSDataRouteState();
}

class _IOSDataRouteState extends State<IOSDataRoute> {
  int _sharedValue = 0; //当前卡片序号

  @override
  void initState() {
    SettingData.nowPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///标题栏
    final Map<int, Widget> titles = const <int, Widget>{
      0: Text("Data"),
      1: Text("Method"),
    };

    ///内容栏
    Map<int, Widget> lists = <int, Widget>{
      0: CupertinoScrollbar(
        child: _buildDataView(),
      ),
      1: CupertinoScrollbar(
        child: _buildMethodView(),
      )
    };

    ///保存的数据界面布局
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
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
          DeleteButton(() => _handleEmpty(context)),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.blue,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

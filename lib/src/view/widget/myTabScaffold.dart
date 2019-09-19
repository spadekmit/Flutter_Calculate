import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/dataRoute.dart';
import 'package:xiaoming/src/view/route/functionsRoute.dart';
import 'package:xiaoming/src/view/route/homeRoute.dart';

class MyTabScaffold extends StatelessWidget {
  //创建IOS主题的底部导航栏
  Widget _buildIOSTabScaffold(BuildContext context) {
    return CupertinoTabScaffold(
        key: Key("IOS"),
        tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(XiaomingLocalizations.of(context).home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text(XiaomingLocalizations.of(context).functions),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            title: Text(XiaomingLocalizations.of(context).saved),
          ),
        ]),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (BuildContext context) {
                return HomeRoute();
              });
              break;
            case 1:
              return CupertinoTabView(builder: (BuildContext context) {
                return IOSFunctionsRoute();
              });
            case 2:
              return CupertinoTabView(builder: (BuildContext context) {
                return IOSDataRoute();
              });
            default:
              return CupertinoTabView();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    SettingData.language =
        Localizations.localeOf(context).languageCode; //记录当前语言代码
    return Provide<SettingData>(
      //跟随主题切换界面
      builder: (context, child, sd) {
        return WillPopScope(
          //拦截系统导航栏返回键事件
          onWillPop: () async {
            switch (SettingData.nowPage) {
              case 0:
                bool isPop = false;
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return sd.theme == "IOS"
                          ? CupertinoAlertDialog(
                              title: Text(
                                  XiaomingLocalizations.of(context).outApp),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: Text(
                                      XiaomingLocalizations.of(context).quit),
                                  onPressed: () {
                                    isPop = true;
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text(
                                      XiaomingLocalizations.of(context).cancel),
                                  onPressed: () {
                                    isPop = false;
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                          : AlertDialog(
                              title: Text(
                                  XiaomingLocalizations.of(context).outApp),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                      XiaomingLocalizations.of(context).quit),
                                  onPressed: () {
                                    isPop = true;
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                      XiaomingLocalizations.of(context).cancel),
                                  onPressed: () {
                                    isPop = false;
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                    });
                return Future.value(isPop);
                break;
              case 1:
                SettingData.nowPage = 0;
                Navigator.pop(SettingData.pageContext);
                return Future.value(false);
                break;
              case 2:
                Navigator.pop(SettingData.pageContext);
                return Future.value(false);
                break;
              case 3:
                SettingData.nowPage = 0;
                Navigator.pop(SettingData.pageContext);
                return Future.value(false);
                break;
              default:
                return Future.value(true);
            }
          },
          child: sd.theme == "IOS"
              ? _buildIOSTabScaffold(context)
              : AndTabScaffold(),
        );
      },
    );
  }
}

//安卓主题底部导航栏
class AndTabScaffold extends StatefulWidget {
  @override
  _AndTabScaffoldState createState() => _AndTabScaffoldState();
}

class _AndTabScaffoldState extends State<AndTabScaffold> {
  int _selectedIndex = 0;

  final _bodys = [
    HomeRoute(),
    AndFunctionsRoute(),
    AndDataRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("Android"),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text(XiaomingLocalizations.of(context).home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text(XiaomingLocalizations.of(context).functions),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              title: Text(XiaomingLocalizations.of(context).saved),
            ),
          ]),
      body: _bodys[_selectedIndex],
    );
  }
}

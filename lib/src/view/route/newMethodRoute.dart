import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/data/userData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/myTextComposer.dart';

class NewMethodRoute extends StatefulWidget {
  @override
  _NewMethodRouteState createState() => _NewMethodRouteState();
}

class _NewMethodRouteState extends State<NewMethodRoute> {
  TextEditingController _funName;
  TextEditingController _parm;
  TextEditingController _cmds;

  @override
  void initState() {
    _funName = new TextEditingController();
    _parm = new TextEditingController();
    _cmds = new TextEditingController();
    SettingData.nowPage = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPop = false;
    SettingData.pageContext = context;
    void _saveMethod() {
      if (_funName.text.length != 0 ||
          _parm.text.length != 0 ||
          _cmds.text.length > 1) {
        if (!_funName.text.contains(RegExp(r'[^A-Za-z0-9]'))) {
          if (!_parm.text.contains(RegExp(r'[^A-Za-z,]'))) {
            showDialog(
                context: context,
                builder: (alertContext) {
                  return Provide<SettingData>(
                    builder: (context, child, sd) {
                      return sd.theme == "IOS"
                          ? CupertinoAlertDialog(
                              title: Text(
                                  XiaomingLocalizations.of(context).sucSave),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: Text(
                                      XiaomingLocalizations.of(context).ok),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    isPop = true;
                                    Provide.value<UserData>(context).addUF(
                                        _funName.text,
                                        _parm.text.split(','),
                                        _cmds.text.split(';'));
                                    Navigator.pop(alertContext);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text(
                                      XiaomingLocalizations.of(context).cancel),
                                  onPressed: () {
                                    Navigator.pop(alertContext);
                                  },
                                ),
                              ],
                            )
                          : AlertDialog(
                              title: Text(
                                  XiaomingLocalizations.of(context).sucSave),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                      XiaomingLocalizations.of(context).ok),
                                  onPressed: () {
                                    isPop = true;
                                    Provide.value<UserData>(context).addUF(
                                        _funName.text,
                                        _parm.text.split(','),
                                        _cmds.text.split(';'));
                                    Navigator.pop(alertContext);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                      XiaomingLocalizations.of(context).cancel),
                                  onPressed: () {
                                    Navigator.pop(alertContext);
                                  },
                                ),
                              ],
                            );
                    },
                  );
                }).then((value) {
              if (isPop) {
                Navigator.pop(context);
              }
            });
          }
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('请输入函数名，函数参数，函数体'),
                actions: <Widget>[],
              );
            });
      }
    }

    Widget floatButton = FloatingActionButton(
      child: Text(
        XiaomingLocalizations.of(context).save,
      ),
      onPressed: _saveMethod,
    );

    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: Provide<SettingData>(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MyTextField(_funName, 'Method Name'),
              MyTextField(_parm, 'Method Parameter'),
              MyTextField(_cmds, 'Method body'),
            ],
          ),
        ),
        builder: (context, child, sd) {
          return sd.theme == "IOS"
              ? Scaffold(
                  backgroundColor: CupertinoColors.lightBackgroundGray,
                  appBar: CupertinoNavigationBar(
                    middle: Text(XiaomingLocalizations.of(context).newFun),
                    previousPageTitle: 'Saved',
                  ),
                  body: child,
                  floatingActionButton: floatButton,
                )
              : Scaffold(
                  backgroundColor: CupertinoColors.lightBackgroundGray,
                  appBar: AppBar(
                    title: Text(XiaomingLocalizations.of(context).newFun),
                    centerTitle: true,
                  ),
                  body: child,
                  floatingActionButton: floatButton,
                );
        },
      ),
    );
  }
}

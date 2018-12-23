import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///设置界面
class SettingRoute extends StatefulWidget {
  SettingRoute({Key key}) : super(key: key);
  @override
  _SettingRouteState createState() => _SettingRouteState();
}

///控制设置界面的状态
class _SettingRouteState extends State<SettingRoute> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Widget myCard(Widget child) {
      return Card(
        elevation: 1.0,
        margin: const EdgeInsets.all(8.0),
        child: new Container(
          margin: const EdgeInsets.all(12.0),
          child: child,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(XiaomingLocalizations.of(context).setting),
      ),
      body: Builder(
          builder: (BuildContext context) => ListView(
                children: <Widget>[
                  myCard(Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            XiaomingLocalizations.of(context).decimal_digits),
                      ),
                      Text(SettingData.fixedNum.toString()),
                      CupertinoSlider(
                        divisions: 8,
                        max: 9.0,
                        min: 1.0,
                        value: SettingData.fixedNum,
                        onChanged: (double d) {
                          setState(() {
                            SettingData.fixedNum = d;
                          });
                          SettingData.writeSettingData();
                        },
                      ),
                    ],
                  )),
                  myCard(Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(XiaomingLocalizations.of(context)
                            .buttonsAutoExpanded),
                      ),
                      Switch(
                        value: SettingData.isAutoExpanded,
                        onChanged: (bool b) {
                          setState(() {
                            SettingData.isAutoExpanded = b;
                          });
                          SettingData.writeSettingData();
                        },
                      )
                    ],
                  )),
                  myCard(Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              Text(XiaomingLocalizations.of(context).maximum)),
                      Container(
                        margin: EdgeInsets.only(left: 70.0),
                        child: FlatButton(
                          child: Text(
                            SettingData.maxTexts.toString(),
                            style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext alertContext) {
                                  return AlertDialog(
                                    title: TextField(
                                      controller: _controller,
                                      keyboardType: TextInputType.number,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("确认"),
                                        onPressed: () {
                                          try {
                                            SettingData.maxTexts =
                                                int.parse(_controller.text);
                                            Navigator.of(alertContext).pop();
                                          } catch (e) {

                                          }
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('取消'),
                                        onPressed: () {
                                          Navigator.of(alertContext).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  )),
                ],
              )),
    );
  }
}

///加载设置界面
void settingRoute(BuildContext context) {
  Navigator.of(context)
      .push(new CupertinoPageRoute<void>(builder: (BuildContext context) {
    return new SettingRoute();
  }));
}

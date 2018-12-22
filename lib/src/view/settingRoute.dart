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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(XiaomingLocalizations.of(context).setting),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 1.0,
            margin: const EdgeInsets.all(8.0),
            child: new Container(
                margin: const EdgeInsets.all(12.0),
                child: new Row(
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
          ),
          Card(
            elevation: 1.0,
            margin: const EdgeInsets.all(8.0),
            child: new Container(
                margin: const EdgeInsets.all(12.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          XiaomingLocalizations.of(context).buttonsAutoExpanded),
                    ),
                    Switch(
                      value: SettingData.isAutoExpanded,
                      onChanged: (bool b) {
                        setState((){
                        SettingData.isAutoExpanded = b;
                        });
                        SettingData.writeSettingData();
                      }  ,
                    )
                  ],
                )),
          ),
        ],
      ),
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

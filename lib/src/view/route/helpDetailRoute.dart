import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

class HelpDetailRoute extends StatefulWidget {
  HelpDetailRoute(this._index, {Key key}) : super(key: key);

  final int _index;

  @override
  _HelpDetailRouteState createState() => _HelpDetailRouteState();
}

class _HelpDetailRouteState extends State<HelpDetailRoute> {
  Text text;

  @override
  void initState() {
    super.initState();
    SettingData.nowPage = 2;
  }

  @override
  Widget build(BuildContext context) {
    SettingData.pageContext = context;

    List<Widget> list = <Widget>[];

    switch (widget._index) {
      case 1:
        list.addAll(<Widget>[
          Text(XiaomingLocalizations.of(context).helpTabData1),
          SizedBox(
            height: 50.0,
          ),
          Card(
            child: Image.asset(
              'assets/image/inputData.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Card(
            child: Image.asset(
              'assets/image/inputData2.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ]);
        break;
      case 2:
        list.addAll(<Widget>[
          Text(XiaomingLocalizations.of(context).helpTabData2),
        ]);
        break;
      case 3:
        list.addAll(<Widget>[
          Text(XiaomingLocalizations.of(context).helpTabData3),
          SizedBox(
            height: 50.0,
          ),
          Card(
            child: Image.asset(
              'assets/image/inputMethod.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Card(
            child: Image.asset(
              'assets/image/invMatrix.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Card(
            child: Image.asset(
              'assets/image/sin.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ]);
        break;
      case 4:
        list.addAll(<Widget>[
          Text(XiaomingLocalizations.of(context).helpTabData4),
        ]);
        break;
      case 5:
        list.addAll(<Widget>[
          Text(XiaomingLocalizations.of(context).helpTabData5),
        ]);
        break;
      case 6:
        list.addAll(<Widget>[
          Text(XiaomingLocalizations.of(context).helpTabData6),
        ]);
        break;
    }

    return Provide<SettingData>(
      builder: (context, child, sd) {
        return sd.theme == "IOS"
            ? CupertinoPageScaffold(
                backgroundColor: CupertinoColors.lightBackgroundGray,
                navigationBar: const CupertinoNavigationBar(
                  middle: Text("HelpDetail"),
                  previousPageTitle: 'Help',
                ),
                child: child,
              )
            : Scaffold(
                backgroundColor: CupertinoColors.lightBackgroundGray,
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  title: Text("HelpDetail"),
                  centerTitle: true,
                ),
                body: child,
              );
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTextStyle(
                  style: const TextStyle(
                    fontFamily: '.SF UI Text',
                    fontWeight: FontWeight.w400,
                    inherit: false,
                    fontSize: 20.0,
                    color: CupertinoColors.black,
                  ),
                  child: ListView(children: list)),
            ),
          ),
        ),
      ),
    );
  }
}

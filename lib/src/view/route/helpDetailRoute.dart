import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

class HelpDetailRoute extends StatefulWidget {
  HelpDetailRoute(this.index, {Key key}) : super(key: key);

  final int index;

  @override
  _HelpDetailRouteState createState() => _HelpDetailRouteState(index);
}

class _HelpDetailRouteState extends State<HelpDetailRoute> {
  _HelpDetailRouteState(this.index);

  final int index;
  Text text;

  @override
  void initState() {
    UserData.nowPage = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    UserData.pageContext = context;

    switch (index) {
      case 1:
        text = Text(XiaomingLocalizations.of(context).helpTabData1);
        break;
      case 2:
        text = Text(XiaomingLocalizations.of(context).helpTabData2);
        break;
      case 3:
        text = Text(XiaomingLocalizations.of(context).helpTabData3);
        break;
      case 4:
        text = Text(XiaomingLocalizations.of(context).helpTabData4);
        break;
      case 5:
        text = Text(XiaomingLocalizations.of(context).helpTabData5);
        break;
      case 6:
        text = Text(XiaomingLocalizations.of(context).helpTabData6);
        break;
    }

    return DefaultTextStyle(
        style: const TextStyle(
          fontFamily: '.SF UI Text',
          inherit: false,
          fontSize: 17.0,
          color: CupertinoColors.black,
        ),
        child: new CupertinoPageScaffold(
          backgroundColor: CupertinoColors.lightBackgroundGray,
          navigationBar: const CupertinoNavigationBar(
            middle: Text("HelpDetail"),
            previousPageTitle: 'Help',
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/image/help1.png',
                        width: MediaQuery.of(context).size.width / 3,
                        height: 200.0,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 12,
                      ),
                      Image.asset(
                        'assets/image/help2.png',
                        width: MediaQuery.of(context).size.width / 3,
                        height: 200.0,
                        fit: BoxFit.fitWidth,
                      )
                    ]),
                Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Card(
                    color: CupertinoColors.lightBackgroundGray,
                    elevation: 0.0,
                    child: text,
                  ),
                ),
              ]),
        ));
  }
}

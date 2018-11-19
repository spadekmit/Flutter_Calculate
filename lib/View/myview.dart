import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaoming/command/Matrix.dart';
import 'package:xiaoming/language/xiaomingLocalizations.dart';

///单个输出文本的视图
class TextView extends StatelessWidget {
  TextView({this.context, this.text, this.animationController});
  BuildContext context;
  final AnimationController animationController;
  final String text;
//  final scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new GestureDetector(
        child: new ListTile(
            title: new Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: new Text(text),
        )),
        onLongPress: _handleLongPress,
      ),
    );
  }

  void _handleLongPress() {
    Clipboard.setData(new ClipboardData(text: text));
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: new Text(XiaomingLocalizations.of(context).CopyHint),
    ));
  }
}

///保存的方法界面
void methodRoute(BuildContext context) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
    final List<Card> tiles = <Card>[];
    Locale myLocale = Localizations.localeOf(context);
    String funName;
    String funDescrip;

    for (CmdMethod method in cmdMethods) {
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
          leading: new Text(
            funName,
          ),
          title: new Text(funDescrip),
        ),
      ));
    }
    for (UserFunction u in userFunctions) {
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

    return new Scaffold(
      appBar: new AppBar(
          title: new Text(XiaomingLocalizations.of(context).Saved_function)),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

///保存的数据界面
void dataRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    List<Card> tiles = <Card>[];
    if (matrixs.isNotEmpty) {
      matrixs.forEach((name, list) => tiles.add(new Card(
            color: Colors.cyan,
            child: new ListTile(
              leading: new Text(name),
              title: new Text(mtoString(list: list)),
            ),
          )));
    }
    if (dbs.isNotEmpty) {
      dbs.forEach((name, value) => tiles.add(new Card(
            color: Colors.green,
            child: new ListTile(
              leading: new Text(name),
              title: new Text(value.toString()),
            ),
          )));
    }
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles.reversed,
    ).toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(XiaomingLocalizations.of(context).Saved_Data),
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

///设置界面
class SettingRoute extends StatefulWidget {
  @override
  _SettingRouteState createState() => _SettingRouteState();
}

///控制设置界面的状态
class _SettingRouteState extends State<SettingRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(XiaomingLocalizations.of(context).Setting),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: new Container(
                margin: const EdgeInsets.all(12.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          XiaomingLocalizations.of(context).decimal_digits),
                    ),
                    Text(fixedNum.toString()),
                    CupertinoSlider(
                      divisions: 8,
                      max: 9.0,
                      min: 1.0,
                      value: fixedNum,
                      onChanged: (double d) {
                        setState(() {
                          fixedNum = d;
                        });
                        writeSettingData();
                      },
                    ),
                  ],
                )),
          ),
          Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: new Container(
              margin: const EdgeInsets.all(12.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        XiaomingLocalizations.of(context).MethodButtonsView),
                  ),
                  Text(XiaomingLocalizations.of(context).Horizontal),
                  Switch(
                    value: isHorizontalBottons,
                    onChanged: (newValue) {
                      setState(() {
                        isHorizontalBottons = !isHorizontalBottons;
                      });
                      writeSettingData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///加载设置界面
void settingRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    return new SettingRoute();
  }));
}

///帮助界面
class helpView extends StatefulWidget {
  @override
  _helpViewState createState() => _helpViewState();
}

class HelpItem {
  bool isExpanded;
  HelpItem(this.isExpanded);
}

///控制帮助界面的状态
class _helpViewState extends State<helpView> {
  List<HelpItem> items = <HelpItem>[
      new HelpItem(false),
      new HelpItem(false),
      new HelpItem(false),
      new HelpItem(false),
    ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('帮助'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            new Card(
                child: new ExpansionPanelList(
              expansionCallback: (int i, bool b) => setState(() {
                    items[i].isExpanded = !items[i].isExpanded;
                  }),
              children: <ExpansionPanel>[
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).HelpTab1,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[0].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).HelpTabData1),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).HelpTab2,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[1].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).HelpTabData2),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).HelpTab3,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[2].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).HelpTabData3),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).HelpTab4,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[3].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).HelpTabData4),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

void helpRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    return new helpView();
  }));
}

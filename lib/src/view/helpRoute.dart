import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';


void pophelpRoute(BuildContext context) {
  Navigator.of(context)
      .push(new CupertinoPageRoute<void>(builder: (BuildContext context) {
    return new helpView();
  }));
}

///帮助界面
class helpView extends StatefulWidget {
  helpView({Key key}) : super(key: key);
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
    new HelpItem(false),
    new HelpItem(false),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: Text(XiaomingLocalizations.of(context).help),
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
                          XiaomingLocalizations.of(context).helpTab1,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[0].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).helpTabData1),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).helpTab2,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[1].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).helpTabData2),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).helpTab3,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[2].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).helpTabData3),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).helpTab4,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[3].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).helpTabData4),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).helpTab5,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[4].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).helpTabData5),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(
                          XiaomingLocalizations.of(context).helpTab6,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: items[5].isExpanded,
                  body: Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                        XiaomingLocalizations.of(context).helpTabData6),
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



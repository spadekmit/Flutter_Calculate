import 'package:flutter/material.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';


void pophelpRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
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



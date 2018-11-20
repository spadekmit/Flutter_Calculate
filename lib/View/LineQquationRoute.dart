import 'package:flutter/material.dart';

void lineQuations(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    return new LineQuationsView();
  }));
}

class LineQuationsView extends StatefulWidget {
  LineQuationsView({Key key}) : super(key: key);
  @override
  _LineQuationsViewState createState() => _LineQuationsViewState();
}

class _LineQuationsViewState extends State<LineQuationsView> {
  final TextEditingController _lineQuasController = new TextEditingController();
  final TextEditingController _varController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Text('求解方程组'),
      ),
      body: new Container(
        padding: const EdgeInsets.all(18.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: _lineQuasController,
              decoration: new InputDecoration.collapsed(hintText: '输入方程组'),
            ),
            new TextField(
              controller: _varController,
              decoration: new InputDecoration.collapsed(hintText: '输入变量，以逗号隔开'),
            ),
            new FlatButton(
              onPressed: () => _handleLineQuationCacul(),
            )
          ],
        ),
      ),
    );
  }

  void _handleLineQuationCacul() {}
}

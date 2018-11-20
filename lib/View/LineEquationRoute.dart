import 'package:flutter/material.dart';
import 'package:xiaoming/command/handleLineEquations.dart';
import 'package:xiaoming/View/MyTextView.dart';

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
  final TextEditingController _lineQuasController = TextEditingController();
  final TextEditingController _varController = TextEditingController();
  final FocusNode _lineQuasFocusNode = new FocusNode();
  final FocusNode _varFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('求解方程组'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _lineQuasFocusNode.unfocus();
          _varFocusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.only(
              right: 12.0, left: 12.0, bottom: 12.0, top: 48.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 12.0, bottom: 12.0, top: 12.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: TextFormField(
                            focusNode: _lineQuasFocusNode,
                            controller: _lineQuasController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                hintText: '输入方程式组，以逗号隔开'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60.0,
                    child: FlatButton(
                      child: Text('清空'),
                      onPressed: () => _lineQuasController.clear(),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.only(left: 12.0, bottom: 12.0, top: 12.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: TextFormField(
                            focusNode: _varFocusNode,
                            controller: _varController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                hintText: '输入变量，以逗号隔开'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60.0,
                    child: FlatButton(
                      child: Text('清空'),
                      onPressed: () => _varController.clear(),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () => _handleLineQuationCacul(),
                  child: Text('计算'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleLineQuationCacul() {
    EquationsUtil handle = EquationsUtil.getInstance();
    var result = handle.handleLineEquations(_lineQuasController.text, _varController.text);
    EquationsUtil e = new EquationsUtil();
  }
}

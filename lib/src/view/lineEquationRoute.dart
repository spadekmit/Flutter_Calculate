import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/handleLineEquations.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

void poplineQuationsRoute(BuildContext context) {
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
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(XiaomingLocalizations.of(context).Solve_equation),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _lineQuasFocusNode.unfocus();
          _varFocusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.only(
              right: 12.0, left: 12.0, bottom: 12.0, top: 12.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 48.0, bottom: 12.0),
                child: ExpansionTile(
                  title: Text(XiaomingLocalizations.of(context).hint),
                  children: <Widget>[
                    Text(XiaomingLocalizations.of(context).equaHint1),
                    Text(XiaomingLocalizations.of(context).equaHint2),
                    Text(XiaomingLocalizations.of(context).equaHint3),
                    Text(XiaomingLocalizations.of(context).equaHint4),
                    Text(XiaomingLocalizations.of(context).equaHint5),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 12.0, top: 12.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入多项式或线性方程组';
                    }
                  },
                  focusNode: _lineQuasFocusNode,
                  controller: _lineQuasController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      hintText: '输入多项式或线性方程式组，方程之间以逗号隔开'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 250.0, bottom: 16.0),
                width: 40.0,
                child: FlatButton(
                  child: Text(XiaomingLocalizations.of(context).empty),
                  onPressed: () => _lineQuasController.clear(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 12.0, bottom: 12.0, top: 12.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入所有变量';
                    }
                  },
                  focusNode: _varFocusNode,
                  controller: _varController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      hintText: '输入所有变量，以逗号隔开'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 250.0, bottom: 16.0),
                child: SizedBox(
                  width: 40.0,
                  child: FlatButton(
                    child: Text(XiaomingLocalizations.of(context).empty),
                    onPressed: () => _varController.clear(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 12.0),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () => _handleLineQuationCacul(),
                  child: Text(XiaomingLocalizations.of(context).calculate),
                ),
              ),
              Container(
                child: Center(
                  child: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(new ClipboardData(text: result));
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 1000),
                        content: new Text(
                            XiaomingLocalizations.of(context).CopyHint),
                      ));
                    },
                    child: Text(
                      result,
                      style: TextStyle(color: Colors.purple, fontSize: 20.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleLineQuationCacul() {
    _lineQuasFocusNode.unfocus();
    _varFocusNode.unfocus();
    if (_lineQuasController.text.length != 0) {
      if (_varController.text.length != 0) {
        EquationsUtil handle = EquationsUtil.getInstance();
        var re = handle.handleEquation(
            _lineQuasController.text, _varController.text);
        setState(() {
          result = re;
        });
      } else {
        setState(() {
          result = '变量不能为空';
        });
      }
    } else {
      setState(() {
        result = '方程组不能为空';
      });
    }
  }
}

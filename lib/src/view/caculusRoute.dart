import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/handleLineEquations.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

void popCaculusRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    return new CaculusView();
  }));
}

class CaculusView extends StatefulWidget {
  CaculusView({Key key}) : super(key: key);
  @override
  _CaculusViewState createState() => _CaculusViewState();
}

class _CaculusViewState extends State<CaculusView> {
  final TextEditingController _lineQuasController = TextEditingController();
  final TextEditingController _varController = TextEditingController();
  final FocusNode _lineQuasFocusNode = new FocusNode();
  final FocusNode _varFocusNode = new FocusNode();
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('求解微积分'),
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
              Container(
                padding: EdgeInsets.only(left: 12.0, bottom: 12.0, top: 48.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, left: 8.0, bottom: 8.0, top: 8.0),
                        child: Container(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return '请输入方程组';
                              }
                            },
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return '请输入所有变量';
                              }
                            },
                            focusNode: _varFocusNode,
                            controller: _varController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                hintText: '输入所有变量，以逗号隔开'),
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
                padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 12.0),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () => _handleLineQuationCacul(),
                  child: Text('计算'),
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
        var re = handle.handleLineEquations(
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

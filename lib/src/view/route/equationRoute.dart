import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/handleEquations.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/myButtons.dart';

class EquationRoute extends StatefulWidget {
  EquationRoute({Key key}) : super(key: key);
  @override
  _EquationRouteState createState() => _EquationRouteState();
}

class _EquationRouteState extends State<EquationRoute> with TickerProviderStateMixin {
  final TextEditingController _lineQuasController = TextEditingController();
  final TextEditingController _varController = TextEditingController();
  final FocusNode _lineQuasFocusNode = new FocusNode();
  final FocusNode _varFocusNode = new FocusNode();
  AnimationController controller;
  Animation<double> animation;
  String result = '';

  @override
  void initState() {
    controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///主界面
    return DefaultTextStyle(  ///指定默认文字格式
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: buildTrailingBar(<Widget>[
            CupertinoButton(
              child: Icon(Icons.help),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Column(
                        children: <Widget>[
                          Text(XiaomingLocalizations.of(context).equaHint1),
                          Text(XiaomingLocalizations.of(context).equaHint2),
                          Text(XiaomingLocalizations.of(context).equaHint3),
                          Text(XiaomingLocalizations.of(context).equaHint4),
                          Text(XiaomingLocalizations.of(context).equaHint5),
                        ],
                      ),
                    );
                  }
                );
              },
            )
          ]),
        ),
        child: GestureDetector(
          //点击空白区域收起键盘
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
                SizedBox(height: 150.0,),
                Container(
                  //方程输入窗口
                  padding: EdgeInsets.only(left: 12.0, bottom: 50.0),
                  child: CupertinoTextField(
                    clearButtonMode: OverlayVisibilityMode.editing,
                    focusNode: _lineQuasFocusNode,
                    controller: _lineQuasController,
                    textCapitalization: TextCapitalization.words,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.0, color: CupertinoColors.inactiveGray)),
                    ),
                    placeholder: 'Equation',
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, bottom: 50.0,),
                  child: CupertinoTextField(
                    clearButtonMode: OverlayVisibilityMode.editing,
                    focusNode: _varFocusNode,
                    controller: _varController,
                    textCapitalization: TextCapitalization.words,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.0, color: CupertinoColors.inactiveGray)),
                    ),
                    placeholder: 'Parameter',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0,),
                  child: CupertinoButton(
                    color: Colors.blue,
                    onPressed: () => _handleLineEquation(),
                    child: Text(XiaomingLocalizations.of(context).calculate),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: result));
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 1000),
                          content: new Text(
                              XiaomingLocalizations.of(context).copyHint),
                        ));
                      },
                      child: Text(
                        result,
                        style: TextStyle(color: Colors.purple, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: animation,
                  //result.length == 0 ? 1.0 : 0.0,
                  child: CupertinoButton(
                    child: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        result = "";
                        controller.reverse();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLineEquation() {
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
          result = XiaomingLocalizations.of(context).variableNotEmpty;
        });
      }
    } else {
      setState(() {
        result = XiaomingLocalizations.of(context).equationNotEmpty;
      });
    }
    controller.forward();
  }
}

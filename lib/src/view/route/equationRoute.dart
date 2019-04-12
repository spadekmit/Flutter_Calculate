import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/command/handleEquations.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/myButtons.dart';

class EquationRoute extends StatefulWidget {
  EquationRoute({Key key}) : super(key: key);
  @override
  _EquationRouteState createState() => _EquationRouteState();
}

class _EquationRouteState extends State<EquationRoute>
    with TickerProviderStateMixin {
  final TextEditingController _lineQuasController = TextEditingController();
  final FocusNode _lineQuasFocusNode = new FocusNode();
  AnimationController controller;
  Animation<double> animation;
  String result = '';

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData.nowPage = 1;
    UserData.pageContext = context;

    Widget _buildListView() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(XiaomingLocalizations.of(context).equationTip),
          SizedBox(
            height: 50.0,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Card(
              elevation: 0.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  clearButtonMode: OverlayVisibilityMode.editing,
                  focusNode: _lineQuasFocusNode,
                  controller: _lineQuasController,
                  textCapitalization: TextCapitalization.words,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 0.0, color: CupertinoColors.black)),
                  ),
                  placeholder: 'Equation',
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
            ),
            child: CupertinoButton(
              color: Colors.blue,
              onPressed: () => _handleLineEquation(),
              child: Text(XiaomingLocalizations.of(context).calculate),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: GestureDetector(
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(text: result));
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title:
                              Text(XiaomingLocalizations.of(context).copyHint),
                        );
                      });
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
            child: CupertinoButton(
              child: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  result = "";
                  controller.reverse();
                });
              },
            ),
          ),
        ],
      );
    }

    ///主界面
    return DefaultTextStyle(
      ///指定默认文字格式
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          trailing: buildTrailingBar(<Widget>[
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(XiaomingLocalizations.of(context).sample),
              onPressed: () {
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
                    });
              },
            ),
          ]),
          middle: Text(XiaomingLocalizations.of(context).equations),
          previousPageTitle: "Functions",
        ),
        child: GestureDetector(
          //点击空白区域收起键盘
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _lineQuasFocusNode.unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQueryData.fromWindow(window).padding.top,
              child: _buildListView(),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLineEquation() {
    _lineQuasFocusNode.unfocus();
    if (_lineQuasController.text.length != 0) {
      EquationsUtil handle = EquationsUtil.getInstance();
      var re = handle.handleEquation(_lineQuasController.text);
      setState(() {
        result = re;
      });
    } else {
      setState(() {
        result = XiaomingLocalizations.of(context).equationNotEmpty;
      });
    }
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/command/handleEquations.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/myTextComposer.dart';

List<Widget> _buildTips(BuildContext context) {
  return <Widget>[
    Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Text(XiaomingLocalizations.of(context).equationTip)),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(XiaomingLocalizations.of(context).equaHint1),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(XiaomingLocalizations.of(context).equaHint2),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(XiaomingLocalizations.of(context).equaHint3),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(XiaomingLocalizations.of(context).equaHint4),
    ),
    SizedBox(
      height: 20.0,
    ),
  ];
}

class EquationRoute extends StatefulWidget {
  EquationRoute({Key key}) : super(key: key);
  @override
  _EquationRouteState createState() => _EquationRouteState();
}

class _EquationRouteState extends State<EquationRoute>
    with TickerProviderStateMixin {
  final TextEditingController _lineQuasController = TextEditingController();
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
    if (Provide.value<UserData>(context).theme == "IOS") {
      UserData.nowPage = 1;
      UserData.pageContext = context;
    }else {
      UserData.nowPage = 0;
    }

    List<Widget> widgets = <Widget>[
      MyTextField(
          _lineQuasController, XiaomingLocalizations.of(context).equations),
      CupertinoButton(
        color: Colors.blue,
        onPressed: () => _handleLineEquation(),
        child: Text(XiaomingLocalizations.of(context).calculate),
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
                      title: Text(XiaomingLocalizations.of(context).copyHint),
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
    ];

    widgets.insertAll(0, _buildTips(context));

    ///主界面
    return DefaultTextStyle(
      ///指定默认文字格式
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: Provide<UserData>(
        builder: (context, child, ud) {
          return CupertinoPageScaffold(
            navigationBar: ud.theme == "IOS"
                ? CupertinoNavigationBar(
                    middle: Text("Equations"),
                    previousPageTitle: "Functions",
                  )
                : null,
            backgroundColor: CupertinoColors.lightBackgroundGray,
            child: GestureDetector(
              //点击空白区域收起键盘
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQueryData.fromWindow(window).padding.top,
                  child: Column(
                    children: widgets,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLineEquation() {
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

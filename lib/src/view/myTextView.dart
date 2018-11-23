import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

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

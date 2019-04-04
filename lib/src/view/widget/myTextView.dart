import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///单个输出文本的视图
class TextView extends StatelessWidget {
  TextView({this.context, this.text, this.animationController});
  final BuildContext context;
  final AnimationController animationController;
  final String text;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18.0)),
            color: CupertinoColors.lightBackgroundGray,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          child: new Text(text,
              style: TextStyle(
                fontSize: 18.0,
                color: CupertinoColors.black,
                fontWeight: FontWeight.w400,
              )),
        ),
        onLongPress: _handleLongPress,
      ),
    );
  }

  void _handleLongPress() {
    Clipboard.setData(new ClipboardData(text: text));
    Navigator.of(context, rootNavigator: true);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(XiaomingLocalizations.of(context).copyHint),
          );
        });
  }
}

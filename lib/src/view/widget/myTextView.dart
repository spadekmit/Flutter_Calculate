import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///单个输出文本的视图
class TextView extends StatelessWidget {
  TextView({this.text, this.animationController});
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
        onLongPress: () => _handleLongPress(context),
      ),
    );
  }

  void _handleLongPress(context) {
    Clipboard.setData(new ClipboardData(text: text));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(XiaomingLocalizations.of(context).copyHint),
          );
        });
  }
}

Widget buildTextListView({Stream stream}) {
  List<TextView> list = <TextView>[];
  return StreamBuilder<List<TextView>>(
    stream: stream,
    builder: (context, snapshot) {
      return ListView.builder(
        padding: const EdgeInsets.only(left: 5.0),
        reverse: true,
        itemBuilder: (context, index) => snapshot.data[index],
      );
    },
  );
}

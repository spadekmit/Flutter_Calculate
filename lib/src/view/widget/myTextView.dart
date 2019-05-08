import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///主界面单个输出文本的视图
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

//主界面消息列表视图
class TextListView extends StatefulWidget {
  TextListView(this.controller);

  final StreamController<String> controller;
  @override
  _TextListViewState createState() => _TextListViewState(controller);
}

class _TextListViewState extends State<TextListView> with TickerProviderStateMixin {
  _TextListViewState(this.controller);
  static List<TextView> list = <TextView>[];
  final StreamController<String> controller;

  @override
  Widget build(BuildContext context) {
    if (list.length == 0) {
      return CupertinoActivityIndicator();
    }
    return StreamBuilder<String>(
      stream: controller.stream,
      builder: (context, snapshot) {
        TextView textView = TextView(text: snapshot.data, animationController: AnimationController(
            duration: new Duration(milliseconds: 200), vsync: this),);
        textView.animationController.forward();
        list.insert(0, textView);

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(left: 5.0),
          itemBuilder: (context, index) {
            return list[index];
          },
          itemCount: list.length,
        );
      }
    );
  }
}

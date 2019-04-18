import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnChanged = void Function(String text);

///输入框和发送按钮
class TextComposer extends StatelessWidget {
  TextComposer(
      {this.textFocusNode,
      this.textController,
      this.onChanged,
      this.onSubmitted,
      this.isComposing});

  final FocusNode textFocusNode;
  final TextEditingController textController;
  final OnChanged onChanged;
  final OnChanged onSubmitted;
  final bool isComposing;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      SizedBox(
        width: 10.0,
      ),
      Flexible(
        child: CupertinoTextField(
          clearButtonMode: OverlayVisibilityMode.editing,
          focusNode: textFocusNode,
          maxLines: 1,
          placeholder: 'Input Command',
          controller: textController,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: CupertinoColors.inactiveGray,
              width: 0.0,
            ),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ),
      new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
        child: new CupertinoButton(
          child: new Icon(CupertinoIcons.forward),
          onPressed:
              isComposing ? () => onSubmitted(textController.text) : null,
        ),
      ),
    ]);
  }
}

class MyTextField extends StatelessWidget {
  MyTextField(this._controller, this.tip);

  final TextEditingController _controller;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Card(
        elevation: 0.0,
        child: TextField(
          decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: tip,
                  suffixStyle: TextStyle(color: Colors.green),
                ),
          controller: _controller,
          textCapitalization: TextCapitalization.words,
        ),
      ),
    );
  }
}

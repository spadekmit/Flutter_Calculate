import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/view/route/helpRoute.dart';

class DeleteButton extends StatelessWidget {
  DeleteButton(this.routeCode, this.onPressed, {Key key}) : super(key: key);

  final int routeCode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Semantics(
        label: 'Delete',
        child: const Icon(CupertinoIcons.delete),
      ),
      onPressed: onPressed,
    );
  }
}

Widget buildTrailingBar (List<Widget> buttons) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: buttons,
  );
}

Widget buildHelpButton (BuildContext context) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    child: Semantics(
      label: 'Help',
      child: const Icon(CupertinoIcons.book),
    ),
    onPressed: () {
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (BuildContext context) {
        return HelpView();
      }));
    },
  );
}

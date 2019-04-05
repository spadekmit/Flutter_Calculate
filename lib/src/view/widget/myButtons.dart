import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/helpRoute.dart';

class DeleteButton extends StatelessWidget {
  DeleteButton(this.onPressed, {Key key}) : super(key: key);
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

class SettingButton extends StatelessWidget {
  SettingButton(this.onPressed);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Icon(CupertinoIcons.settings),
      onPressed: () {
        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return SettingSheet(onPressed);
            });
      },
    );
  }
}

class SettingSheet extends StatefulWidget {
  SettingSheet(this.onPressed);
  final VoidCallback onPressed;
  @override
  _SettingSheetState createState() => _SettingSheetState(onPressed);
}

class _SettingSheetState extends State<SettingSheet> {
  _SettingSheetState(this.onPressed);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
        title: Text(XiaomingLocalizations.of(context).decimalDigits),
        message: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoSlider(
              divisions: 8,
              max: 9.0,
              min: 1.0,
              value: SettingData.fixedNum,
              onChanged: (double d) {
                setState(() {
                  SettingData.fixedNum = d;
                });
                SettingData.writeSettingData();
              },
            ),
            Text(SettingData.fixedNum.toString()),
          ],
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(context);
              onPressed();
            },
            child: const Text("Delete All Message"),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      );
  }
}

Widget buildTrailingBar(List<Widget> buttons) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: buttons,
  );
}

Widget buildHelpButton(BuildContext context) {
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

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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SettingDialog(onPressed);
            });
      },
    );
  }
}

class SettingDialog extends StatefulWidget {
  SettingDialog(this.onPressed);
  final VoidCallback onPressed;
  @override
  _SettingDialogState createState() => _SettingDialogState(onPressed);
}

class _SettingDialogState extends State<SettingDialog> {
  _SettingDialogState(this.onPressed);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            XiaomingLocalizations.of(context).decimalDigits + ":",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Row(
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
          Divider(
            height: 1.0,
            color: CupertinoColors.black,
          ),
          CupertinoButton(
            onPressed: onPressed,
            child: Text("Delete All Message"),
          )
        ],
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

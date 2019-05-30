import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/userData.dart';
import 'package:xiaoming/src/view/route/helpRoute.dart';
import 'package:xiaoming/src/view/widget/setttingSheet.dart';

typedef OnCommit = void Function(String text);

//顶部删除按钮
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

//顶部设置按钮
class SettingButton extends StatelessWidget {
  SettingButton(this._onPressed, this._isIOS);
  final VoidCallback _onPressed;
  final bool _isIOS;
  @override
  Widget build(BuildContext context) {
    return _isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.settings),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingSheet(_onPressed);
                  });
            },
          )
        : IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingSheet(_onPressed);
                  });
            },
          );
  }
}

//构造IOS风格导航栏按钮
Widget buildTrailingBar(List<Widget> buttons) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: buttons,
  );
}

//顶部帮助按钮
Widget buildHelpButton(BuildContext context, bool isIOS) {
  return isIOS
      ? CupertinoButton(
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
        )
      : IconButton(
          icon: Icon(Icons.help),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (BuildContext context) {
              return HelpView();
            }));
          },
        );
}

///创建便捷输入按钮
Widget _buildTextButton(String label, OnCommit onPressed,
    {double width = 50.0}) {
  return LimitedBox(
    maxWidth: width,
    child: new FlatButton(
      padding: const EdgeInsets.all(0.0),
      onPressed: () => onPressed(label),
      child: new Text(label, style: new TextStyle(fontSize: 14.0)),
    ),
  );
}

///创建跟随键盘弹出的便捷输入按钮栏
Widget buildButtons(OnCommit onPressed) {
  return Column(children: <Widget>[
    Divider(color: CupertinoColors.black,height: 1.0,),
    Flexible(
      child: CupertinoScrollbar(
        child: _buildMethodButtons(onPressed),
      ),
    ),
    Divider(color: CupertinoColors.black,height: 1.0,),
    LimitedBox(
      maxHeight: 40,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTextButton(',', onPressed),
          _buildTextButton(';', onPressed),
          _buildTextButton(':', onPressed),
          _buildTextButton('[', onPressed),
          _buildTextButton('=', onPressed),
          _buildTextButton('(', onPressed),
        ],
      ),
    ),
    Divider(color: CupertinoColors.black,height: 1.0,),
    LimitedBox(
      maxHeight: 40,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTextButton('^', onPressed),
          _buildTextButton('+', onPressed),
          _buildTextButton('-', onPressed),
          _buildTextButton('*', onPressed),
          _buildTextButton('/', onPressed),
        ],
      ),
    ),
    Divider(color: CupertinoColors.black,height: 1.0,),
  ]);
}

///构造内置方法及用户自定义方法的按钮列表
Widget _buildMethodButtons(OnCommit onPressed) {
  return Provide<UserData>(
    builder: (context, child, ud) {
      List<Widget> list = [];
      if (ud.userFunctions.isNotEmpty) {
        int i = 0;
        var blist = <Widget>[];
        ud.userFunctions.forEach((u) {
          blist.add(_buildTextButton(u.funName + '(', onPressed,
              width: double.infinity));
          i++;
          if (i == 4) {
            list.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: blist,
            ));
            blist.clear();
            i = 0;
          }
        });
        if (i != 0) {
          list.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: blist,
          ));
        }
      }
      list
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('Fun', onPressed, width: double.infinity),
            _buildTextButton('inv(', onPressed, width: double.infinity),
            _buildTextButton('tran(', onPressed, width: double.infinity),
            _buildTextButton('value(', onPressed, width: double.infinity),
          ],
        ))
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('upmat(', onPressed, width: double.infinity),
            _buildTextButton('cofa(', onPressed, width: double.infinity),
            _buildTextButton('calculus(', onPressed, width: double.infinity),
            _buildTextButton('roots(', onPressed, width: double.infinity),
          ],
        ))
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('sum(', onPressed, width: double.infinity),
            _buildTextButton('average(', onPressed, width: double.infinity),
            _buildTextButton('factorial(', onPressed, width: double.infinity),
            _buildTextButton('sin(', onPressed, width: double.infinity),
          ],
        ))
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('cos(', onPressed, width: double.infinity),
            _buildTextButton('tan(', onPressed, width: double.infinity),
            _buildTextButton('asin(', onPressed, width: double.infinity),
            _buildTextButton('acos(', onPressed, width: double.infinity),
          ],
        ))
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('atan(', onPressed, width: double.infinity),
            _buildTextButton('formatDeg(', onPressed, width: double.infinity),
            _buildTextButton('reForDeg(', onPressed, width: double.infinity),
            _buildTextButton('absSum(', onPressed, width: double.infinity),
          ],
        ))
        ..add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('absAverage(', onPressed, width: double.infinity),
            _buildTextButton('radToDeg(', onPressed, width: double.infinity),
            _buildTextButton('degToRad(', onPressed, width: double.infinity),
            _buildTextButton('lagrange(', onPressed, width: double.infinity),
          ],
        ));
      return ListView(
        reverse: true,
        children: list,
      );
    },
  );
}

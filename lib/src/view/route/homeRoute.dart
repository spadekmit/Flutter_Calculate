import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/dbUtil.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/data/userData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/myButtons.dart';
import 'package:xiaoming/src/view/widget/myTextComposer.dart';
import 'package:xiaoming/src/view/widget/myTextView.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key}) : super(key: key);

  @override
  HomeRouteState createState() => new HomeRouteState();
}

class HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin {
  TextEditingController
      _textController; // _textController用来获取输入文本和控制输入焦点// _textFocusNode用来控制键盘弹出/收回
  static List<TextView> _texts; //存储消息的列表
  bool _isComposing = false; //判断是否有输入
  bool isComplete = true; //计算是否完成
  static bool _isInit = false;
  final StreamController<double> _streamController = StreamController<double>.broadcast();

  ///初始化对象及加载数据
  @override
  void initState() {
    super.initState();
    if (!_isInit) readText();
    SettingData.nowPage = 0;
    _textController = new TextEditingController();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          if(this.mounted) {
            _streamController.sink.add(200.0);
          }
        } else {
          if(this.mounted) {
            _streamController.sink.add(0.0);
          }
        }
      },
    );
  }

  ///退出该路由时释放动画资源
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _streamController.close();

    ///当切换主题时，主动调用animationController.dispose() 会触发多次dispose的异常
    // for (TextView textView in _texts) {
    //   if (textView.animationController != null) {
    //     textView.animationController?.dispose();
    //   }
    // }
  }

  ///home界面布局
  @override
  Widget build(BuildContext context) {

    ///主界面布局
    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: _buildScaffold(),
    );
  }

  ///消息列表，未加载完成时显示加载中动画
  Widget _buildList() {
    if (!_isInit) {
      return Center(child: CupertinoActivityIndicator());
    } else {
      if (isComplete) {
        return Column(
          children: <Widget>[
            Flexible(
                child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(left: 5.0),
                itemBuilder: (context, index) {
                  return _texts[index];
                },
                itemCount: _texts.length,
              ),
            )),
            StreamBuilder<double>(
                stream: _streamController.stream,
                initialData: 0.0,
                builder: (context, snapshot) {
                  return AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                      height: snapshot.data,
                      child: buildButtons(_handleTextButton),
                    ),
                  );
                }),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(
                textController: _textController,
                isComposing: _isComposing,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: (text) => _handleSubmitted(text, context),
              ),
            ),
            StreamBuilder<double>(
                stream: _streamController.stream,
                initialData: MediaQuery.of(context).padding.bottom,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: snapshot.data == 200.0
                        ? 0.0
                        : MediaQuery.of(context).padding.bottom,
                  );
                }),
          ],
        );
      } else {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(),
            Text("正在计算中"),
          ],
        ));
      }
    }
  }

  Widget _buildScaffold() {
    return Provide<SettingData>(
      builder: (context, child, sd) {
        return sd.theme == "IOS"
            ? CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  key: Key("IOSAppBar"),
                  trailing: buildTrailingBar(<Widget>[
                    buildHelpButton(context, true),
                    const SizedBox(
                      width: 8.0,
                    ),
                    SettingButton(_deleteAllMessage, true),
                  ]),
                  middle: Text("Home"),
                ),
                resizeToAvoidBottomInset: true,
                child: _buildList(),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey,
                  centerTitle: true,
                  key: Key("AndAppBar"),
                  title: Text("Home"),
                  actions: <Widget>[
                    buildHelpButton(context, false),
                    const SizedBox(
                      width: 8.0,
                    ),
                    SettingButton(_deleteAllMessage, false),
                  ],
                ),
                body: _buildList(),
              );
      },
    );
  }

  ///删除所有交互命令
  void _deleteAllMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Provide<SettingData>(builder: (context, child, sd) {
          return sd.theme == "IOS"
              ? CupertinoAlertDialog(
                  title:
                      Text(XiaomingLocalizations.of(context).deleteAllMessage),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text(XiaomingLocalizations.of(context).delete),
                      onPressed: () {
                        setState(() {
                          _texts.clear();
                        });
                        DBUtil.deleteAllMessage();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(XiaomingLocalizations.of(context).cancel),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                )
              : AlertDialog(
                  title:
                      Text(XiaomingLocalizations.of(context).deleteAllMessage),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(XiaomingLocalizations.of(context).delete),
                      onPressed: () {
                        setState(() {
                          _texts.clear();
                        });
                        DBUtil.deleteAllMessage();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(XiaomingLocalizations.of(context).cancel),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                );
        });
      },
    );
  }

  /// 处理便捷输入按钮的点击事件
  void _handleTextButton(String text) {
    int temp = 0;
    String bracket = text.substring(text.length - 1);
    if (bracket == '(') {
      text = text + ')';
      temp = 1;
    } else if (bracket == '[') {
      text = text + ']';
      temp = 1;
    }
    if (_textController.selection.isValid) {
      int index = _textController.value.selection.extentOffset;
      String newStr = _textController.text.substring(0, index) +
          text +
          _textController.text.substring(index, _textController.text.length);
      setState(() {
        _isComposing = true;
      });
      _textController.value = new TextEditingValue(
        text: newStr,
        selection:
            new TextSelection.collapsed(offset: index + text.length - temp),
      );
    } else {
      _textController.value = new TextEditingValue(
        text: text,
        selection: new TextSelection.collapsed(offset: text.length - temp),
      );
    }
  }

  ///处理发送按钮的点击事件
  void _handleSubmitted(String text, BuildContext context) {
    _textController.clear();
    setState(() {
      _isComposing = false;
      isComplete = false;
    });
    Provide.value<UserData>(context).handleCommand(text).then((handleText) {
      DBUtil.addMessage(text);
      DBUtil.addMessage(handleText);
      TextView textView1 = new TextView(
          text: text,
          animationController: new AnimationController(
              duration: new Duration(milliseconds: 200), vsync: this));
      TextView textView2 = new TextView(
          text: handleText,
          animationController: new AnimationController(
              duration: new Duration(milliseconds: 200), vsync: this));
      setState(() {
        _texts.insert(0, textView1);
        _texts.insert(0, textView2);
        isComplete = true;
      });
      textView1.animationController.forward();
      textView2.animationController.forward();
    });
  }

  ///加载数据库中的历史数据
  void readText() {
    _texts = List<TextView>();
    DBUtil.getDB().then((db) {
      db.rawQuery('select * from Message').then((list) {
        setState(() {
          list.forEach((m) {
            var textView = TextView(
              text: m['msg'],
              animationController: AnimationController(
                  duration: new Duration(milliseconds: 200), vsync: this),
            );
            _texts.insert(0, textView);
            textView.animationController.forward();
          });
          _isInit = true;
        });
      });
    });
  }
}

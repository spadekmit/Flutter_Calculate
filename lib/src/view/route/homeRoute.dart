import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/data/dbUtil.dart';
import 'package:xiaoming/src/data/settingData.dart';
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
  bool _buttonsIsVisible = false; //控制便捷输入栏显示与隐藏
  double tabHeight; //输入框底部高度（防止被底部导航栏遮挡）
  bool isComplete = true; //计算是否完成
  static bool _isInit = false;
  UserData ud;

  ///初始化对象及加载数据
  @override
  void initState() {
    super.initState();
    if (!_isInit) readText();
    UserData.nowPage = 0;
    SettingData.readSettingData(); //读取设置数据
    _textController = new TextEditingController();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          setState(() {
            tabHeight = 0.0;
            _buttonsIsVisible = true;
          });
        } else {
          setState(() {
            tabHeight = MediaQuery.of(context).padding.bottom;
            _buttonsIsVisible = false;
          });
        }
      },
    );
  }

  ///home界面布局
  @override
  Widget build(BuildContext context) {
    ud = Provide.value<UserData>(context);
    tabHeight = MediaQuery.of(context).padding.bottom; //初始化底部导航栏高度

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
            Divider(
              height: _buttonsIsVisible ? 1.0 : 0.0,
              color: _buttonsIsVisible ? Colors.black : null,
            ),
            AnimatedSize(
              vsync: this,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
              child: Container(
                height: _buttonsIsVisible ? 200.0 : 0.0,
                child: buildButtons(_handleTextButton),
              ),
            ),
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
                onSubmitted: _handleSubmitted,
              ),
            ),
            new SizedBox(
              height: tabHeight,
            ),
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
    return Provide<UserData>(
      builder: (context, child, ud) {
        return ud.theme == "IOS"
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
        return Provide<UserData>(builder: (context, child, ud) {
          return ud.theme == "IOS"
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
  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
      isComplete = false;
    });
    ud.handleCommand(text).then((handleText) {
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

  ///退出该路由时释放动画资源
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    for (TextView textView in _texts) {
      textView.animationController.dispose();
    }
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

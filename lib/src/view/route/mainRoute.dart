import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xiaoming/src/command/handleCommand.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/ChineseCupertinoLocalizations.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/helpRoute.dart';
import 'package:xiaoming/src/view/widget/myTextView.dart';
import 'package:xiaoming/src/view/route/dataRoute.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:xiaoming/src/view/widget/DeleteButton.dart';

///FlutterApp入口
class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ChineseCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        XiaomingLocalizationsDelegate.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', 'CH'),
      ],
      home: myTabScaffold,
    );
  }
}

final Widget myTabScaffold = CupertinoTabScaffold(
    tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        title: Text("Home"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.save),
        title: Text("Saved"),
      ),
    ]),
    tabBuilder: (BuildContext context, int index) {
      switch (index) {
        case 0:
          return CupertinoTabView(builder: (BuildContext context) {
            return TextScreen();
          });
          break;
        case 1:
          return CupertinoTabView(builder: (BuildContext context) {
            return DataRoute();
          });
      }
    });

/// 主界面，包含一个listview显示输出的文本，一个输入框和发送按钮，两排方便输入的按钮
/// _texts用来存储要显示的文本
/// _textFocusNode用来控制键盘弹出/收回
/// _textController用来获取输入文本和控制输入焦点
/// funMap存储自带函数和自定义函数
/// 状态栏包含两个菜单控件，用来进入函数界面和数据界面
class TextScreenState extends State<TextScreen> with TickerProviderStateMixin {
  TextEditingController _textController;
  FocusNode _textFocusNode;
  List<TextView> _texts = <TextView>[]; //存储消息的列表
  bool _isComposing = false;
  bool _buttonsIsVisible = false;
  double tabHeight;

  ///初始化对象及加载数据
  @override
  void initState() {
    SettingData.readSettingData(); //读取设置数据
    _textController = new TextEditingController();
    _textFocusNode = new FocusNode();
    UserData.strs.forEach((text) {
      //将保存的历史消息添加进列表并播放动画
      var textView = TextView(
        context: context,
        text: text,
        animationController: AnimationController(
            duration: new Duration(milliseconds: 200), vsync: this),
      );
      _texts.add(textView);
      textView.animationController.forward(); //执行完动画Widget才可见
    });

    ///添加虚拟键盘事件监听器
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //记录当前语言
    UserData.language = Localizations.localeOf(context).languageCode;
    tabHeight = MediaQuery.of(context).padding.bottom; //初始化底部导航栏高度

    ///Home界面导航栏，包含帮助按钮和删除按钮
    final Widget trailingBar = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CupertinoButton(
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
        ),
        const SizedBox(
          width: 8.0,
        ),
        DeleteButton(0, () {
          Navigator.of(context, rootNavigator: true);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title:
                      Text(XiaomingLocalizations.of(context).deleteAllMessage),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text(XiaomingLocalizations.of(context).delete),
                      onPressed: () {
                        setState(() {
                          UserData.strs.clear();
                          _texts.clear();
                        });
                        UserData.deleteAllMessage();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(XiaomingLocalizations.of(context).cancel),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                );
              });
        }),
      ],
    );

    ///主界面布局
    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: trailingBar,
        ),
        resizeToAvoidBottomInset: true,
        child: Column(
          children: <Widget>[
            new Flexible(
                child: new GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _textFocusNode.unfocus();
                    },
                    child: new ListView.builder(
                      padding: new EdgeInsets.only(left: 5.0),
                      reverse: true,
                      itemBuilder: (context, int index) {
                        //_texts[index].context = context;
                        return _texts[index];
                      },
                      itemCount: _texts.length,
                    ))),
            new Divider(
              height: 1.0,
              color: _buttonsIsVisible ? Colors.black : null,
            ),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Container(
                height: _buttonsIsVisible ? 200.0 : 0.0,
                child: _buildButtons(),
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(context),
            ),
            new SizedBox(
              height: tabHeight,
            ),
          ],
        ),
      ),
    );
  }

  ///输入控件，包含一个输入框和一个按钮
  Widget _buildTextComposer(BuildContext context) {
    return Row(children: <Widget>[
      SizedBox(
        width: 10.0,
      ),
      Flexible(
        child: CupertinoTextField(
          focusNode: _textFocusNode,
          maxLines: 1,
          placeholder: 'Input Command',
          controller: _textController,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: CupertinoColors.inactiveGray,
              width: 0.0,
            ),
          ),
          onChanged: (String text) {
            setState(() {
              _isComposing = text.length > 0;
            });
          },
          onSubmitted: (String text) => _handleSubmitted(context, text),
        ),
      ),
      new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
        child: new CupertinoButton(
          child: new Icon(CupertinoIcons.forward),
          onPressed: _isComposing
              ? () => _handleSubmitted(context, _textController.text)
              : null,
        ),
      ),
    ]);
  }

  ///处理发送按钮的点击事件
  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    UserData.strs.insert(0, text);
    String handleText = handleCommand(text);
    UserData.strs.insert(0, handleText);
    UserData.addMessage(text);
    UserData.addMessage(handleText);
    TextView textView1 = new TextView(
        text: text,
        context: context,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 200), vsync: this));
    TextView textView2 = new TextView(
        text: handleText,
        context: context,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 200), vsync: this));
    setState(() {
      _texts.insert(0, textView1);
      _texts.insert(0, textView2);
    });

    textView1.animationController.forward();
    textView2.animationController.forward();
  }

  //创建便捷输入按钮
  Widget _buildTextButton(String label, {double width = 50.0}) {
    return LimitedBox(
      maxWidth: width,
      child: new FlatButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: () => _handleTextButton(label),
        child: new Text(label, style: new TextStyle(fontSize: 14.0)),
      ),
    );
  }

  ///创建方便输入的按钮栏
  Widget _buildButtons() {
    return Column(children: <Widget>[
      Flexible(
        child: CupertinoScrollbar(
          child: ListView(
            reverse: true,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildTextButton('Fun', width: double.infinity),
                  _buildTextButton('inv(', width: double.infinity),
                  _buildTextButton('tran(', width: double.infinity),
                  _buildTextButton('value(', width: double.infinity),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildTextButton('upmat(', width: double.infinity),
                  _buildTextButton('cofa(', width: double.infinity),
                  _buildTextButton('calculus(', width: double.infinity),
                  _buildTextButton('roots(', width: double.infinity),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildTextButton('sum(', width: double.infinity),
                  _buildTextButton('average(', width: double.infinity),
                  _buildTextButton('factorial(', width: double.infinity),
                  _buildTextButton('sin(', width: double.infinity),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildTextButton('cos(', width: double.infinity),
                  _buildTextButton('tan(', width: double.infinity),
                  _buildTextButton('asin(', width: double.infinity),
                  _buildTextButton('acos(', width: double.infinity),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildTextButton('atan(', width: double.infinity),
                  _buildTextButton('formatDeg(', width: double.infinity),
                  _buildTextButton('reForDeg(', width: double.infinity),
                  _buildTextButton('absSum(', width: double.infinity),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildTextButton('absAverage(', width: double.infinity),
                  _buildTextButton('radToDeg(', width: double.infinity),
                  _buildTextButton('lagrange(', width: double.infinity),
                ],
              ),
            ],
          ),
        ),
      ),
      Divider(height: 1.0),
      LimitedBox(
        maxHeight: 40,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton(','),
            _buildTextButton(';'),
            _buildTextButton(':'),
            _buildTextButton('['),
            _buildTextButton('='),
            _buildTextButton('('),
          ],
        ),
      ),
      Divider(height: 1.0),
      LimitedBox(
        maxHeight: 40,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTextButton('^'),
            _buildTextButton('+'),
            _buildTextButton('-'),
            _buildTextButton('*'),
            _buildTextButton('/'),
          ],
        ),
      ),
    ]);
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

  ///退出该路由时释放动画资源
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    for (TextView textView in _texts) {
      textView.animationController.dispose();
    }
    _textFocusNode.dispose();
  }
}

class TextScreen extends StatefulWidget {
  TextScreen({Key key}) : super(key: key);

  @override
  TextScreenState createState() => new TextScreenState();
}

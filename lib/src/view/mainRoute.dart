import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/view/dataRoute.dart';
import 'package:xiaoming/src/view/helpRoute.dart';
import 'package:xiaoming/src/view/equationRoute.dart';
import 'package:xiaoming/src/view/methodRoute.dart';
import 'package:xiaoming/src/view/myTextView.dart';
import 'package:xiaoming/src/view/settingRoute.dart';
import 'package:xiaoming/src/command/handleCommand.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:xiaoming/src/view/widget/buttons.dart';

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData.loadData();
    return new MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        XiaomingLocalizationsDelegate.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', 'CH'),
      ],
      onGenerateTitle: (context) {
        return XiaomingLocalizations.of(context).appName;
      },
      theme: new ThemeData(
        primaryColor: Colors.white, //使用白色的颜色主题
      ),
      home: new TextScreen(),
    );
  }
}

/// 主界面，包含一个listview显示输出的文本，一个输入框和发送按钮，两排方便输入的按钮
/// _texts用来存储要显示的文本
/// _textFocusNode用来控制键盘弹出/收回
/// _textController用来获取输入文本和控制输入焦点
/// funMap存储自带函数和自定义函数
/// 状态栏包含两个菜单控件，用来进入函数界面和数据界面
class TextScreenState extends State<TextScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  final FocusNode _textFocusNode = new FocusNode();
  final List<TextView> _texts = <TextView>[]; //存储消息的列表
  bool _isComposing = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

    UserData.strs.forEach((String str) {
      _texts.insert(
          0,
          TextView(
            context: context,
            text: str,
            animationController: new AnimationController(
                duration: new Duration(milliseconds: 200), vsync: this),
          ));
    });

    _textFocusNode.addListener(() {
      if (SettingData.isAutoExpanded) {
        if (_textFocusNode.hasFocus) {
          setState(() {
            _isExpanded = true;
          });
        }
      }
    });

    return new Scaffold(
        drawer: new Drawer(
          child: new ListView(
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: new Center(
                    child: new Text(
                      'K',
                      style: TextStyle(
                          fontSize: 35.0, fontStyle: FontStyle.italic),
                    ),
                  )),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(XiaomingLocalizations.of(context).setting),
                onTap: () => settingRoute(context),
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text(XiaomingLocalizations.of(context).saved_function),
                onTap: () => popmethodRoute(context),
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text(XiaomingLocalizations.of(context).saved_Data),
                onTap: () => popdataRoute(context),
              ),
              ListTile(
                leading: Icon(Icons.extension),
                title: Text(XiaomingLocalizations.of(context).solve_equation),
                onTap: () => popEquationsRoute(context),
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          elevation: 1.0,
          title: new Text(XiaomingLocalizations.of(context).appName),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.help),
              onPressed: () => pophelpRoute(context),
            )
          ],
          //AppBar显示的标题
        ),
        body: Builder(
            builder: (context) => Column(
                  children: <Widget>[
                    new Flexible(
                        child: new GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _textFocusNode.unfocus();
                              setState(() {
                                _isExpanded = false;
                              });
                            },
                            child: new ListView.builder(
                              padding: new EdgeInsets.only(left: 5.0),
                              reverse: true,
                              itemBuilder: (_, int index) => _texts[index],
                              itemCount: _texts.length,
                            ))),
                    new Divider(height: 1.0),
                    new Container(
                      decoration: new BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      // height: 200.0,
                      child: InputButtons(onTapButton: (String text) => _handleTextButton(text),),
                    ),
                    new Divider(height: 1.0),
                    new Container(
                      decoration: new BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: _buildTextComposer(context),
                    )
                  ],
                )));
  }

  ///输入控件，包含一个输入框和一个按钮
  Widget _buildTextComposer(BuildContext context) {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: GestureDetector(
          onTap: () => setState(() {
                _isExpanded = true;
              }),
          child: SafeArea(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: TextField(
                          focusNode: _textFocusNode,
                          maxLines: null,
                          controller: _textController,
                          onChanged: (String text) {
                            setState(() {
                              _isComposing = text.length > 0;
                            });
                          },
                          onSubmitted: (String text) =>
                              _handleSubmitted(context, text),
                          decoration: new InputDecoration.collapsed(
                              hintText:
                                  XiaomingLocalizations.of(context).inputHint),
                        ),
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 4.0),
                      child: new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () =>
                                _handleSubmitted(context, _textController.text)
                            : null,
                      ),
                    )
                  ]))),
        ));
  }

  ///处理发送按钮的点击事件
  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    setState(() {
      _isExpanded = false;
      _isComposing = false;
    });
    // TextView textView1 = new TextView(
    //     text: text,
    //     context: context,
    //     animationController: new AnimationController(
    //         duration: new Duration(milliseconds: 200), vsync: this));

    setState(() {
      UserData.strs.insert(0, text);
    });

    setState(() {
      UserData.strs.insert(0, handleCommand(text));
    });

    _texts[1].animationController.forward();
    _texts[0].animationController.forward();
  }

  // void _handleBracket(String text) {
  //   String bracket = text.substring(text.length - 1);
  //   if (bracket == '(') {
  //     text = text + ')';
  //   } else if (bracket == '[') {
  //     text = text + ']';
  //   }
  //   if (_textController.selection.isValid) {
  //     int index = _textController.value.selection.extentOffset;
  //     String newStr = _textController.text.substring(0, index) +
  //         text +
  //         _textController.text.substring(index, _textController.text.length);
  //     setState(() {
  //       _isComposing = true;
  //     });
  //     _textController.value = new TextEditingValue(
  //       text: newStr,
  //       selection: new TextSelection.collapsed(offset: index + text.length - 1),
  //     );
  //   } else {
  //     _textController.value = new TextEditingValue(
  //       text: text,
  //       selection: new TextSelection.collapsed(offset: text.length - 1),
  //     );
  //   }
  // }

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
        selection: new TextSelection.collapsed(offset: index + text.length - temp),
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
    for (TextView textView in _texts) {
      textView.animationController.dispose();
    }
    _textFocusNode.dispose();
    super.dispose();
  }
}

class TextScreen extends StatefulWidget {
  TextScreen({Key key}) : super(key: key);

  @override
  TextScreenState createState() => new TextScreenState();
}

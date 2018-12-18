import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  final ThemeData kIOSTheme = new ThemeData(
    //Cupertino主题风格
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

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
                      child: _buildMethodButtons(),
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

  ///创建方便输入方法名的按钮列
  Widget _buildMethodButtons() {
    Widget buttonsV;
    buttonsV = ExpansionPanelList(
      expansionCallback: (int i, bool b) => setState(() {
            _isExpanded = !_isExpanded;
          }),
      children: <ExpansionPanel>[
        new ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return new ListTile(
              leading: new Text(
                  XiaomingLocalizations.of(context).built_in_function,
                  style: TextStyle(fontSize: 18.0, color: Colors.deepOrange)),
            );
          },
          isExpanded: _isExpanded,
          body: LimitedBox(
            maxHeight: 250.0,
            child: Column(children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('Fun', width: double.infinity),
                        _buildBracketButton('inv(', width: double.infinity),
                        _buildBracketButton('tran(', width: double.infinity),
                        _buildBracketButton('value(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBracketButton('upmat(', width: double.infinity),
                        _buildBracketButton('cofa(', width: double.infinity),
                        _buildBracketButton('calculus(',
                            width: double.infinity),
                        _buildBracketButton('roots(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBracketButton('sum(', width: double.infinity),
                        _buildBracketButton('average(', width: double.infinity),
                        _buildBracketButton('factorial(',
                            width: double.infinity),
                        _buildBracketButton('sin(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBracketButton('cos(', width: double.infinity),
                        _buildBracketButton('tan(', width: double.infinity),
                        _buildBracketButton('asin(', width: double.infinity),
                        _buildBracketButton('acos(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBracketButton('atan(', width: double.infinity),
                        _buildBracketButton('formatDeg(',
                            width: double.infinity),
                        _buildBracketButton('reForDeg(',
                            width: double.infinity),
                        _buildBracketButton('absSum(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBracketButton('absAverage(',
                            width: double.infinity),
                        _buildBracketButton('radToDeg(',
                            width: double.infinity),
                        _buildTextButton('lagrange(', width: double.infinity),
                      ],
                    ),
                  ],
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
                    _buildBracketButton('['),
                    _buildTextButton('='),
                    _buildBracketButton('('),
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
            ]),
          ),
        ),
      ],
    );

    return buttonsV;
  }

  /// 传入标签，创建便捷输入按钮
  Widget _buildTextButton(String label, {double width = 50.0}) {
    Widget buttonCard = new LimitedBox(
      maxWidth: width,
      child: new FlatButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: () => _handleTextButton(label),
        child: new Text(label, style: new TextStyle(fontSize: 14.0)),
      ),
    );
    return buttonCard;
  }

  Widget _buildBracketButton(String label, {double width = 50.0}) {
    return LimitedBox(
      maxWidth: width,
      child: new FlatButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: () => _handleBracket(label),
        child: new Text(label, style: new TextStyle(fontSize: 14.0)),
      ),
    );
  }

  ///输入控件，包含一个输入框和一个按钮
  Widget _buildTextComposer(BuildContext context) {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new SafeArea(
            child: new Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Row(children: <Widget>[
                  new Flexible(
                      child: new Container(
                          margin: new EdgeInsets.only(left: 15.0),
                          child: new TextField(
                            focusNode: _textFocusNode,
                            maxLines: null,
                            controller: _textController,
                            onChanged: (String text) {
                              setState(() {
                                _isComposing = text.length > 0;
                                _isExpanded = true;
                              });
                            },
                            onSubmitted: (String text) =>
                                _handleSubmitted(context, text),
                            decoration: new InputDecoration.collapsed(
                                hintText: XiaomingLocalizations.of(context)
                                    .inputHint),
                          ))),
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
                ]))));
  }

  ///处理发送按钮的点击事件
  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    setState(() {
      _isExpanded = false;
      _isComposing = false;
    });
    TextView textView1 = new TextView(
        text: text,
        context: context,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 200), vsync: this));

    setState(() {
      _texts.insert(0, textView1);
    });
    TextView textView2 = new TextView(
        text: handleCommand(text),
        context: context,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 200), vsync: this));

    setState(() {
      _texts.insert(0, textView2);
    });

    textView1.animationController.forward();
    textView2.animationController.forward();
  }

  void _handleBracket(String text) {
    String bracket = text.substring(text.length - 1);
    if (bracket == '(') {
      text = text + ')';
    } else if (bracket == '[') {
      text = text + ']';
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
        selection: new TextSelection.collapsed(offset: index + text.length - 1),
      );
    } else {
      _textController.value = new TextEditingValue(
        text: text,
        selection: new TextSelection.collapsed(offset: text.length - 1),
      );
    }
  }

  /// 处理便捷输入按钮的点击事件
  void _handleTextButton(String text) {
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
        selection: new TextSelection.collapsed(offset: index + text.length),
      );
    } else {
      _textController.value = new TextEditingValue(
        text: text,
        selection: new TextSelection.collapsed(offset: text.length),
      );
    }
  }

  ///退出该路由时释放动画资源
  void dispose() {
    for (TextView textView in _texts) {
      textView.animationController.dispose();
    }
    super.dispose();
  }
}

class TextScreen extends StatefulWidget {
  TextScreen({Key key}) : super(key: key);

  @override
  TextScreenState createState() => new TextScreenState();
}

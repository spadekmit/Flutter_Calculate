import 'package:flutter/material.dart';
import 'package:xiaoming/command/handleCommand.dart';
import 'package:xiaoming/View/myview.dart';
import 'package:xiaoming/data/data.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '小明同学',
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
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: new Center(
                    child: new Text('小明同学'),
                  )),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('设置'),
                onTap: () => settingRoute(context),
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('保存的函数'),
                onTap: () => methodRoute(context),
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('保存的数据'),
                onTap: () => dataRoute(context),
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text('小明同学'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.help),
              onPressed: () => helpRoute(context),
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
                            onTap: () => _textFocusNode.unfocus(),
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
                      child: _buildMethodButtons(),
                    ),
                    new Divider(height: 1.0),
                    new Container(
                      decoration: new BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: _buildButtons(),
                    ),
                    new Divider(
                      height: 1.0,
                    ),
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
    Widget buttonsH;
    Widget buttonsV;
    buttonsV = new Card(
        child: new ExpansionPanelList(
      expansionCallback: (int i, bool b) => setState(() {
            isExpanded = !isExpanded;
          }),
      children: <ExpansionPanel>[
        new ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return new ListTile(
              leading: new Text('内置的函数',
                  style: TextStyle(fontSize: 18.0, color: Colors.deepOrange)),
            );
          },
          isExpanded: isExpanded,
          body: LimitedBox(
            maxHeight: 200.0,
            child: ListView(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildButtonCard('Fun', width: double.infinity),
                    _buildButtonCard('inv(', width: double.infinity),
                    _buildButtonCard('tran(', width: double.infinity),
                    _buildButtonCard('value(', width: double.infinity),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildButtonCard('sum(', width: double.infinity),
                    _buildButtonCard('average(', width: double.infinity),
                    _buildButtonCard('factorial(', width: double.infinity),
                    _buildButtonCard('sin(', width: double.infinity),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildButtonCard('cos(', width: double.infinity),
                    _buildButtonCard('tan(', width: double.infinity),
                    _buildButtonCard('asin(', width: double.infinity),
                    _buildButtonCard('acos(', width: double.infinity),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildButtonCard('atan(', width: double.infinity),
                    _buildButtonCard('formatDeg(', width: double.infinity),
                    _buildButtonCard('reForDeg(', width: double.infinity),
                    _buildButtonCard('absSum(', width: double.infinity),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildButtonCard('absAverage(', width: double.infinity),
                    _buildButtonCard('radToDeg(', width: double.infinity),
                    _buildButtonCard('lagrange(', width: double.infinity),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
    buttonsH = new LimitedBox(
      maxHeight: 40.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        cacheExtent: 0.0,
        children: <Widget>[
          _buildButtonCard('Fun', width: 50.0),
          _buildButtonCard('inv(', width: 50.0),
          _buildButtonCard('tran(', width: 50.0),
          _buildButtonCard('value(', width: 60.0),
          _buildButtonCard('sum(', width: 50.0),
          _buildButtonCard('average(', width: 80.0),
          _buildButtonCard('factorial(', width: 80.0),
          _buildButtonCard('sin(', width: 50.0),
          _buildButtonCard('cos(', width: 50.0),
          _buildButtonCard('tan(', width: 50.0),
          _buildButtonCard('asin(', width: 55.0),
          _buildButtonCard('acos(', width: 55.0),
          _buildButtonCard('atan(', width: 55.0),
          _buildButtonCard('formatDeg(', width: 90.0),
          _buildButtonCard('reForDeg(', width: 80.0),
          _buildButtonCard('absSum(', width: 80.0),
          _buildButtonCard('absAverage(', width: 90.0),
          _buildButtonCard('radToDeg(', width: 90.0),
          _buildButtonCard('lagrange(', width: 80.0),
        ],
      ),
    );
    if (isHorizontalBottons) {
      return buttonsH;
    }
    return buttonsV;
  }

  /// 创建方便输入符号的按钮列
  Widget _buildButtons() {
    Widget buttons;
    buttons = new LimitedBox(
      maxHeight: 40.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildButtonCard(','),
          _buildButtonCard(';'),
          _buildButtonCard(':'),
          _buildButtonCard('['),
          _buildButtonCard(']'),
          _buildButtonCard('='),
          _buildButtonCard('('),
          _buildButtonCard(')'),
          _buildButtonCard('^'),
          _buildButtonCard('+'),
          _buildButtonCard('-'),
          _buildButtonCard('*'),
          _buildButtonCard('/'),
        ],
      ),
    );
    return buttons;
  }

  /// 传入标签，创建便捷输入按钮
  Widget _buildButtonCard(String label, {double width = 50.0}) {
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

  ///输入控件，包含一个输入框和一个按钮
  Widget _buildTextComposer(BuildContext context) {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: <Widget>[
              new Flexible(
                  child: new Container(
                      margin: new EdgeInsets.only(left: 25.0),
                      child: new TextField(
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
                        decoration:
                            new InputDecoration.collapsed(hintText: '输入命令'),
                      ))),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(context, _textController.text)
                      : null,
                ),
              )
            ])));
  }

  ///处理发送按钮的点击事件
  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    setState(() {
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
  @override
  State createState() => new TextScreenState();
}

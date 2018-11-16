import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaoming/command/Matrix.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xiaoming/language/xiaomingLocalizations.dart';

///单个输出文本的视图
class TextView extends StatelessWidget {
  TextView({this.context, this.text, this.animationController});
  BuildContext context;
  final AnimationController animationController;
  final String text;
//  final scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new GestureDetector(
        child: new ListTile(
            title: new Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: new Text(text),
        )),
        onLongPress: _handleLongPress,
      ),
    );
  }

  void _handleLongPress() {
    Clipboard.setData(new ClipboardData(text: text));
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: new Text('内容已复制到剪切板'),
    ));
  }
}

///保存的方法界面
void methodRoute(BuildContext context) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
    final List<Card> tiles = <Card>[];
    for (CmdMethod method in cmdMethods) {
      tiles.add(new Card(
        color: Colors.amber,
        child: new ListTile(
          leading: new Text(
            method.name,
          ),
          title: new Text(method.methodValue),
          subtitle: new Text(method.methodDescription),
        ),
      ));
    }
    for (UserFunction u in userFunctions) {
      tiles.add(new Card(
        color: Colors.amber,
        child: new ListTile(
          leading: new Text(
            u.funName,
          ),
          title: new Text(
              '${u.funName}(${u.paras.toString().substring(1, u.paras.toString().length - 1)})'),
          subtitle: new Text(u.funCmds.toString()),
        ),
      ));
    }
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('保存的函数'),
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

///保存的数据界面
void dataRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    List<Card> tiles = <Card>[];
    if (matrixs.isNotEmpty) {
      matrixs.forEach((name, list) => tiles.add(new Card(
            color: Colors.cyan,
            child: new ListTile(
              leading: new Text(name),
              title: new Text(mtoString(list: list)),
            ),
          )));
    }
    if (dbs.isNotEmpty) {
      dbs.forEach((name, value) => tiles.add(new Card(
            color: Colors.green,
            child: new ListTile(
              leading: new Text(name),
              title: new Text(value.toString()),
            ),
          )));
    }
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles.reversed,
    ).toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('保存的数据'),
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

///设置界面
class SettingRoute extends StatefulWidget {
  @override
  _SettingRouteState createState() => _SettingRouteState();
}

///控制设置界面的状态
class _SettingRouteState extends State<SettingRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(XiaomingLocalizations.of(context).Setting),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: new Container(
                margin: const EdgeInsets.all(12.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(XiaomingLocalizations.of(context).decimal_digits),
                    ),
                    Text(fixedNum.toString()),
                    CupertinoSlider(
                      divisions: 8,
                      max: 9.0,
                      min: 1.0,
                      value: fixedNum,
                      onChanged: (double d) {
                        setState(() {
                          fixedNum = d;
                        });
                        writeSettingData();
                      },
                    ),
                  ],
                )),
          ),
          Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: new Container(
              margin: const EdgeInsets.all(12.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Text(XiaomingLocalizations.of(context).MethodButtonsView),
                  ),
                  Text(XiaomingLocalizations.of(context).Horizontal),
                  Switch(
                    value: isHorizontalBottons,
                    onChanged: (newValue) {
                      setState(() {
                        isHorizontalBottons = !isHorizontalBottons;
                      });
                      writeSettingData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///加载设置界面
void settingRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    return new SettingRoute();
  }));
}

///帮助界面
class helpView extends StatefulWidget {
  @override
  _helpViewState createState() => _helpViewState();
}

class HelpItem {
  bool isExpanded;
  final String header;
  final Widget body;
  HelpItem(this.isExpanded, this.header, this.body);
}

///控制帮助界面的状态
class _helpViewState extends State<helpView> {
  List<HelpItem> items = <HelpItem>[
    new HelpItem(
        false,
        '矩阵赋值',
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: new Text('矩阵赋值的语句格式为：a=[1,2,3;4,5,6;7,8,9],'
              ' 名称可以由字母和数字组成,但必须以字母开头。'
              '每一行的多个值用逗号分隔开，行之间用分号分隔开。输入框的上方有方便输入的'
              '逗号和分号按钮。矩阵和实数会自动保存到文件，同名的数据会被替换（输入a=2也会替换'
              '原有的a=[1,2,3;4,5,6])'),
        )),
    new HelpItem(
        false,
        '函数调用',
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: new Text('输入函数名及其参数即可调用函数。例：b=inv(a).函数可以嵌套调用，'
              '例：c=tran(inv(a)。在自定义函数中也可以调用内置函数，输入框的上方有方便输入函数名的按钮列'
              '点击主界面左上角的按钮可以打开抽屉，点击抽屉中的保存的函数按钮可以打开函数介绍界面，里面有内置函数的'
              '详细介绍，还有用户的自定义函数'),
        )),
    new HelpItem(
        false,
        '自定义函数',
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: new Text(
              '示例： Fun test(a,b,c):d=a*b/(b+c);r=factorial(d)自定义函数可以由多个命令语句或单个命令语句组成，多个命令语句之间用'
              '分号分隔开，最后一条命令为函数的返回结果。自定义函数会保存在文件中，方便下次使用，同名的自定义函数只会保留最新定义的'
              '那个函数。自定义函数名不能为内置函数的名称。在调用自定义函数时传入参数， 例：test(3,2,-1)。注：示例中使用到的阶乘函数'
              '会自动将小数部分四舍五入成整数再求阶乘。'),
        )),
    new HelpItem(
        false,
        '设置小数位数',
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: new Text('在抽屉界面中点击设置按钮可以跳转到设置界面，滑动滑块选择保留小数到小数点后第几位'),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('帮助'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            new Card(
                child: new ExpansionPanelList(
              expansionCallback: (int i, bool b) => setState(() {
                    items[i].isExpanded = !items[i].isExpanded;
                  }),
              children: items.map((HelpItem item) {
                return new ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return new ListTile(
                      leading: new Text(item.header,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.deepOrange)),
                    );
                  },
                  isExpanded: item.isExpanded,
                  body: item.body,
                );
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }
}

void helpRoute(BuildContext context) {
  Navigator.of(context)
      .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
    return new helpView();
  }));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/helpDetailRoute.dart';

///帮助界面
class HelpView extends StatefulWidget {
  HelpView({Key key}) : super(key: key);

  @override
  _HelpViewState createState() => _HelpViewState();
}

///控制帮助界面的状态
class _HelpViewState extends State<HelpView> {
  Widget _buildCard(String text, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (BuildContext context) {
          return HelpDetailRoute(index);
        }));
      },
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                  ),
                  width: 200.0,
                ),
              ),
              CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (BuildContext context) {
                      return HelpDetailRoute(index);
                    }));
                  },
                  child: Icon(CupertinoIcons.forward)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingData.nowPage = 1;
    SettingData.pageContext = context;

    final lists = ListView(
      children: <Widget>[
        _buildCard(XiaomingLocalizations.of(context).helpTab1, 1),
        const Divider(
          height: 1.0,
        ),
        _buildCard(XiaomingLocalizations.of(context).helpTab2, 2),
        const Divider(
          height: 1.0,
        ),
        _buildCard(XiaomingLocalizations.of(context).helpTab3, 3),
        const Divider(
          height: 1.0,
        ),
        _buildCard(XiaomingLocalizations.of(context).helpTab4, 4),
        const Divider(
          height: 1.0,
        ),
        _buildCard(XiaomingLocalizations.of(context).helpTab5, 5),
        const Divider(
          height: 1.0,
        ),
        _buildCard(XiaomingLocalizations.of(context).definiteIntegral, 6),
      ],
    );

    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: Provide<SettingData>(  ///根据主题切换界面风格
        child: Container(
          margin: const EdgeInsets.all(12.0),
          child: lists,
        ),
        builder: (context, child, sd) {
          return sd.theme == "IOS"
              ? CupertinoPageScaffold(
                  backgroundColor: CupertinoColors.lightBackgroundGray,
                  navigationBar: const CupertinoNavigationBar(
                    middle: Text("Help"),
                    previousPageTitle: 'Home',
                  ),
                  child: child,
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blueGrey,
                    title: Text("Help"),
                    centerTitle: true,
                  ),
                  body: child,
                );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/equationRoute.dart';
import 'package:xiaoming/src/view/route/integralRoute.dart';

class AndFunctionsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: CupertinoColors.activeGreen,
          title: TabBar(
            indicatorColor: CupertinoColors.lightBackgroundGray,
          tabs: <Widget>[
            Tab(child: Text(XiaomingLocalizations.of(context).equations),),
            Tab(child: Text(XiaomingLocalizations.of(context).definiteIntegral))
          ],),
        ),
        body: TabBarView(
          children: <Widget>[
            EquationRoute(),
            IntegralRoute(),
          ],
        ),
      ),
    );
  }
}

class IOSFunctionsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildCard(String text, VoidCallback onPressed) {
      return GestureDetector(
        onTap: onPressed,
        child: Card(
          elevation: 0.0,
          margin: EdgeInsets.zero,
          child: Row(
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
                  onPressed: onPressed,
                  child: Icon(CupertinoIcons.forward)),
            ],
          ),
        ),
      );
    }

    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Functions"),
        ),
        backgroundColor: CupertinoColors.lightBackgroundGray,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 140.0,
              ),
              _buildCard(XiaomingLocalizations.of(context).equations, (){
                Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context){
                  return EquationRoute();
                }));
              }),
              Divider(height: 1.0, color: CupertinoColors.black,),
              _buildCard(XiaomingLocalizations.of(context).definiteIntegral, (){
                Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
                  return IntegralRoute();
                }));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

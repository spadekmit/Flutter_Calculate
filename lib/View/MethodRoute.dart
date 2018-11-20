import 'package:flutter/material.dart';
import 'package:xiaoming/data/data.dart';
import 'package:xiaoming/language/xiaomingLocalizations.dart';

///保存的方法界面
void methodRoute(BuildContext context) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
    final List<Card> tiles = <Card>[];
    Locale myLocale = Localizations.localeOf(context);
    String funName;
    String funDescrip;

    for (CmdMethod method in cmdMethods) {
      if (myLocale.countryCode == 'CH') {
        funName = method.name;
        funDescrip = method.methodDescription;
      } else {
        funName = method.Ename;
        funDescrip = method.EmethodDescription;
      }
      tiles.add(new Card(
        color: Colors.yellow,
        child: new ListTile(
          leading: new Text(
            funName,
          ),
          title: new Text(funDescrip),
        ),
      ));
    }
    for (UserFunction u in userFunctions) {
      tiles.add(new Card(
        color: Colors.purple,
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
          title: new Text(XiaomingLocalizations.of(context).Saved_function)),
      body: new ListView(
        children: divided,
      ),
    );
  }));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/widget/myTabScaffold.dart';

///FlutterApp入口
class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        XiaomingLocalizationsDelegate.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
      home: MyTabScaffold(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xiaoming/src/language/chineseCupertinoLocalizations.dart';
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
      home: MyTabScaffold(),  
    );
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/view/route/app.dart';

void main() {
  final providers = Providers()
    ..provide(Provider.function((context) {
      var ud = new UserData();
      ud.loadData();
      return ud;
    }));
  runApp(ProviderNode(providers: providers, child: MyApp()));

  ///如果是安卓平台，将状态栏颜色设为透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

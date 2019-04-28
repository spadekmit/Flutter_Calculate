import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provide/provide.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/data/userData.dart';
import 'package:xiaoming/src/view/route/app.dart';

void main() {
  final userProviders = Providers()
    ..provide(Provider.function((context) {
      final ud = new UserData();
      ud.loadData();
      return ud;
    }));
  final settingProviders = Providers()
    ..provide(Provider.function((context) {
      final sd = SettingData();
      sd.readSettingData();
      return sd;
    }));
  runApp(ProviderNode(
    providers: userProviders,
    child: ProviderNode(
      providers: settingProviders,
      child: MyApp(),
    ),
  ));

  ///如果是安卓平台，将状态栏颜色设为透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingData with ChangeNotifier{

  static int _fixedNum; //存储小数位值
  static String language;  //当前设备语言
  static int nowPage;  //当前页面级数

  //非一级页面时存储用于pop的context （阻止ios主题时系统导航栏返回键直接退出应用
  static BuildContext pageContext;  
  String theme;  //应用主题  

  static int get fixedNum => _fixedNum;

  SettingData() {
    _fixedNum = 6;
    theme = "Android";
    nowPage = 0;
    language = "en";
  }

  void changeTheme(String newTheme) {  //改变主题并提醒widget rebuild
    if('Android' == newTheme || 'IOS' == newTheme) {
      theme = newTheme;
      writeSettingData();
      notifyListeners();
    }
  }

  void setFixedNum(int newValue) {  //改变精度并提醒widget rebuild
    _fixedNum = newValue;
    writeSettingData();
    notifyListeners();
  }

  ///将设置界面的数据存储到文件
  Future writeSettingData() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File settingDataFile = new File('$dir/settingdata.txt');
    if (settingDataFile.existsSync()) {
      settingDataFile.delete();
    }
    settingDataFile.createSync();
    settingDataFile.writeAsStringSync(_fixedNum.toString() + "|" + theme);
  }

  ///从文件读取到设置界面的数据
  Future readSettingData() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File settingDataFile = new File('$dir/settingdata.txt');
    if (settingDataFile.existsSync()) {
      String data = settingDataFile.readAsStringSync();
      var datas = data.split("|");
      if(int.tryParse(datas[0]) != null) _fixedNum = int.tryParse(data[0]);
      theme = datas[1];
    }
  }
}

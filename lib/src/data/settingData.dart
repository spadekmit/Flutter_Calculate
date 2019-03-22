import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingData {

  static double fixedNum = 6.0; //存储小数位值
  static double buttonsHeight = 250.0; //存储便捷输入栏的高度
  static bool isAutoExpanded = true; //存储是否自动展开按纽栏
  static int maxTexts = 300; //存储保存的消息数量

  ///将设置界面的数据存储到文件
  static Future writeSettingData() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File settingDataFile = new File('$dir/settingdata.txt');
    if (settingDataFile.existsSync()) {
      settingDataFile.delete();
    }
    settingDataFile.createSync();
    settingDataFile.writeAsStringSync(SettingData.fixedNum.toString() +
        '|' + SettingData.isAutoExpanded.toString() +
        '|' + SettingData.buttonsHeight.toString() + 
        '|' + SettingData.maxTexts.toString());
  }

  ///从文件读取到设置界面的数据
  static Future readSettingData() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File settingDataFile = new File('$dir/settingdata.txt');
    if (settingDataFile.existsSync()) {
      String data = settingDataFile.readAsStringSync();
      var list = data.split('|');
      try {
        SettingData.fixedNum = double.parse(list[0]);
        if (list[1] == 'false') {
          SettingData.isAutoExpanded = false;
        } else {
          SettingData.isAutoExpanded = true;
        }
        SettingData.buttonsHeight = double.parse(list[2]);
        SettingData.maxTexts = int.parse(list[3]);
      } catch (e) {
        SettingData.fixedNum = 6.0;
        SettingData.isAutoExpanded = true;
        SettingData.buttonsHeight = 250.0;
        SettingData.maxTexts = 300;
      }
    } else {
      SettingData.fixedNum = 6.0;
      SettingData.isAutoExpanded = true;
      SettingData.buttonsHeight = 250.0;
    }
  }
}

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SettingData {
  _SettingData() {}

  static double fixedNum = 6.0; //存储小数位值
  static double buttonsHeight = 250.0;  //存储便捷输入栏的高度
  static bool isAutoExpanded = true;

  static Future writeSettingData() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File settingDataFile = new File('$dir/settingdata.txt');
    if (settingDataFile.existsSync()) {
      settingDataFile.delete();
    }
    settingDataFile.createSync();
    settingDataFile.writeAsStringSync(SettingData.fixedNum.toString());
  }
  ///从文件读取到设置界面的数据
  static Future readSettingData() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File settingDataFile = new File('$dir/settingdata.txt');
    if (settingDataFile.existsSync()) {
      String data = settingDataFile.readAsStringSync();
      try {
        SettingData.fixedNum = double.parse(data);
      } catch (e) {
        SettingData.fixedNum = 6.0;
      }
    } else {
      SettingData.fixedNum = 6.0;
    }
  }
}

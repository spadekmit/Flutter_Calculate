import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingData {

  static double fixedNum = 6.0; //存储小数位值

  ///将设置界面的数据存储到文件
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
      if(double.tryParse(data) != null) SettingData.fixedNum = double.tryParse(data);
    }
  }
}

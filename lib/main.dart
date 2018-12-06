import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/view/mainRoute.dart';

void main() {
  SettingData.readSettingData();
  runApp(new MyApp());
}

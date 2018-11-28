import 'package:flutter/material.dart';
import 'package:xiaoming/src/view/mainRoute.dart';
import 'package:xiaoming/src/data/appData.dart';

void main() {
  UserData.readSettingData();
  runApp(new MyApp());
}

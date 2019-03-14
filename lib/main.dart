import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/view/route/cApp.dart';

void main() async{
  await UserData.loadData();
  runApp(new cApp());
}

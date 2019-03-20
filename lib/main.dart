import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/view/route/mainRoute.dart';

void main() async{
  await UserData.loadData();
  runApp(new MyApp());
}

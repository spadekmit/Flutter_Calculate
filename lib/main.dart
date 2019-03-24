import 'package:flutter/material.dart';
import 'package:xiaoming/src/view/route/app.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() async{
  runApp(new MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

import 'package:e_bazeni/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.redAccent[700],
    systemNavigationBarDividerColor: Colors.redAccent[700],
    statusBarColor: Colors.redAccent[700],
  ));
  runApp(
    GetMaterialApp(
      defaultTransition: Transition.topLevel,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Wrapper()
    )
  );
}
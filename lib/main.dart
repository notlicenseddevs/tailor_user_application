import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/landingpage.dart';
import 'package:tailor_user_application/intentHandler.dart';

Future<void> main() async {
  intentHandler();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LandingPage(),
    );
  }
}
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/landingpage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tailor_user_application/mqttConnection.dart';

Future<void> main() async {
  // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // final deviceInfo = await deviceInfoPlugin.androidInfo;
  // final deviceId = deviceInfo.id;
  StreamController<bool> check = StreamController();
  mqttConnection mqtt = mqttConnection();
  try {
    mqtt.connect(check);
    check.stream.listen((event) {runApp(const MyApp());});
  } catch (e, s) {
    print(s);
  }

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

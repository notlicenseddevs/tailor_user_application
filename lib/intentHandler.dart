import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'package:tailor_user_application/registerPlaylist.dart';
import 'package:tailor_user_application/registerplace_intent.dart';

void intentHandler() {
  WidgetsFlutterBinding.ensureInitialized();
  ReceiveSharingIntent.getTextStream().listen((String text) {
    messageHandler(text);
  });
}

void messageHandler(String text) async {
  FlutterSecureStorage a = FlutterSecureStorage();
  mqttConnection mqtt = mqttConnection();
  String? logined = await a.read(key: 'login');
  bool islogined = logined==null ? false : true;
  print('intent listen : $text');
  if(text.startsWith('https://youtube.com/playlist?list=') && islogined) {
    List<dynamic?> value = await Get.to(RegisterPlaylist(url: text)) as List<dynamic?>;
    Map<String, dynamic> dataObj = {
      "name":value[0],
      "url":value[1]
    };
    Map<String, dynamic> msgObj = {
      "cmd_type":5,
      "target_list":1,
      "item":dataObj
    };
    String msg = jsonEncode(msgObj);
    mqtt.requestToServer(msg);
    Fluttertoast.showToast(
      msg: '해당 플레이리스트가 추가되었습니다.',
      gravity: ToastGravity.BOTTOM,
    );
    Get.offAll(MainPage(),arguments: a);
  }
  else if (text.contains('https://maps.app.goo.gl/')) {
    final placeName = text.split('\n');
    print('placenmae:$placeName');
    List<dynamic> value = await Get.to(RegisterPlaceIntent(name: placeName[0])) as List<dynamic>;
    Map<String, dynamic> dataObj = {"place_name":value[3], "latitude":value[0], "longitude":value[1], "gmap_link":value[4], "describe":value[2]};
    Map<String, dynamic> msgObj = {
      "cmd_type":5,
      "target_list":2,
      "item":dataObj
    };
    String msg = jsonEncode(msgObj);
    mqttConnection mqtt = mqttConnection();
    mqtt.requestToServer(msg);
    Fluttertoast.showToast(
      msg: '해당 장소가 즐겨찾기에 추가되었습니다.',
      gravity: ToastGravity.BOTTOM,

    );
    Get.offAll(MainPage(),arguments: a);
  }
  else {
    Fluttertoast.showToast(msg: '알 수 없는 대상입니다.');
  }
}
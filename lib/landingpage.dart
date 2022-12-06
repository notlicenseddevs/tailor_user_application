import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tailor_user_application/mainpage_guest.dart';
import 'package:tailor_user_application/crypto_service.dart';
import 'package:tailor_user_application/mqttConnection.dart';


class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  static final storage = new FlutterSecureStorage();
  static final cryptoService appCrypto = cryptoService();
  Widget goingTo = LandingPage();
  bool _isReady = false;
  String? userInfo = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _asyncMethod();
  }

  @override
  void dispose() {
    //앱 상태 변경 이벤트 해제
    //문제는 앱 종료시 dispose함수가 호출되지 않아 해당 함수를 실행 할 수가 없다.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 앱 상태 변경시 호출
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // 앱이 표시되고 사용자 입력에 응답합니다.
      // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        print("resumed");
        break;
      case AppLifecycleState.inactive:
      // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
      // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
      // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
      // inactive가 발생되고 얼마후 pasued가 발생합니다.
        print("inactive");
        break;
      case AppLifecycleState.paused:
      // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
      // 안드로이드의 onPause()와 동일합니다.
      // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
        print("paused");
        break;
      case AppLifecycleState.detached:
      // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
      // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
      // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
        print("detached");
        break;
    }
  }

  _asyncMethod() async {
    await storage.read(key: "login").then((val){userInfo = val;}).catchError((error) {
      print("error : $error");
    });
    print(userInfo);

    if(userInfo != null) {
      mqttConnection mqtt = mqttConnection();
      StreamController<bool> check = StreamController<bool>();
      Map<String, dynamic> userInfoObj = jsonDecode(userInfo!);
      print(userInfoObj);
      Map<String, dynamic> loginDataObj = {
        "cmd_type":2,
        "user_id":userInfoObj['id'],
        "passwd":userInfoObj['password'],
      };
      String loginData = jsonEncode(loginDataObj);
      mqtt.loginRequest(loginData, check);
      check.stream.listen((v) {
        if(v) {
          Fluttertoast.showToast(
            msg: '자동 로그인이 완료되었습니다.',
            gravity: ToastGravity.BOTTOM,

          );
          goingTo = MainPage();
          Get.offAll(goingTo, arguments: storage);
        }
        else {
          storage.delete(key: 'login');
          Fluttertoast.showToast(
            msg: '자동 로그인이 실패되었습니다. 다시 로그인해주세요.',
            gravity: ToastGravity.BOTTOM,
          );
          goingTo = MainPageGuest();
          Get.offAll(goingTo, arguments: storage);
        }
      });
    }
    else {
      goingTo = MainPageGuest();
      Get.offAll(goingTo, arguments: storage);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.orange,
            child: Center(child: Text("랜딩페이지")),
          ),
          CircularProgressIndicator(),
        ],
      )
    );
  }
}
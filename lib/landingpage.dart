import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
  mqttConnection mqtt = mqttConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _asyncMethod();
  }

  _asyncMethod() async {
    try {
      StreamController<bool> check = StreamController();
      mqtt.connect(check);
      check.stream.listen((event) async {
        await storage.read(key: "login").then((val){userInfo = val;}).catchError((error) {
          print("error : $error");
        });
        print(userInfo);

        if(userInfo != null) {
          StreamController<bool> check = StreamController<bool>();
          Map<String, dynamic> userInfoObj = jsonDecode(userInfo!);
          print(userInfoObj);
          Map<String, dynamic> loginDataObj = {
            "cmd_type":2,
            "user_id":userInfoObj['id'],
            "passwd":userInfoObj['password'], //이미 암호화된 passwd (storage에 저장할 때 암호화함)
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
      });
    } catch (e, s) {
      print(s);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Center(child: Image.asset('assets/logo.jpg')),
          ),
          CircularProgressIndicator(),
        ],
      )
    );
  }
}
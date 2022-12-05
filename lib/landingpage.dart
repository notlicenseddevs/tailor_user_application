import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tailor_user_application/mainpage_guest.dart';
import 'package:tailor_user_application/crypto_service.dart';


class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static final storage = new FlutterSecureStorage();
  static final cryptoService appCrypto = cryptoService();
  Widget goingTo = LandingPage();
  bool _isReady = false;

  String? userInfo = "";
  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    await storage.deleteAll();
    await storage.read(key: "login").then((val){userInfo = val;}).catchError((error) {
      print("error : $error");
    });
    print(userInfo);

    if(userInfo != null) {
      goingTo = MainPage();
    }
    else {
      goingTo = MainPageGuest();
    }
    Get.offAll(goingTo, arguments: storage);
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
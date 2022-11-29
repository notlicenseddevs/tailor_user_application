import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tailor_user_application/mainpage_guest.dart';


class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  static final storage = new FlutterSecureStorage();
  String? userInfo = "";
  @override
  void initState() {
    // Timer(Duration(seconds: 3),() {
    //   Get.offAll(MainPage());
    // }); // Timer
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    print("in");
    await storage.read(key: "login").then((val){userInfo = val;}).catchError((error) {
      print("error : $error");
    });
    print("out");
    print(userInfo);

    if(userInfo == null) {
      Get.offAll(MainPage());
    }
    else {
      Get.offAll(MainPageGuest());
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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/landingpage.dart';
import 'package:tailor_user_application/mqttConnection.dart';

class LogoutPage extends StatefulWidget {

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  FlutterSecureStorage storage = Get.arguments as FlutterSecureStorage;
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _readStorage = false;
  mqttConnection mqtt = mqttConnection();

  @override
  void initState() {
    _asyncProcess();
    super.initState();
  }

  _asyncProcess() async {
    var readData = await storage.read(key: 'login');
    var json = jsonDecode(readData!);
    idController.text = json['id'];
    int lengthOfPass = json['password'].length;
    String password = '';
    for(int i=0;i<lengthOfPass;i++) {
      password += '*';
    }
    passController.text = password;
    setState(() {
      _readStorage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Get.offAll(LandingPage());
    return Scaffold(
      appBar: AppBar(
        title: Text('로그아웃', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black45,
      ),
      body: _readStorage ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'id'),
                readOnly: true,
                enabled: false,
              ),
              TextField(
                controller: passController,
                decoration: InputDecoration(labelText: 'password'),
                readOnly: true,
                enabled: false,
              ),
              ElevatedButton(
                onPressed: () async {
                  storage.delete(key: 'login');
                  mqtt.requestToServer('{"cmd_type":10,"hw_configs":{}}');
                  Fluttertoast.showToast(
                    msg: '로그아웃 되었습니다.',
                    gravity: ToastGravity.BOTTOM,

                  );
                  Get.offAll(LandingPage());
                },
                child: Text("로그아웃"),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     storage.deleteAll();
              //     mqtt.requestToServer('{"cmd_type":10,"hw_configs":{}}');
              //     Get.offAll(LandingPage());
              //   },
              //   child: Text("모든 데이터 삭제 후 로그아웃"),
              // ),
            ],
          ),
        ),
      )
      :
      Center(child: CircularProgressIndicator()),
    );
  }
}
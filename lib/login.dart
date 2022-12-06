import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tailor_user_application/crypto_service.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'landingpage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FlutterSecureStorage storage = Get.arguments as FlutterSecureStorage;
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String message = '';
  bool _islogin = false;
  bool _loginRequest = false;
  bool _isWrong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인', style: TextStyle(
        fontWeight: FontWeight.bold,
      )),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loginResult(),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: "id"),
              ),
              TextField(
                controller: passController,
                decoration: InputDecoration(labelText: "password"),
                obscureText: true,
                obscuringCharacter: '*',
              ),
              ElevatedButton(
                onPressed: () {
                  mqttConnection mqtt = mqttConnection();
                  StreamController<bool> check = StreamController<bool>();
                  setState(() {
                    _loginRequest = true;
                    _islogin = false;
                    _isWrong = false;
                    mqtt.loginRequest('{"cmd_type":2,"user_id":"${idController.text.toString()}","passwd":"${passController.text.toString()}"}', check);
                  });
                  check.stream.listen((v) => {
                    setState(() {
                      _islogin = v;
                      _isWrong = !v;
                      _loginRequest = false;
                    })
                  });
                },
                child: Text("로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget loginResult() {
    if (_loginRequest) {
      return const CircularProgressIndicator();
    }
    if (_loginRequest && !(_islogin ^ _isWrong)) {
      return const Text('');
    }
    if (!_loginRequest && _islogin && !_isWrong) {
      storage.write(
        key: 'login',
        value: jsonEncode({
          'id':idController.text.toString(),
          'password':passController.text.toString()
        }),
      ).then((value) => Get.offAll(MainPage(), arguments: storage));
      return const Text('');
    }
    if (!_loginRequest && !_islogin && _isWrong) {
      return const Text('아이디나 비밀번호가 잘못되었습니다.');
    }
    return const Text('');
  }
}
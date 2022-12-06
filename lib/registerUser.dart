import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'landingpage.dart';
import 'package:get/get.dart';
import 'dart:convert';

class RegisterUser extends StatefulWidget {

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  FlutterSecureStorage storage = Get.arguments as FlutterSecureStorage;
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  bool _isRegistared = false;
  bool _registarRequest = false;
  bool _isWrong = false;

  @override
  void initState() {
    idController.text = '';
    passController.text = '';
    pinController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('회원가입', style: TextStyle(
          fontWeight: FontWeight.bold,
        )),),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                registarResult(),
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
                TextField(
                  controller: pinController,
                  decoration: InputDecoration(labelText: "PIN (4 integers)"),
                  obscureText: true,
                  obscuringCharacter: '*',

                ),
                  ElevatedButton(
                    onPressed: () async {
                      mqttConnection mqtt = mqttConnection();
                      StreamController<bool> check = StreamController<bool>();
                      setState(() {
                        _registarRequest = true;
                        _isRegistared = false;
                        _isWrong = false;
                        Map<String, dynamic> json =
                          {"cmd_type":9,
                            "user_id":idController.text.toString(),
                            "passwd":passController.text.toString(),
                            "pin_number":int.parse(pinController.text)
                          };
                        String msg = jsonEncode(json);
                        mqtt.registarRequest(msg, check);
                      });
                      check.stream.listen((v) => {
                        setState(() {
                          _isRegistared = v;
                          _isWrong = !v;
                          _registarRequest = false;
                        })
                      });
                    // write 함수를 통하여 key에 맞는 정보를 적게 됩니다.
                    //{"login" : "id id_value password password_value"}
                    //와 같은 형식으로 저장이 된다고 생각을 하면 됩니다.
                    //String encryptedPass = appCrypto.encrypt(passController.text.toString()).base64;

                  },
                  child: Text("회원가입"),
                )
              ],
            ),
          ),
        ),
    );
  }
  Widget registarResult() {
    int pin = 0;
    if(pinController.text != '') {
      int.parse(pinController.text.toString());
      if(pin.isNaN || pin<0 || pin>9999) {
        return const Text('핀 번호가 잘못되었습니다.');
      }
    }
    if (_registarRequest) {
      return const CircularProgressIndicator();
    }
    if (_registarRequest && !(_isRegistared ^ _isWrong)) {
      return const Text('');
    }
    if (!_registarRequest && _isRegistared && !_isWrong) {
      storage.write(
        key: 'login',
        value: jsonEncode({
          'id':idController.text.toString(),
          'password':passController.text.toString()
        }),
      ).then((value) {
        Fluttertoast.showToast(
          msg: '회원가입되었습니다. 가입하신 계정으로 로그인합니다.',
          gravity: ToastGravity.BOTTOM,

        );
        Get.offAll(LandingPage(), arguments: storage);
      });
      return const Text('');
    }
    if (!_registarRequest && !_isRegistared && _isWrong) {
      return const Text('아이디가 중복입니다.');
    }
    return const Text('');
  }

}
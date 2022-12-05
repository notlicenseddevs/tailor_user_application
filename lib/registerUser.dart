import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
                    // write 함수를 통하여 key에 맞는 정보를 적게 됩니다.
                    //{"login" : "id id_value password password_value"}
                    //와 같은 형식으로 저장이 된다고 생각을 하면 됩니다.
                    //String encryptedPass = appCrypto.encrypt(passController.text.toString()).base64;
                    await storage.write(
                      key: idController.text.toString(),
                      value: jsonEncode({
                        'password':passController.text.toString()}),
                    );
                    Get.offAll(LandingPage());
                  },
                  child: Text("회원가입"),
                )
              ],
            ),
          ),
        ),
    );
  }
}
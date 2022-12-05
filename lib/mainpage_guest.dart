import 'package:flutter/material.dart';
import 'package:tailor_user_application/boxwidgets.dart';
import 'package:tailor_user_application/login.dart';
import 'package:tailor_user_application/registerUser.dart';
import 'package:tailor_user_application/temp.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainPageGuest extends StatefulWidget {

  @override
  _MainPageGuestState createState() => _MainPageGuestState();
}

class _MainPageGuestState extends State<MainPageGuest> {
  FlutterSecureStorage storage = Get.arguments as FlutterSecureStorage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인페이지 (비로그인)', style: TextStyle(
        fontWeight: FontWeight.bold,
      )),),
      /*bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 10,
        currentIndex: _selectedIndex,

        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items:bottomItems,
      ),*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:Text('환영합니다', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: -1,
                    )),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('원하시는 메뉴를 선택해주세요.', style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize:18,
                      letterSpacing: -0.5,
                    )),
                  )
                ],
              ),
            ),
            MenuBox('회원가입', Colors.lightBlue, RegisterUser(), storage),
            MenuBox('로그인', Colors.orange, Login(), storage),
            SizedBox(
              height: 50,
            )
          ],
        )
      )
    );
  }
}
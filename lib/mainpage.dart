import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/boxwidgets.dart';
import 'package:tailor_user_application/favoriteplace.dart';
import 'package:tailor_user_application/logout.dart';
import 'package:tailor_user_application/playlist.dart';
import 'package:tailor_user_application/registerface.dart';
import 'package:tailor_user_application/temp.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FlutterSecureStorage storage = Get.arguments as FlutterSecureStorage;
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> bottomItems=[
    BottomNavigationBarItem(
      label: '1번',
      icon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      label: '2번',
      icon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      label: '3번',
      icon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      label: '4번',
      icon: Icon(Icons.favorite),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인페이지', style: TextStyle(
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
            MenuBox('얼굴 등록하기', Colors.indigo, RegisterFace(), null),
            MenuBox('장소 즐겨찾기', Colors.deepPurple, FavoritePlace(), null),
            MenuBox('플레이리스트', Colors.redAccent, PlayList(), null),
            MenuBox('로그아웃', Colors.black38, LogoutPage(), storage),
            SizedBox(
              height: 50,
            )
          ],
        )
      )
    );
  }
}
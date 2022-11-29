import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/googlemap.dart';

class RegistarPlace extends StatefulWidget {

  @override
  _RegistarPlaceState createState() => _RegistarPlaceState();
}

class _RegistarPlaceState extends State<RegistarPlace> {
  @override
  void initState() {
    super.initState();
  }
  String inputText = '';
  String lng = '';
  String lat = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('장소 즐겨찾기 등록', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.deepPurple,
      ),
      body:Container(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                List<double> result = await Get.to(SearchbyGoogleMap()) as List<double>;
                if(result.length == 2) {
                  print('lng lat received');
                  lng = result[0].toString();
                  lat = result[1].toString();
                }
                else {
                  print('***** ${result.length} received!');
                }
                setState(() {

                });
              },
              child: Text('Google Map으로 장소 검색하기'),
            ),
            Container(
              child: Column(
                children: [
                  Text("위도 : $lng"),
                  Text("경도 : $lat"),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0,20.0,10.0),
                        child: TextField(
                          onChanged: (text) {
                            inputText = text;
                          },
                          decoration: InputDecoration(
                            labelText: '설명',
                            hintText: '장소에 대한 설몀을 입력하세요.',
                            labelStyle: TextStyle(color:Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.redAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.redAccent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back(result: [lng, lat, inputText]);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.save),
      )
    );
  }
}
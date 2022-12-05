import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/googlemap.dart';

class RegisterPlace extends StatefulWidget {
  String? inputText;
  double? lng = 0;
  double? lat = 0;
  String? name;
  String? url;
  RegisterPlace({this.inputText, this.lng, this.lat, this.name, this.url});
  @override
  _RegisterPlaceState createState() => _RegisterPlaceState(inputText: inputText, lng: lng, lat: lat, name: name, url: url);
}

class _RegisterPlaceState extends State<RegisterPlace> {
  @override
  void initState() {
    super.initState();
  }
  String? inputText = '';
  String? name = '' ;
  double? lng = 0;
  double? lat = 0;
  String? url = '';
  _RegisterPlaceState({this.inputText, this.lng, this.lat, this.name, this.url});

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
                List<dynamic> result = await Get.to(SearchbyGoogleMap());
                if(result.length == 4) {
                  print('received from SearchbyGoogleMap');
                  lng = result[0];
                  lat = result[1];
                  name = result[2].toString();
                  url = result[3].toString();
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
                  Text("장소명 : $name"),
                  Text("URL : $url"),
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

      floatingActionButton: (lat!=null)&(lng!=null) ? FloatingActionButton(
        onPressed: () {
          Get.back(result: [lat, lng, inputText, name, url]);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.save),
      )
      : FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.black26,
        child: const Icon(Icons.save),
      )
    );
  }
}
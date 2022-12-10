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
  String? inputText = '';
  String? name = '' ;
  double? lng = 0;
  double? lat = 0;
  String? url = '';
  _RegisterPlaceState({this.inputText, this.lng, this.lat, this.name, this.url});
  TextEditingController _nameController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  String p1 = '';
  String p2 = '';
  @override
  void initState() {
    super.initState();
    if(name != null) {
      _nameController.text = name!;
    }
    if(inputText != null) {
      _describeController.text = inputText!;
    }
    if(url != null) {
      _urlController.text = url!;
    }
    if(lat!=null && lng!=null) {
      _positionController.text = '위도 : $lat, 경도 : $lng';
    }
  }

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
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,0,20.0,20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () async {
                  List<dynamic> result = await Get.to(SearchbyGoogleMap());
                  if(result.length == 4) {
                    print('received from SearchbyGoogleMap');
                    lng = result[0];
                    lat = result[1];
                    _positionController.text = '위도 : $lat, 경도 : $lng';
                    name = result[2].toString();
                    if(name!=null) {
                      _nameController.text = name!;
                    };
                    url = result[3].toString();
                    if(url!=null) {
                      _urlController.text = url!;
                    }
                  }
                  else {
                    print('***** ${result.length} received!');
                  }
                  setState(() {

                  });
                },
                child: Text('Google Map으로 장소 검색하기'),
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
                          controller: _nameController,
                          onChanged: (text) {
                            inputText = text;
                          },
                          decoration: InputDecoration(
                            labelText: '이름',
                            hintText: '장소의 이름을 입력하세요.',
                            floatingLabelStyle: TextStyle(color:Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.deepPurple),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0,20.0,10.0),
                        child: TextField(
                          controller: _describeController,
                          onChanged: (text) {
                            inputText = text;
                          },
                          decoration: InputDecoration(
                            labelText: '설명',
                            hintText: '장소에 대한 설명을 입력하세요.',
                            floatingLabelStyle: TextStyle(color:Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.deepPurple),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0,20.0,10.0),
                        child: TextField(
                          controller: _positionController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: '위치 (수동 입력 불가)',
                            floatingLabelStyle: TextStyle(color:Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.deepPurple),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1),
                            ),
                          ),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0,20.0,10.0),
                        child: TextField(
                          controller: _urlController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'URL (수동 입력 불가)',
                            floatingLabelStyle: TextStyle(color:Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.deepPurple),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1),
                            ),
                          ),
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
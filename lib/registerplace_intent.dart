import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/locations_service.dart';

class RegisterPlaceIntent extends StatefulWidget {
  String? inputText;
  double? lng = 0;
  double? lat = 0;
  String? name;
  String? url;
  RegisterPlaceIntent({this.inputText, this.lng, this.lat, this.name, this.url});
  @override
  _RegisterPlaceIntentState createState() => _RegisterPlaceIntentState(inputText: inputText, lng: lng, lat: lat, name: name, url: url);
}

class _RegisterPlaceIntentState extends State<RegisterPlaceIntent> {
  String? inputText = '';
  String? name = '' ;
  double? lng = 0;
  double? lat = 0;
  String? url = '';
  _RegisterPlaceIntentState({this.inputText, this.lng, this.lat, this.name, this.url});
  TextEditingController _nameController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    readyToUrlLocation();
  }

  void readyToUrlLocation() async {
    var position = await LocationService().getPlace(name!);
    lat = position['geometry']['location']['lat'];
    lng = position['geometry']['location']['lng'];
    _positionController.text = '위도 : $lat, 경도 : $lng';
    _nameController.text = name = position['name'];
    _urlController.text = url = position['url'];
    _describeController.text = inputText = 'Shared by GoogleMap';
    setState(() {
      _ready = true;
    });
    return;
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
      body: _ready ? Container(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          children: [
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
                            name = text;
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
      ):CircularProgressIndicator(),
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
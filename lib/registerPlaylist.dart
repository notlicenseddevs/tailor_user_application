import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/googlemap.dart';

class RegisterPlaylist extends StatefulWidget {
  String? inputText;
  String? link;
  RegisterPlaylist({this.inputText, this.link});
  @override
  _RegisterPlaylistState createState() => _RegisterPlaylistState(inputText: inputText, link: link);
}

class _RegisterPlaylistState extends State<RegisterPlaylist> {
  @override
  void initState() {
    super.initState();
  }
  String? inputText = '';
  String? link = '';
  _RegisterPlaylistState({this.inputText, this.link});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('플레이리스트 등록', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.redAccent,
      ),
      body:Container(
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
                          onChanged: (text) {
                            inputText = text;
                          },
                          decoration: InputDecoration(
                            labelText: '설명',
                            hintText: '플레이리스트에 대한 설몀을 입력하세요.',
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0,20.0,10.0),
                        child: TextField(
                          onChanged: (text) {
                            link = text;
                          },
                          decoration: InputDecoration(
                            labelText: '링크',
                            hintText: '플레이리스트 링크를 넣으세요',
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
                          keyboardType: TextInputType.url,
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
          Get.back(result: [inputText, link]);
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.save),
      )
    );
  }
}
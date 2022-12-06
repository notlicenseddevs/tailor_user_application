import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPlaylist extends StatefulWidget {
  String? inputText;
  String? url;
  RegisterPlaylist({this.inputText, this.url});
  @override
  _RegisterPlaylistState createState() => _RegisterPlaylistState(inputText: inputText, url: url);
}

class _RegisterPlaylistState extends State<RegisterPlaylist> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  String? inputText = '';
  String? url = '';
  _RegisterPlaylistState({this.inputText, this.url});

  @override
  void initState() {
    super.initState();
    if(inputText!=null) {
      _nameController.text = inputText!;
    }
    if(url!=null) {
      _urlController.text = url!;
    }
  }

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
                          controller: _nameController,
                          onChanged: (text) {
                            inputText = text;
                          },
                          decoration: InputDecoration(
                            labelText: '이름',
                            hintText: '플레이리스트의 이름을 입력하세요.',
                            floatingLabelStyle: TextStyle(color:Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.redAccent),
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
                          controller: _urlController,
                          onChanged: (text) {
                            url = text;
                          },
                          decoration: InputDecoration(
                            labelText: '링크',
                            hintText: '플레이리스트 링크를 넣으세요',
                            floatingLabelStyle: TextStyle(color:Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.redAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1),
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
          Get.back(result: [inputText, url]);
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.save),
      )
    );
  }
}
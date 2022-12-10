import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'dart:convert';


class RegisterFace extends StatefulWidget {

  @override
  _RegisterFaceState createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  late CameraController _controller;
  bool _cameraInitialized = false;
  bool _cameraChosen = false;

  @override
  void initState() {
    super.initState();
    readyToCamera();
  }

  @override
  void dispose() {
    if(_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void readyToCamera() async {
    final cameras = await availableCameras();
    if(cameras.length == 0) {
      print("not found any cameras");
      return;
    }
    late CameraDescription myCamera;
    for( var camera in cameras ) {
      if(camera.lensDirection == CameraLensDirection.front) {
        myCamera = camera;
        _cameraChosen = true;
        break;
      }
    }
    if(!_cameraChosen) {
      myCamera = cameras[0];
    }

    _controller = CameraController(myCamera, ResolutionPreset.max);
    _controller.initialize().then (
        (value) {
          setState(() {
            _cameraInitialized = true;
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('얼굴 등록하기', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.indigo,
      ),
      body: _cameraInitialized ?
          Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(80),
                  child: CameraPreview(_controller),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final path = await _controller.takePicture();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: path.path)),
                    // );
                    print('###path is ${path.path}');
                    Get.to(DisplayPictureScreen(), arguments: path.path);
                  },
                  child: Text('사진 찍기'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,)
                ),
              ],
            ),
          )
          :
          Center(
            child: CircularProgressIndicator()
          )
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPictureScreen> {
  final String imagePath = Get.arguments as String;
  bool _isSucceed = false;
  bool _isRequested = false;
  bool _isFail = false;

  void evoke(bool b) {
    _isSucceed = b;
    _isRequested = false;
    _isFail = !b;
    setState(() {});
  }

  Widget resultText() {
    if(_isRequested) {
      return CircularProgressIndicator();
    }
    if(!_isRequested && _isFail && !_isSucceed) {
      return Text(
        '얼굴 인식에 실패하였습니다. 다시 촬영해주세요.',
        style: TextStyle(
          fontSize: 18,
          color: Colors.red),
        );
    }
    if(!_isRequested && !_isFail && _isSucceed) {
      Fluttertoast.showToast(msg: '얼굴을 등록하였습니다.',);
      Get.back(result: true);
    }
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    print(imagePath);
    return Scaffold(
      appBar: AppBar(
        title: Text('얼굴 등록하기'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: resultText()
          ),
          Container(
              padding: EdgeInsets.fromLTRB(80, 40, 80, 20),
              child: Image.file(File(imagePath)),
          ),
          _isFail|_isRequested|_isSucceed ? ElevatedButton(
            child: Text('사진 등록하기'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,enableFeedback: false, ),
            onPressed: null,
          )
          :ElevatedButton(
            onPressed: () async {
              mqttConnection mqtt = mqttConnection();
              Uint8List bytes = await File(imagePath).readAsBytes();
              String base64bytes = base64.encode(bytes);
              Map<String, dynamic> jsonObj = {
                "cmd_type":1,
                "face_img":base64bytes,
              };
              String msg = jsonEncode(jsonObj);
              mqtt.faceRequest(msg, evoke);
              setState(() {
                _isRequested = true;
              });
            },
            child: Text('사진 등록하기'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,)
          ),
        ],
      ),
    );
  }
}
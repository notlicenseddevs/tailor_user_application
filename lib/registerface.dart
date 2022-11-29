import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


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
                  padding: EdgeInsets.all(50),
                  width: min(MediaQuery.of(context).size.height*0.8, MediaQuery.of(context).size.width*0.8) ,
                  height: min(MediaQuery.of(context).size.height*0.8, MediaQuery.of(context).size.width*0.8) ,
                  child: CameraPreview(_controller),
                ),
                ElevatedButton(onPressed: () async {
                  final path = await _controller.takePicture();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: path.path)),
                  );
                },
                child: Text('사진 찍기'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,))
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
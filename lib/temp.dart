import 'package:flutter/material.dart';
import 'package:tailor_user_application/boxwidgets.dart';

class TempPage extends StatefulWidget {

  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('임시 페이지', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black45,
      ),
    );
  }
}
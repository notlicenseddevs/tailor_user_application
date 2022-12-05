import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/favoriteplace.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'package:get/get.dart';

class MenuBox extends StatelessWidget {
  String MenuName;
  Color BoxColor;
  Widget TargetWidget;
  final dynamic? _Argument;
  MenuBox(this.MenuName, this.BoxColor, this.TargetWidget, this._Argument);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,40,30,0),
      color: BoxColor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print("tab");
            Get.to(TargetWidget, arguments: _Argument);
          },
          child: Container(
            height: 110,
            width: 600,
            padding: EdgeInsets.all(20),
            child: Container(
              child: Text(MenuName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  fontSize: 25,
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }
}

class PlaceBox extends StatelessWidget {
  String PlaceID;
  String PlaceName;
  double PlaceLat;
  double PlaceLng;
  String? PlaceDescribe;
  String? PlaceURL;
  PlaceBox(this.PlaceID, this.PlaceName, this.PlaceLat, this.PlaceLng, this.PlaceDescribe, this.PlaceURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,40,30,0),
      color: Colors.white,
      child: Container(
        height: 160,
        width: 600,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(PlaceName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          print('pong');

                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          print('pong');
                          String msg = jsonEncode({"cmd_type":6,"target_list":2,"item_oid":PlaceID});
                          mqttConnection mqtt = mqttConnection();
                          mqtt.requestToServer(msg);
                          Get.off(FavoritePlace());
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('좌표 : $PlaceLat, $PlaceLng',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -0.5,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('설명 : $PlaceDescribe',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -0.5,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('주소 : $PlaceURL',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -0.5,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistBox extends StatelessWidget {
  String PlaylistName;
  String PlaylistURL;
  PlaylistBox(this.PlaylistName, this.PlaylistURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,40,30,0),
      color: Colors.white,
      child: Container(
        height: 140,
        width: 600,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(PlaylistName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      fontSize: 25,
                    ),
                  ),
                ),
                Icon(Icons.edit),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(PlaylistURL,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -0.5,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
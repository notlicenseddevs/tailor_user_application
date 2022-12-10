import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/favoriteplace.dart';
import 'package:tailor_user_application/mainpage.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/registerPlaylist.dart';
import 'package:tailor_user_application/registerplace.dart';

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
  final callBack;
  PlaceBox(this.PlaceID, this.PlaceName, this.PlaceLat, this.PlaceLng, this.PlaceDescribe, this.PlaceURL, this.callBack);

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
                        onPressed: () async {
                          List<dynamic?> value =
                            await Get.to(RegisterPlace(
                              inputText: PlaceDescribe,
                              lng: PlaceLng,
                              lat: PlaceLat,
                              name: PlaceName,
                              url: PlaceURL,
                            )) as List<dynamic?>;
                          Map<String, dynamic> revisionObj = {
                            "place_name":value[3],
                            "latitude":value[0],
                            "longitude":value[1],
                            "gmap_link":value[4],
                            "describe":value[2]
                          };
                          Map<String, dynamic> msgObj = {
                            "cmd_type": 7,
                            "target_list": 2,
                            "item_oid": PlaceID,
                            "revision": revisionObj,
                          };
                          String msg = jsonEncode(msgObj);
                          mqttConnection mqtt = mqttConnection();
                          mqtt.requestToServer(msg);
                          Fluttertoast.showToast(
                            msg: '수정하였습니다.',
                            gravity: ToastGravity.BOTTOM,
                          );
                          this.callBack(false);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text('데이터를 삭제하시겠습니까?\n\n(해당 작업은 취소할 수 없습니다.)'),
                                  actions: [
                                    TextButton(
                                      child: const Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('삭제'),
                                      onPressed: () {
                                        String msg = jsonEncode({"cmd_type":6,"target_list":2,"item_oid":PlaceID});
                                        mqttConnection mqtt = mqttConnection();
                                        mqtt.requestToServer(msg);
                                        this.callBack(false);
                                        Fluttertoast.showToast(
                                          msg: '해당 장소를 삭제하였습니다.',
                                          gravity: ToastGravity.BOTTOM,

                                        );
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
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
  String PlaylistID;
  String PlaylistName;
  String PlaylistURL;
  final callBack;
  PlaylistBox(this.PlaylistID, this.PlaylistName, this.PlaylistURL, this.callBack);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,40,30,0),
      color: Colors.white,
      child: Container(
        height: 140,
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
                    child: Text(PlaylistName,
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
                        onPressed: () async {
                          List<dynamic?> value =
                          await Get.to(RegisterPlaylist(
                            inputText: PlaylistName,
                            url: PlaylistURL,
                          )) as List<dynamic?>;
                          Map<String, dynamic> revisionObj = {
                            "name":value[0],
                            "url":value[1],
                          };
                          Map<String, dynamic> msgObj = {
                            "cmd_type": 7,
                            "target_list": 1,
                            "item_oid": PlaylistID,
                            "revision": revisionObj,
                          };
                          String msg = jsonEncode(msgObj);
                          mqttConnection mqtt = mqttConnection();
                          mqtt.requestToServer(msg);
                          this.callBack(false);
                          Fluttertoast.showToast(
                            msg: '수정하였습니다.',
                            gravity: ToastGravity.BOTTOM,

                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text('데이터를 삭제하시겠습니까?\n\n(해당 작업은 취소할 수 없습니다.)'),
                                  actions: [
                                    TextButton(
                                      child: const Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('삭제'),
                                      onPressed: () {
                                        String msg = jsonEncode({"cmd_type":6,"target_list":1,"item_oid":PlaylistID});
                                        mqttConnection mqtt = mqttConnection();
                                        mqtt.requestToServer(msg);
                                        this.callBack(false);
                                        Fluttertoast.showToast(
                                          msg: '해당 플레이리스트를 삭제하였습니다.',
                                          gravity: ToastGravity.BOTTOM,

                                        );
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('주소 : $PlaylistURL',
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
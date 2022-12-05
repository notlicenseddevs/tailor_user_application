import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tailor_user_application/boxwidgets.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'package:tailor_user_application/registerplace.dart';
import 'package:get/get.dart';

class FavoritePlace extends StatefulWidget {

  @override
  _FavoritePlaceState createState() => _FavoritePlaceState();
}

class _FavoritePlaceState extends State<FavoritePlace> {
  final List FavoritePlaceList = [];
  mqttConnection mqtt = mqttConnection();
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    print('아!!!!!!!!!!!!!!!');
    loadData();
  }

  void loadData() {
    String id;
    String place_name;
    double latitude;
    double longitude;
    String gmap_link;
    String describe;
    StreamController<dynamic> data = StreamController();
    StreamController<bool> check = StreamController();
    FavoritePlaceList.clear();
    _loading = true;
    setState(() {});
    mqtt.placeRequest('{"cmd_type":4,"refresh_target":2}', data);
    data.stream.listen((v) {
      print(v.length);
      for(int i=0;i<v.length;i++) {
        id = v[i]['_id'];
        place_name = v[i]['place_name'];
        latitude = v[i]['latitude'];
        longitude = v[i]['longitude'];
        gmap_link = v[i]['gmap_link'];
        describe = v[i]['describe'];
        FavoritePlaceList.add({'PlaceID':id, 'PlaceDescribe':describe, 'PlaceLat':latitude, 'PlaceLng':longitude, 'PlaceName':place_name, 'PlaceURL':gmap_link});
      }
      setState(() {
        _loading = false;
      });
    });
  }

  Widget listview_builder() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: FavoritePlaceList.length,
      itemBuilder: (BuildContext context, int index) {
        return PlaceBox(
            FavoritePlaceList[index]['PlaceID'], FavoritePlaceList[index]['PlaceName'],
            FavoritePlaceList[index]['PlaceLat'], FavoritePlaceList[index]['PlaceLng'],
            FavoritePlaceList[index]['PlaceDescribe'], FavoritePlaceList[index]['PlaceURL']
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장소 즐겨찾기', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.deepPurple,
      ),
      body: !_loading ? Column(
        children: [
          Expanded(child: listview_builder()),
        ],
      )
      :
      Center(child: CircularProgressIndicator())
      ,
      floatingActionButton: !_loading ? FloatingActionButton(
        onPressed: () async {
          List<dynamic?> value = await Get.to(RegisterPlace()) as List<dynamic?>;
          print(value);
          // if(value.length == 5) {
          //   for(int i=0;i<5;i++) {
          //     if(value[i] == null) value[i] = 'None';
          //   }
          //   for(int i=0;i<5;i++) {
          //     print('NULL CHECK!!! value $i is ${value[i]}');
          //   }
          Map<String, dynamic> msg = {"place_name":value[3], "latitude":value[0], "longitude":value[1], "gmap_link":value[4], "describe":value[2]};
          String jsonMsg = jsonEncode(msg);
          mqttConnection mqtt = mqttConnection();
          mqtt.requestToServer('{"cmd_type":5,"target_list":2,"item":$jsonMsg}');
            //FavoritePlaceList.add({'PlaceID':'tempid', 'PlaceDescribe':value[2], 'PlaceAddress':'${value[0]}, ${value[1]}', 'PlaceName':value[3], 'PlaceURL':value[4]});
            // if(value[2] == null) {
            //   FavoritePlaceList.add({'PlaceName':'NoName', 'PlaceAddress':'${value[0]}, ${value[1]}'});
            // }
            // else {
            //
            // }
          loadData();
          setState((){});
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      )
      :
      FloatingActionButton(
        backgroundColor: Colors.black26,
        onPressed: null,
      )
    );
  }
}
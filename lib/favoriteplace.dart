import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    loadData(true);
  }

  void loadData(bool doRefresh) {
    String id;
    String place_name;
    double latitude;
    double longitude;
    String gmap_link;
    String describe;
    StreamController<dynamic> data = StreamController();
    FavoritePlaceList.clear();
    _loading = true;
    setState(() {});
    if(doRefresh) {
      print('do Refresh!');
      mqtt.placeRequest('{"cmd_type":4,"refresh_target":2}', data);
    }
    data.stream.listen((v) {
      print(v.length);
      for(int i=0;i<v.length;i++) {
        id = v[i]['_id'];
        place_name = v[i]['place_name']!=null ? v[i]['place_name'] : 'NONE';
        latitude = v[i]['latitude']!=null ? v[i]['latitude'] : 0;
        longitude = v[i]['longitude']!=null ? v[i]['longitude'] : 0;
        gmap_link = v[i]['gmap_link']!=null ? v[i]['gmap_link'] : 'NONE';
        describe = v[i]['describe']!=null ? v[i]['describe'] : 'NONE';
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
            FavoritePlaceList[index]['PlaceDescribe'], FavoritePlaceList[index]['PlaceURL'], loadData
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
          List<dynamic> value = await Get.to(RegisterPlace()) as List<dynamic>;
          print(value);
          Map<String, dynamic> dataObj = {
            "place_name":value[3],
            "latitude":value[0],
            "longitude":value[1],
            "gmap_link":value[4],
            "describe":value[2]
          };
          Map<String, dynamic> msgObj = {
            "cmd_type":5,
            "target_list":2,
            "item":dataObj
          };
          String msg = jsonEncode(msgObj);
          mqttConnection mqtt = mqttConnection();
          mqtt.requestToServer(msg);
          Fluttertoast.showToast(
            msg: '해당 장소가 즐겨찾기에 추가되었습니다.',
            gravity: ToastGravity.BOTTOM,

          );
          loadData(false);
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
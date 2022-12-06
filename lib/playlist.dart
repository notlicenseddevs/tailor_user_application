import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/boxwidgets.dart';
import 'package:tailor_user_application/mqttConnection.dart';
import 'package:tailor_user_application/registerPlaylist.dart';

class PlayList extends StatefulWidget {
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  final List PlayList = [];
  mqttConnection mqtt = mqttConnection();
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    loadData(true);
  }

  void loadData(bool doRefresh) {
    String id;
    String playlist_name;
    String playlist_url;
    StreamController<dynamic> data = StreamController();
    PlayList.clear();
    _loading = true;
    setState(() {});
    if(doRefresh) {
      mqtt.playlistRequest('{"cmd_type":4,"refresh_target":1}', data);
    }
    data.stream.listen((v) {
      print(v['playlist'].length);
      for(int i=0;i<v['playlist'].length;i++) {
        id = v['playlist'][i]['_id'];
        playlist_name = v['playlist'][i]['name'];
        playlist_url = v['playlist'][i]['url'];
        PlayList.add({'PlaylistID':id, 'PlaylistName':playlist_name, 'PlaylistURL':playlist_url});
        print('add $i');
      }
      setState(() {
        _loading = false;
      });
    });
  }

  Widget listview_builder() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: PlayList.length,
      itemBuilder: (BuildContext context, int index) {
        print('listview index $index');
        return PlaylistBox(PlayList[index]['PlaylistID'], PlayList[index]['PlaylistName'], PlayList[index]['PlaylistURL'], loadData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('플레이리스트', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.redAccent,
      ),
      body: !_loading ? Column(
        children: [
          Expanded(child: listview_builder()),
        ],
      )
      :
      Center(child: CircularProgressIndicator()),
      floatingActionButton: !_loading ? FloatingActionButton(
        onPressed: () async {
          List<dynamic?> value = await Get.to(RegisterPlaylist()) as List<dynamic?>;
          Map<String, dynamic> dataObj = {
            "name":value[0],
            "url":value[1]
          };
          Map<String, dynamic> msgObj = {
            "cmd_type":5,
            "target_list":1,
            "item":dataObj
          };
          String msg = jsonEncode(msgObj);
          mqtt.requestToServer(msg);
          Fluttertoast.showToast(
            msg: '해당 플레이리스트가 추가되었습니다.',
            gravity: ToastGravity.BOTTOM,

          );
          loadData(false);
          setState((){});
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      )
      :
      FloatingActionButton(
        backgroundColor: Colors.black26,
        onPressed: null,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_user_application/boxwidgets.dart';
import 'package:tailor_user_application/registerPlaylist.dart';

class PlayList extends StatefulWidget {

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  static final List PlayList = [];
  @override
  void initState() {
    super.initState();
  }

  Widget listview_builder() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: PlayList.length,
      itemBuilder: (BuildContext context, int index) {
        return PlaylistBox(PlayList[index]['PlayListName'], PlayList[index]['PlayListURL']);
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
      body: Column(
        children: [
          Expanded(child: listview_builder()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        //PlayList.add({'PlayListName':'플레이리스트', 'PlayListURL':'youtu.be/link'});
          List<String?> value = await Get.to(RegisterPlaylist()) as List<String?>;
          print(value);
          if(value.length == 2) {
            PlayList.add({'PlayListName':value[0], 'PlayListURL':value[1]});
          }
          setState((){});
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
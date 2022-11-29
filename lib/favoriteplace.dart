import 'package:flutter/material.dart';
import 'package:tailor_user_application/boxwidgets.dart';
import 'package:tailor_user_application/registarplace.dart';
import 'package:get/get.dart';

class FavoritePlace extends StatefulWidget {

  @override
  _FavoritePlaceState createState() => _FavoritePlaceState();
}

class _FavoritePlaceState extends State<FavoritePlace> {
  static final List FavoritePlaceList = [];
  @override
  void initState() {
    super.initState();
  }

  Widget listview_builder() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: FavoritePlaceList.length,
      itemBuilder: (BuildContext context, int index) {
        return PlaceBox(FavoritePlaceList[index]['PlaceName'], FavoritePlaceList[index]['PlaceAddress']);
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
      body: Column(
        children: [
          Expanded(child: listview_builder()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //FavoritePlaceList.add({'PlaceName':'장소 1', 'PlaceAddress':'서울특별시'});
          List<String> value = await Get.to(RegistarPlace()) as List<String>;
          if(value.length == 3) {
            FavoritePlaceList.add({'PlaceName':value[2], 'PlaceAddress':'${value[0]}, ${value[1]}'});
          }
          setState((){});
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
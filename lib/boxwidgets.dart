import 'package:flutter/material.dart';
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
  String PlaceName;
  String PlaceAddress;
  PlaceBox(this.PlaceName, this.PlaceAddress);

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
                  child: Text(PlaceName,
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
              child: Text(PlaceAddress,
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
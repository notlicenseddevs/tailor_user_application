import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tailor_user_application/locations_service.dart';

class SearchbyGoogleMap extends StatefulWidget {
  @override
  _SearchbyGoogleMapState createState() => _SearchbyGoogleMapState();
}

class _SearchbyGoogleMapState extends State<SearchbyGoogleMap> {
  @override
  void initState() {
    super.initState();
  }
  double lng=0, lat=1;
  TextEditingController _searchController = TextEditingController();

  static final CameraPosition _tempPosition = CameraPosition(
    target: LatLng(38, 127),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('장소 검색', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: Colors.deepPurple,
        ),
        body:Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: '장소를 검색하세요.'),
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    LocationService().getPlaceId(_searchController.text);
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _tempPosition,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.back(result: [lng, lat]);
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.save),
        ),
    );
  }
}
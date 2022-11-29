import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tailor_user_application/locations_service.dart';
import 'package:geolocator/geolocator.dart';

class SearchbyGoogleMap extends StatefulWidget {
  @override
  _SearchbyGoogleMapState createState() => _SearchbyGoogleMapState();
}

class _SearchbyGoogleMapState extends State<SearchbyGoogleMap> {
  double lng=0, lat=1;
  TextEditingController _searchController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  late Position currentPosition;
  bool _setCurrentPosition = false;
  late CameraPosition _initialPosition;
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    readyToCurrentLocation();
  }

  void readyToCurrentLocation() async {
    currentPosition = await LocationService().getCurrentLocation();
    lng = currentPosition.longitude;
    lat = currentPosition.latitude;
    _initialPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 15,
    );
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      draggable: true,
      position: LatLng(lat, lng),
    ));
    setState(() {
      _setCurrentPosition = true;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('장소 검색', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: Colors.deepPurple,
        ),
        body: _setCurrentPosition ? Column(
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
                  onPressed: () async {
                    var place = await LocationService().getPlace(_searchController.text);
                    _goToPlace(place);
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set.from(_markers),
              ),
            ),
          ],
        )
        : Center(
            child: CircularProgressIndicator()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('$lng and $lat sends');
            Get.back(result: [lng, lat]);
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.save),
        ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double place_lat = place['geometry']['location']['lat'];
    final double place_lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition (
      CameraPosition(target: LatLng(place_lat, place_lng), zoom:15),
    ));
    _markers.remove('marker');
    setState(() {
      lng = place_lng;
      lat = place_lat;
      _markers.add(Marker(
        markerId: MarkerId('marker'),
        draggable: true,
        position: LatLng(place_lat, place_lng),
      ));
    });
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:tailor_user_application/api_key.dart' as API_KEY_FILE;

class LocationService {
  final String key = API_KEY_FILE.API_KEYS;

  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print('location service json === ${json}');
    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position =
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}
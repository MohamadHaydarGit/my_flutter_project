import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService{
  final String key = 'AIzaSyC_JrO87D3YMF9GLiQD38WsLO6OOJ-kO7w';

  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    print(placeId);

     return placeId;



  }

  // Future<String, dynamic> getPlaceId(String input) async {
  //
  // }

}
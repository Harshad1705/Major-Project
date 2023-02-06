import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  String key = 'AIzaSyDyENzbm0XRfzVVAJmFGrSv6fGEdVkhhBM';
  Future<Map<String, dynamic>> getNearestStation(double originLat, double originLong,) async {
    final url = Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$originLat,$originLong&rankby=distance&keyword=police station&types=police&&key=$key");
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var results = {
      'name': json['results'][0]['name'],
      'latitude': json['results'][0]['geometry']['location']['lat'],
      'longitude': json['results'][0]['geometry']['location']['lng'],
    };
    return results;
  }
  Future<Map<String, dynamic>> getDirection(double originLat, double originLong, double destinationLat, double destinationLong) async {
    final url = Uri.parse("https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLong&destination=$destinationLat,$destinationLong&alternatives=false&key=$key");
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'polyline_decoded': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
      'distance': json['routes'][0]['legs'][0]['distance']['text'],
      'time': json['routes'][0]['legs'][0]['duration']['text'],
      'steps': json['routes'][0]['legs'][0]['steps'],
    };
    return results;
  }
}

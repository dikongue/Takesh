import 'dart:convert';

import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:http/http.dart' as http;

const apiKey = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(
      LocationModel post, LocationModel dest) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${post.lat},${post.lng}&destination=${dest.lat},${dest.lng}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

// pour le tracking
  Future<String> getRouteCoordinates2(
      PositionModel post, PositionModel dest) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${post.latitude},${post.longitude}&destination=${dest.latitude},${dest.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

  Future<LocationModel> getRoutePlaceById(String paceId) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$paceId&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    LocationModel location =
        LocationModel.fromJson(values["result"]["geometry"]["location"]);
    return location;
  }

  Future<DistanceTime> getDistanceTime(double latOrg, double lngOrg, double latDest, double lngDest) async {
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins="+latOrg.toString()+","+lngOrg.toString()+"&destinations="+latDest.toString()+","+lngDest.toString()+"&mode=driving&language=fr-FR&key="+apiKey;
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    DistanceTime location =
        DistanceTime.fromJson(values["rows"][0]["elements"][0]);
    return location;
  }
}

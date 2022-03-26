import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const apiKey = "AIzaSyA1MgLuZuyqR_OGY3ob3M52N46TDBRI_9k";

class GoogleMapService {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    var response = await Dio().get(url);
    print(response.data);
    Map<String, dynamic> values = response.data;
    return values["routes"][0]["overview_polyline"]["points"];
  }
}

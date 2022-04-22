import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const apiKey = "AIzaSyA1MgLuZuyqR_OGY3ob3M52N46TDBRI_9k";

class GoogleMapService {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    var response = await Dio().get(url);
    // print(response.data);
    Map<String, dynamic> values = response.data;
    return values["routes"][0]["overview_polyline"]["points"];
  }

  Future<List<LatLng>> createRoute(LatLng position, LatLng destination) async {
    List<LatLng> result = <LatLng>[];
    String route = await getRouteCoordinates(position, destination);
    List points = _decodePolyLineResponse(route);
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePolyLineResponse(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());
    return lList;
  }
}

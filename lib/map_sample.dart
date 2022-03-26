import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  var _center = LatLng(-7.5589494045543475, 110.85658809673708);
  var _destination = LatLng(-7.559225930136833, 110.85448524500679);
  List<LatLng> _points = [
    LatLng(-7.559225930136833, 110.85448524500679),
    LatLng(-7.5589494045543475, 110.85658809673708)
  ];

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    Position position = await _determinePosition();
    log(position.latitude.toString());
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: _center,
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _center,
            builder: (ctx) => Container(
              child: Icon(
                Icons.location_on,
                size: 24,
                color: Colors.red,
              ),
            ),
          ),
          Marker(
            width: 80.0,
            height: 80.0,
            point: _destination,
            builder: (ctx) => Container(
              child: Icon(
                Icons.location_on,
                size: 24,
                color: Colors.red,
              ),
            ),
          ),
        ]),
        PolylineLayerOptions(polylines: [
          Polyline(points: _points),
        ])
      ],
    );
  }
}

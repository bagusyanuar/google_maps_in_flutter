import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/GoogleMapService.dart';

class GoogleMapSample extends StatefulWidget {
  @override
  _GoogleMapSampleState createState() => _GoogleMapSampleState();
}

class _GoogleMapSampleState extends State<GoogleMapSample> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapService _gmapServices = GoogleMapService();
  static const LatLng _center =
      const LatLng(-7.559002582564732, 110.85657736790172);
  static const LatLng _destination =
      const LatLng(-7.5576305878015475, 110.85281691110852);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _center,
    zoom: 14.4746,
  );

  List<LatLng> _listPolilyne = [_center, _destination];
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId("p2"),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red));
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("111"),
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
      ));

      _markers.add(Marker(
        markerId: MarkerId("112"),
        position: _destination,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        polylines: _polyLines,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: sendRequest,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _routeResponse() async {
    const apiKey = "AIzaSyA1MgLuZuyqR_OGY3ob3M52N46TDBRI_9k";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_center.latitude},${_center.longitude}&destination=${_destination.latitude},${_destination.longitude}&key=$apiKey";
    var response = await Dio().get(url);
    print(response.data);
  }

  void sendRequest() async {
    String route =
        await _gmapServices.getRouteCoordinates(_center, _destination);
    createRoute(route);
    _onAddMarkerButtonPressed();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialPosition =
      CameraPosition(target: ExampleCenter, zoom: 13);

  final Set<Marker> _markers = {};
  LatLng center = ExampleCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )),
      ),
    );
  }

  void _createMarker(List<Map<String, dynamic>> odc) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("111"),
          position: center,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );

      odc.forEach((element) {
        print("create other marker");
        LatLng _pos = LatLng(
            element["lat"] as double, element["long"] as double);
        _markers.add(
          Marker(
            markerId: MarkerId(element["id"] as String),
            position: _pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
                
          ),
        );
      });
    });
  }

  void _getCurrentPosition() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      double lat = preferences.getDouble("latitude") ?? -7.5589494045543475;
      double long = preferences.getDouble("longitude") ?? 110.85658809673708;
      LatLng currentCenter = LatLng(lat, long);
      setState(() {
        center = currentCenter;
        _initialPosition = CameraPosition(
          zoom: 14,
          target: currentCenter,
        );
      });
      List<Map<String, dynamic>> _listODC = DataDummy.DummyMapping;
      _createMarker(_listODC);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/controller/mapping.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getListODC,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  void _createMarker(List<dynamic> odc) {
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
        String id = element["id"].toString();
        String name = element["nama"] as String;
        LatLng _pos =
            LatLng(element["latitude"] as double, element["longitude"] as double);
        _markers.add(
          Marker(
            markerId: MarkerId(id),
            position: _pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            infoWindow: InfoWindow(
              title: name,
            ),
            onTap: (){
              print("Tapped");
            }
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
      List<dynamic> _data = await ListODC();
      _createMarker(_data);
    } catch (e) {
      print(e.toString());
    }
  }

  void _getListODC() async {
    List<dynamic> _list = await ListODC();
    print(_list);
  }
}

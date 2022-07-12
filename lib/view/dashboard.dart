import 'dart:async';
import 'dart:developer';

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  _getNearestODC(context);
                },
                child: Container(
                  height: 60,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      Text(
                        "ODC Terdekat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/search");
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Colors.black54.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.search,
                            size: 24,
                            color: Colors.black54.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          "Cari ODC...",
                          style: TextStyle(
                            color: Colors.black54.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _getListODC,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
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
        LatLng _pos = LatLng(
            element["latitude"] as double, element["longitude"] as double);
        _markers.add(
          Marker(
              markerId: MarkerId(id),
              position: _pos,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
              infoWindow: InfoWindow(
                title: name,
              ),
              onTap: () {
                print("Tapped");
              }),
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
      List<dynamic> _data = await getListODC('');
      _createMarker(_data);
    } catch (e) {
      print(e.toString());
    }
  }

  void _getNearestODC(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double lat = preferences.getDouble("latitude") ?? -7.5589494045543475;
    double long = preferences.getDouble("longitude") ?? 110.85658809673708;
    // log("abc");
    // log(lat.toString());
    // await getNearestODC(lat, long);
    Map<String, dynamic> _data = await getNearestODC(lat, long);
    // log(_data.toString());
    int id = _data["id"] as int;
    Navigator.pushNamedAndRemoveUntil(
        context, "/detail", ModalRoute.withName("/dashboard"),
        arguments: id);
  }
}

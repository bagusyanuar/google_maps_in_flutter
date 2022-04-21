import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/component/page-loading.dart';
import 'package:google_maps_in_flutter/controller/mapping.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> dataODC = {};
  bool isLoading = true;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialPosition =
      CameraPosition(target: ExampleCenter, zoom: 15);

  final Set<Marker> _markers = {};
  LatLng center = ExampleCenter;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int id = ModalRoute.of(context)!.settings.arguments as int;
      print("Argument Value " + id.toString());
      _getDetailODC(id);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? PageLoading(text: "Sedang Mempersiapkan Halaman")
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _initialPosition,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Detail ODC",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  void _getDetailODC(int id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      double lat = preferences.getDouble("latitude") ?? -7.5589494045543475;
      double long = preferences.getDouble("longitude") ?? 110.85658809673708;
      LatLng currentCenter = LatLng(lat, long);
      Map<String, dynamic> _data = await getDetailODC(id);
      setState(() {
        center = currentCenter;
        _initialPosition = CameraPosition(
          zoom: 15,
          target: currentCenter,
        );
        dataODC = _data;
        isLoading = false;
      });
      print(_data);
      _createMarker(_data);
    } catch (e) {
      print(e.toString());
    }
  }

  void _createMarker(Map<String, dynamic> target) {
    String id = target["id"].toString();
    String name = target["nama"] as String;
    LatLng _pos =
        LatLng(target["latitude"] as double, target["longitude"] as double);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("111"),
          position: center,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: _pos,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    });
  }
}

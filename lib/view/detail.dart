import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/GoogleMapService.dart';
import 'package:google_maps_in_flutter/component/page-loading.dart';
import 'package:google_maps_in_flutter/controller/mapping.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> dataODC = {};
  bool isLoading = true;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapService _googleMapService = GoogleMapService();
  CameraPosition _initialPosition =
      CameraPosition(target: ExampleCenter, zoom: 15);

  Set<Marker> _markers = {};
  LatLng center = ExampleCenter;
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  String kmlFile = '';
  String fileName = '';

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int id = ModalRoute.of(context)!.settings.arguments as int;
      print("Argument Value " + id.toString());
      _getDetailODC(id);
      // _getODCKMLFile(id);
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
                        polylines: _polyLines,
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
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Nama ODC",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                dataODC["nama"].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Deskripsi",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                dataODC["deskripsi"].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () async {
                                    log(kmlFile);
                                    if (kmlFile == '') {
                                      Fluttertoast.showToast(
                                        msg: "File Tidak Tersedia...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      log('abc');
                                      Map<Permission, PermissionStatus>
                                          statuses = await [
                                        Permission.storage,
                                        //add more permission to request here.
                                      ].request();

                                      if (statuses[Permission.storage]!
                                          .isGranted) {
                                        final downloadDir =
                                            await getExternalStorageDirectory();
                                        log(downloadDir.toString());
                                        if (downloadDir != null) {
                                          // String dir = p.join(
                                          //     downloadDir.path, "Download");
                                          // log(dir);
                                          String savename = fileName;
                                          String savePath =
                                              downloadDir.path + "/$savename";
                                          log(savePath);
                                          //output:  /storage/emulated/0/Download/banner.png

                                          try {
                                            log('progress');
                                            Response response = await Dio().get(
                                              kmlFile,
                                              onReceiveProgress:
                                                  (received, total) {
                                                if (total != -1) {
                                                  log((received / total * 100)
                                                          .toStringAsFixed(0) +
                                                      "%");
                                                  //you can build progressbar feature too
                                                }
                                              },
                                              options: Options(
                                                  responseType:
                                                      ResponseType.bytes,
                                                  followRedirects: false,
                                                  validateStatus: (status) {
                                                    return status! < 500;
                                                  }),
                                            );
                                            File file = File(savePath);
                                            var raf = file.openSync(
                                                mode: FileMode.write);
                                            raf.writeFromSync(response.data);
                                            await raf.close();
                                            Fluttertoast.showToast(
                                              msg: "File Di Simpan di " +
                                                  savePath,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            log(response.headers.toString());
                                            log("File is saved to download folder.");
                                          } on DioError catch (e) {
                                            log(e.message.toString());
                                            Fluttertoast.showToast(
                                              msg: "Error Download",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          } on Error catch (ex) {
                                            Fluttertoast.showToast(
                                              msg: "Error Download",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            log(ex.toString());
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Error Download",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Download File KML",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
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
      print("Fetch data");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      double lat = preferences.getDouble("latitude") ?? -7.5589494045543475;
      double long = preferences.getDouble("longitude") ?? 110.85658809673708;
      LatLng currentCenter = LatLng(lat, long);
      _getODCKMLFile(id);
      Map<String, dynamic> _data = await getDetailODC(id);
      setState(() {
        center = currentCenter;
        dataODC = _data;
        isLoading = false;
      });
      print(_data);
      _createMarker(_data);
    } catch (e) {
      print(e.toString());
    }
  }

  void _getODCKMLFile(int id) async {
    try {
      print("detect kml file");
      setState(() {
        kmlFile = '';
      });
      Map<String, dynamic> _data = await getODCKMLFile(id);
      log(_data.toString());
      int cData = _data['count'] as int;
      if (cData > 0) {
        String url = _data['data']['url'] as String;
        String name = _data['data']['file_name'] as String;
        setState(() {
          kmlFile = '$HostAddressFile$url';
          fileName = name;
        });
      }
      // print(_data);
      // _createMarker(_data);
    } catch (e) {
      log(e.toString());
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
    _createRoute(center, _pos);
    _calculateBoundMap(center, _pos);
  }

  void _calculateBoundMap(LatLng position, LatLng destination) async {
    double southWestLatitude = (position.latitude <= destination.latitude)
        ? position.latitude
        : destination.latitude;
    double southWestLongitude = (position.longitude <= destination.longitude)
        ? position.longitude
        : destination.longitude;
    double northEastLatitude = (position.latitude <= destination.latitude)
        ? destination.latitude
        : position.latitude;
    double northEastLongitude = (position.longitude <= destination.longitude)
        ? destination.longitude
        : position.longitude;

    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(southWestLatitude, southWestLongitude),
            northeast: LatLng(northEastLatitude, northEastLongitude),
          ),
          80),
    );
  }

  void _createRoute(LatLng position, LatLng destination) async {
    List<LatLng> points =
        await _googleMapService.createRoute(position, destination);
    print(points);
    setState(() {
      _polyLines.add(
        Polyline(
            polylineId: PolylineId("p2"),
            width: 4,
            points: points,
            color: Colors.red),
      );
    });
  }
}

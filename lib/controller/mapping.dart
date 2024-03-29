import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';

Future<List<dynamic>> getListODC(String name) async {
  List<dynamic> _listODC = [];
  try {
    String url = '$HostAddress/odc?name=' + name;
    final response = await Dio().get(
      url,
      options: Options(
        headers: {"Accept": "application/json"},
      ),
    );
    _listODC = response.data["payload"] as List;
    print(_listODC);
  } on DioError catch (e) {
    print(e.message);
  }
  return _listODC;
}

Future<Map<String, dynamic>> getDetailODC(int id) async {
  Map<String, dynamic> _data = {};
  try {
    String url = '$HostAddress/odc/' + id.toString();
    final response = await Dio().get(
      url,
      options: Options(
        headers: {"Accept": "application/json"},
      ),
    );
    _data = response.data["payload"] as Map<String, dynamic>;
  } on DioError catch (e) {
    print(e.message);
  }
  return _data;
}

Future<Map<String, dynamic>> getNearestODC(
    double latitude, double longitude) async {
  Map<String, dynamic> _data = {};
  try {
    String url = '$HostAddress/mapping?latitude=' +
        latitude.toString() +
        '&longitude=' +
        longitude.toString();
    final response = await Dio().get(url,
        options: Options(
          headers: {"Accept": "application/json"},
        ));
    log(response.data['payload'].toString());
    _data = response.data["payload"] as Map<String, dynamic>;
  } on DioError catch (e) {
    log(e.response!.data.toString());
    print(e.message);
  }
  return _data;
}

Future<Map<String, dynamic>> getODCKMLFile(int id) async {
  Map<String, dynamic> _data = {};
  try {
    String url = '$HostAddress/odc/' + id.toString() + '/kml';
    final response = await Dio().get(
      url,
      options: Options(
        headers: {"Accept": "application/json"},
      ),
    );
    _data = response.data["payload"] as Map<String, dynamic>;
  } on DioError catch (e) {
    print(e.message);
  }
  return _data;
}

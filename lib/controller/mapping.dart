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
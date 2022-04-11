import 'package:dio/dio.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';

Future<List<dynamic>> ListODC() async {
  List<dynamic> _listODC = [];
    try {
      String url = '$HostAddress/odc';
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

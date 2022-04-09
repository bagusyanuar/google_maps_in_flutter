import 'package:dio/dio.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';

void Login(Map<String, String> data) async {
  try {
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$HostAddress/login",
        options: Options(headers: {"Accept": "application/json"}),
        data: formData);
    final int status = response.data["status"] as int;
    if (status == 200) {
      print("Login Success");
    } else {
      print("Login Failed");
    }
  } on DioError catch (e) {
    print("Error "+e.response.toString());
  }
}

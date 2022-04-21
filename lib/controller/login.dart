import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loginHandler(Map<String, String> data, BuildContext context) async {
  try {
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$HostAddress/login",
        options: Options(headers: {"Accept": "application/json"}),
        data: formData);
    final int status = response.data["status"] as int;
    final String message = response.data["message"] as String;
    if (status == 200) {
      print("Login Success");
      final String token = response.data["payload"]["access_token"] as String;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("token", token);
      Fluttertoast.showToast(
        msg: "Login Success $token",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, "/dashboard", ModalRoute.withName("/dashboard"));
    } else {
      print("Login Failed");
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } on DioError catch (e) {
    Fluttertoast.showToast(
      msg: "Terjadi Kesalahan " + e.message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print("Error " + e.response.toString());
  }
}

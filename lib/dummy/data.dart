import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String ExampleUsername = "root";
const String ExamplePassword = "password";

const HostAddress = "http://192.168.100.19:8000/api";
const HostAddressFile = "http://192.168.100.19:8000";

LatLng ExampleCenter = LatLng(-7.5589494045543475, 110.85658809673708);

void DummyLogin(Map<String, String> data, BuildContext context) {
  String username = data["username"] as String;
  String password = data["password"] as String;
  if (username == ExampleUsername && password == ExamplePassword) {
    print("Login Success");
    Fluttertoast.showToast(
      msg: "Login Success",
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
      msg: "Login Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class DataDummy {
  static List<Map<String, dynamic>> DummyMapping = [
    {
      "id": "1112",
      "lat": -7.5589494045543475,
      "long": 110.85658809673708,
      "name": "ODC 1"
    },
    {
      "id": "1113",
      "lat": -7.5649494045543475,
      "long": 110.85258809673708,
      "name": "ODC 2"
    }
  ];
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_in_flutter/controller/location.dart';
import 'package:google_maps_in_flutter/controller/login.dart';
import 'package:google_maps_in_flutter/dummy/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = '';
  String password = '';
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/logo.png"), fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(bottom: 15),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      username = text;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      hintText: "Username"),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(bottom: 20),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      password = text;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Password"),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    if (!isLoading) {
                      login(context);
                    }
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red[400]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isLoading
                            ? Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.only(right: 5),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    Map<String, String> data = {"username": username, "password": password};
    print(data);
    setState(() {
      isLoading = true;
    });
    await loginHandler(data, context);
    setState(() {
      isLoading = false;
    });
  }

  void _getCurrentPosition() async {
    try {
      Position position = await determinePosition();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setDouble("latitude", position.latitude);
      preferences.setDouble("longitude", position.longitude);
      print("Cek Current Location");
      print(position.latitude.toString());
      print(position.longitude.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}

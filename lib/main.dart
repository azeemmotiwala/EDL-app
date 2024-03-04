import 'package:edl_app/signup.dart';
import 'package:flutter/material.dart';
import 'package:edl_app/home.dart';
// import 'package:edl_app/loading.dart';
import 'package:edl_app/bluetooth.dart';
import 'package:edl_app/login.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      // '/': (context) => Loading(),
      '/signup': (context) => SignupPage(),
      '/home': (context) => Home(),
      // '/bluetooth': (context) => BleScanner(),
      '/login': (context) => LoginPage(),
      '/bluetooth': (context) => Bluetooth(),
    },
  ));
  // minor change
}

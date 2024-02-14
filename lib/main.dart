import 'package:flutter/material.dart';
// import 'package:edl_app/home.dart';
// import 'package:edl_app/loading.dart';
import 'package:edl_app/login.dart';
import 'package:edl_app/bluetooth.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/bluetooth',
    routes: {
      // '/': (context) => Loading(),
      // '/home': (context) => Home(),
      '/login': (context) => Login(),
      '/bluetooth': (context) => Bluetooth(),
    },
  ));
  // minor change
}

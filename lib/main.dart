import 'package:flutter/material.dart';
// import 'package:edl_app/home.dart';
// import 'package:edl_app/loading.dart';
import 'package:edl_app/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      // '/': (context) => Loading(),
      // '/home': (context) => Home(),
      '/login': (context) => Login(),
    },
  ));
  
}

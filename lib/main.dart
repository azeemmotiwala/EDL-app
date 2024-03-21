import 'dart:convert';
// import 'dart:js';
import 'package:edl_app/return.dart';
import 'package:edl_app/signup.dart';
import 'package:edl_app/userpage.dart';
import 'package:flutter/material.dart';
import 'package:edl_app/home.dart';
// import 'package:edl_app/loading.dart';
import 'package:edl_app/scan.dart';
import 'package:edl_app/login.dart';
import 'package:edl_app/issue.dart';
import 'package:edl_app/verification.dart';
import 'package:edl_app/userpage.dart';
import 'package:edl_app/issueVerification.dart';
import 'package:edl_app/issuePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:edl_app/deviceprovider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          // '/': (context) => Loading(),
          // '/signup': (context) => SignupPage(),
          '/home': (context) => Home(),

          // '/login': (context) => LoginPage(),
          '/scan': (context) => Scan(),
          '/issue': (context) => Issue(),
          '/verification': (context) => OTPVerificationPage(
                email: "",
                onVerificationSuccess: () => {},
              ),
          '/userpage': (context) => UserPage(),
          '/issueVerification': (context) => IssueOTPVerificationPage(
                email: "",
                onVerificationSuccess: () => {},
                rollNo: "",
                location: "",
              ),
          '/issuePage': (context) => IssuePage(
                rollNo: "",
                location: "",
              ),
          '/return': (context) => Return(),
        },
      )));
  // minor change
}

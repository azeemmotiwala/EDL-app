import 'dart:convert';
// import 'dart:js';
// import 'dart:js';
import 'package:edl_app/deviceStatus.dart';
import 'package:edl_app/issueRequest.dart';
import 'package:edl_app/logs.dart';
import 'package:edl_app/request.dart';
import 'package:edl_app/return.dart';
import 'package:edl_app/signup.dart';
import 'package:edl_app/userpage.dart';
import 'package:edl_app/verifyDetails.dart';
import 'package:flutter/material.dart';
import 'package:edl_app/home.dart';
import 'package:edl_app/loading.dart';
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
import 'package:edl_app/add.dart';
import 'package:edl_app/discard.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          // '/signup': (context) => SignupPage(),
          '/home': (context) => Home(
                userData: {},
              ),
          '/login': (context) => LoginPage(),
          '/scan': (context) => Scan(),
          '/issue': (context) => Issue(),
          '/verification': (context) => OTPVerificationPage(
                email: "",
                onVerificationSuccess: () => {},
              ),
          '/issueVerification': (context) => IssueOTPVerificationPage(
                email: "",
                onVerificationSuccess: () => {},
                rollNo: "",
                location: "",
                name: "",
                phone_no: "",
                issue_date: DateTime.now(),
                return_date: DateTime.now(),
              ),
          '/issuePage': (context) => IssuePage(
                rollNo: "",
                location: "",
                name: "",
                phone_no: "",
                issue_date: DateTime.now(),
                return_date: DateTime.now(),
                device: "",
              ),
          '/userPage': (context) => UserPage(
                userData: {},
              ),
          '/return': (context) => Return(),
          '/add': (context) => Add(),
          '/discard': (context) => Discard(),

          '/request': (context) => RequestPage(
                rollNo: "",
              ),
          '/issueUser': (context) => IssueUser(userData: {}),
          'logs': (context) => LogsPage(rollNo: ""),
          '/deviceStatus' : (context) => DeviceStatusPage(),
          '/verifyDetails': (context) => VerifyDetailsPage(
              userData: {}, location: "", deviceName: "", facultyEmail: "")
        },
      )));
}

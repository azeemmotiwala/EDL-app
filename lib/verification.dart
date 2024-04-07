import 'dart:convert';

import 'package:edl_app/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/ip.dart';
import 'package:edl_app/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

String startUrl = ip;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyscan =
    GlobalKey<ScaffoldMessengerState>();

void showSnack(String title) {
  final snackbar = SnackBar(
      content: Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 15,
    ),
  ));
  scaffoldMessengerKeyscan.currentState?.showSnackBar(snackbar);
}

class OTPVerificationPage extends StatefulWidget {
  final String email;
  final String username;
  final VoidCallback? onVerificationSuccess; // Callback function

  OTPVerificationPage(
      {required this.email,
      required this.username,
      required this.onVerificationSuccess});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String _errorMessage = '';
  bool _loading = false; // New variable to manage loading state

  // Function to send OTP
  Future<void> sendOTP(String email) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> data = {"email": email};
      print(email);
      final response = await http.post(Uri.parse('${startUrl}/send-otp/'),
          body: json.encode(data), headers: headers);
      if (response.statusCode == 200) {
        print('OTP sent successfully');
      } else {
        print('Failed to send OTP');
        showSnack('Failed to send OTP');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      setState(() {
        _errorMessage = 'Failed to send OTP';
      });
    }
  }

  // Function to verify OTP
  Future<void> verifyOTP() async {
    setState(() {
      _loading = true; // Set loading to true when the button is pressed
    });
    final String otp = _otpController.text.trim();
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    }; // Add headers if needed
    Map<String, dynamic> data = {"email": widget.email, "otp": otp};
    try {
      final response = await http.post(
        Uri.parse('${startUrl}/verify-otp/'),
        body: json.encode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('OTP verified successfully');
        // Navigate to the next screen upon successful verification
        setState(() {
          _loading =
              false; // Set loading to false when the verification is complete
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var userData = {"email": widget.email, "first_name": widget.username};
        await prefs.setString('userData', json.encode(userData));
        await prefs.setBool("isprof", true);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              userData: userData,
            ),
          ),
        );

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Verification Successful'),
        //       content: Text('Your OTP has been verified successfully.'),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () async {
        //             final SharedPreferences prefs =
        //                 await SharedPreferences.getInstance();
        //             var userData = {
        //               "email": widget.email,
        //               "first_name": widget.username
        //             };

        //             // Navigator.pushReplacementNamed(context, '/login');
        //           },
        //           child: Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        if (widget.onVerificationSuccess != null) {
          widget.onVerificationSuccess!();
        }
        // Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('Failed to verify OTP');
        setState(() {
          _loading =
              false; // Set loading to false when the verification is complete
        });
        setState(() {
          _errorMessage = 'Failed to verify OTP';
        });
      }
    } catch (err) {
      showSnack("Server error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: scaffoldMessengerKeyscan,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "Verification",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'OTP sent to ${widget.email}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                      SizedBox(height: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Didn't receive OTP?"),
                          TextButton(
                              onPressed: () {
                                showSnack("otp sent successfully");
                                // Navigator.pop(context);
                                sendOTP(widget.email);
                              },
                              child: const Text(
                                "Resend",
                                style: TextStyle(color: Colors.blueAccent),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _loading
                            ? null
                            : verifyOTP, // Disable button when loading
                        child:
                            _loading // Show different child based on loading state
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text('Verify OTP',
                                    style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 16.0),
                          primary: Colors.blue,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Want to change email?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.blueAccent),
                              ))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}

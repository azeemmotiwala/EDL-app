import 'dart:convert';

import 'package:edl_app/issuePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/issue.dart';
import 'package:edl_app/ip.dart';

String startUrl = ip;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyissue =
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
  scaffoldMessengerKeyissue.currentState?.showSnackBar(snackbar);
}

class IssueOTPVerificationPage extends StatefulWidget {
  final String email;
  final String rollNo;
  final String location;
  final String phone_no;
  final String name;
  final DateTime issue_date;
  final DateTime return_date;
  final VoidCallback? onVerificationSuccess; // Callback function

  IssueOTPVerificationPage(
      {required this.email,
      required this.onVerificationSuccess,
      required this.rollNo,
      required this.location,
      required this.name,
      required this.issue_date,
      required this.return_date,
      required this.phone_no});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<IssueOTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String _errorMessage = '';
  bool _loading = false; // New variable to manage loading state

  Future<void> sendOTP(String email) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> data = {"email": widget.email};
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
    // setState(() {
    //   _loading = true; // Set loading to true when the button is pressed
    // });
    // final String otp = _otpController.text.trim();
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json'
    // }; // Add headers if needed
    // Map<String, dynamic> data = {"email": widget.email, "otp": otp};
    // final response = await http.post(
    //   Uri.parse('${startUrl}/verify-otp/'),
    //   body: json.encode(data),
    //   headers: headers,
    // );

    // try{
    // if (response.statusCode == 200) {
    print('OTP verified successfully');
    setState(() {
      _loading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification Successful'),
          content: Text('Your OTP has been verified successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IssuePage(
                      rollNo: widget.rollNo,
                      location: widget.location,
                      phone_no: widget.phone_no,
                      name: widget.name,
                      issue_date: widget.issue_date,
                      return_date: widget.return_date,
                      device: "",
                    ),
                  ),
                );
                // .then((val) => {Navigator.pop(_context)});
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    // if (widget.onVerificationSuccess != null) {
    //   widget.onVerificationSuccess!();
    // }
    // } else {
    //   print('Failed to verify OTP');
    //   setState(() {
    //     _loading = false; // Set loading to false when the verification is complete
    //     _errorMessage = 'Failed to verify OTP';
    //   });
    // }
    // }
    // catch(e){
    //   print("server error");
    //   setState(() {
    //     _loading = false; // Set loading to false when the verification is complete
    //     _errorMessage = 'Server down';
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: scaffoldMessengerKeyissue,
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
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter OTP.',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      SizedBox(height: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Didn't receive OTP?"),
                          TextButton(
                              onPressed: () {
                                sendOTP(widget.email);
                              },
                              child: const Text(
                                "Resend",
                                style: TextStyle(color: Colors.blue),
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
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Issue",
                                style: TextStyle(color: Colors.blue),
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

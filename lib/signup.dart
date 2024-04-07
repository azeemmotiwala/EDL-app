import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/api.dart';
import 'package:edl_app/verification.dart';
import 'package:edl_app/ip.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmpasswordController = TextEditingController();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey2 =
    GlobalKey<ScaffoldMessengerState>();

String startUrl = ip;

void showSnack(String title) {
  final snackbar = SnackBar(
    content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
      ),
    ),
  );
  scaffoldMessengerKey2.currentState?.showSnackBar(snackbar);
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isEmailExists = false;
  String message = "";
  @override
  void initState() {
    super.initState();
    // Perform initialization tasks here
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmpasswordController.clear();
  }

  // @override
  // void dispose() {
  //   emailController.dispose();
  //   usernameController.dispose();
  //   passwordController.dispose();
  //   confirmpasswordController.dispose();
  //   super.dispose();
  // }

  Future<void> checkEmailExists(String email) async {
    final apiUrl = ip +
        '/check-email-exists/${email}'; // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          isEmailExists = responseData['exists'];
          if (!isEmailExists) {
            showSnack("Invalid email");
            setState(() {
              usernameController.clear();
              emailController.clear();
            });
          } else {}
          message = '';
        });
      } else {
        showSnack("Server error");
        // ('Failed to load data');
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
        showSnack("message");
      });
    }
  }

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
      showSnack('Failed to send OTP');

      print('Error sending OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: scaffoldMessengerKey2,
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
                        "Admin Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Welcome!",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                            hintText: "Username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.blue.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.person)),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.blue.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.email)),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () async {
                          await checkEmailExists(emailController.text);

                          Map<String, dynamic> data = {
                            'username': usernameController.text,
                            'email': emailController.text,
                          };
                          if (isEmailExists) {
                            sendOTP(emailController.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPVerificationPage(
                                  email: emailController.text,
                                  username: usernameController.text,
                                  onVerificationSuccess: () {
                                    print('User added successfully');
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue, // Change to blue color
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

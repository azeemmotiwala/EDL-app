import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/api.dart';
import 'package:edl_app/verification.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmpasswordController = TextEditingController();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey2 =
    GlobalKey<ScaffoldMessengerState>();

String startUrl = "http://192.168.43.144:8000";


void showSnack(String title) {
  final snackbar = SnackBar(
      content: Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 15,
    ),
  ));
  scaffoldMessengerKey2.currentState?.showSnackBar(snackbar);
}


class SignupPage extends StatelessWidget {
  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    // super.dispose();
  }

  Future<void> sendOTP(String email) async {
    try {
      Map<String, String> headers = {
      'Content-Type': 'application/json'
      }; 
      Map <String, dynamic> data = {"email": email};
      print(email);
      final response = await http.post(
        Uri.parse('${startUrl}/send-otp/'),
        body: json.encode(data),
        headers: headers
      );  
      if (response.statusCode == 200) {
        print('OTP sent successfully');
      } else {
        print('Failed to send OTP');
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      // setState(() {
      //   _errorMessage = 'Failed to send OTP';
      // });
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
                          "Sign up",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
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
                              fillColor: Colors.red.withOpacity(0.1),
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
                              fillColor: Colors.red.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.email)),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.red.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: confirmpasswordController,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.red.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),

                    Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> data = {
                              'username': usernameController.text,
                              'email': emailController.text,
                              'password': passwordController.text,
                              "name": "test",
                              "ldap_id": "18138",
                              "mobile_no": "90901"
                            };
                            if (usernameController.text.isEmpty ||
                                usernameController.text.length < 5) {
                              showSnack(
                                  "Username must be at least 5 characters long.");
                              return; // Prevent further execution if username is invalid
                            }

                            if (!RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                .hasMatch(emailController.text)) {
                              showSnack("Email Id not valid.");
                              return; // Prevent further execution if email is invalid
                            }

                            RegExp passwordRegex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            print(passwordController.text);
                            if (!passwordRegex
                                .hasMatch(passwordController.text)) {
                              showSnack(
                                  "Password must meet the following requirements:\n- At least 8 characters long\n- At least one uppercase and one lowercase letter\n- At least one number\n- At least one special character");
                              return; // Prevent further execution if password is invalid
                            }
                            if (passwordController.text !=
                                confirmpasswordController.text) {
                              // Display error message for mismatched passwords
                              showSnack(
                                  "Password Does not match the typed password");
                              return;
                            }
                            sendOTP(emailController.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPVerificationPage(
                                  email: emailController.text,
                                  onVerificationSuccess: () {
                                    addUser(data);
                                    print('User added successfully');
                                },
                              ),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.red[700],
                          ),
                        )),

                    

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

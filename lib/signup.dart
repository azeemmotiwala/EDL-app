import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final TextEditingController emailController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmpasswordController = TextEditingController();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

String url = 'http://10.42.0.34:8000/userinfo/'; // Replace with your actual URL
Map<String, String> headers = {
  'Content-Type': 'application/json'
}; // Add headers if needed

void showSnack(String title) {
  final snackbar = SnackBar(
      content: Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 15,
    ),
  ));
  scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
}

void apicall(data, headers, url) async {
  try {
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(data));
    // Handle the response
    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// void apicall(BuildContext scaffoldContext, Map<String, dynamic> data, Map<String, String> headers, String url) async {
//   try {
//     final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));
//     if (response.statusCode == 200) {
//       print('Request successful: ${response.body}');
//     } else {
//       print('Error: ${response.statusCode}');
//       // Show a Snackbar using the Scaffold's context
//       ScaffoldMessenger.of(scaffoldContext).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${response.statusCode}'),
//           backgroundColor: Colors.red.shade400,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   } catch (e) {
//     print('Error: $e');
//     // Show a Snackbar using the Scaffold's context
//     ScaffoldMessenger.of(scaffoldContext).showSnackBar(
//       SnackBar(
//         content: Text('Error: $e'),
//         backgroundColor: Colors.red.shade400,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

class SignupPage extends StatelessWidget {
  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScaffoldMessenger(
          key: scaffoldMessengerKey,
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
                            apicall(data, headers, url);
                            usernameController.text = "";
                            emailController.text = "";
                            passwordController.text = "";
                            confirmpasswordController.text = "";
                            Navigator.pop(context);
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

                    // const Center(child: Text("Or")),

                    // Container(
                    //   height: 45,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(25),
                    //     border: Border.all(
                    //       color: Colors.purple,
                    //     ),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.white.withOpacity(0.5),
                    //         spreadRadius: 1,
                    //         blurRadius: 1,
                    //         offset: const Offset(0, 1), // changes position of shadow
                    //       ),
                    //     ],
                    //   ),
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           height: 30.0,
                    //           width: 30.0,
                    //           decoration: const BoxDecoration(
                    //             image: DecorationImage(
                    //                 image:   AssetImage('assets/images/login_signup/google.png'),
                    //                 fit: BoxFit.cover),
                    //             shape: BoxShape.circle,
                    //           ),
                    //         ),

                    //         const SizedBox(width: 18),

                    //         const Text("Sign In with Google",
                    //           style: TextStyle(
                    //             fontSize: 16,
                    //             color: Colors.purple,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
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

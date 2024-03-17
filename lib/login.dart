import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/api.dart';

final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
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
  scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            body: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _header(context),
                  _inputField(context),
                  _forgotPassword(context),
                  _signup(context),
                ],
              ),
            ),
          ),
        ));
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "EDL App",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            // Navigator.pushReplacementNamed(context, '/home');
            // If the credentials are valid, proceed to the home screen

            if (usernameController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {

              if ( usernameController.text == "admin" && passwordController.text == "edl123"){
                Navigator.pushReplacementNamed(context, '/home');
              } 
              // Check if the username exists
              // bool checkUser = await checkUserCredentials(usernameController.text, passwordController.text);
              // bool checkInstructor = await checkInstructorCredentials(usernameController.text, passwordController.text);
              // If both username and password are valid, proceed to the home screen
              // if (checkInstructor){
              //   // dispose();
              //   Navigator.pushReplacementNamed(context, '/home');
              // }
              // else if(checkUser) {
              //   // dispose();
              //   Navigator.pushReplacementNamed(context, '/userpage');
              // } else {
              //   // Show an error message if the credentials are incorrect
              //   showSnack("Username or Password is Incorrect");
              // }
            } else {
              showSnack('Username or password cannot by empty');
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.red[700],
          ),
          child: const Text(
            "Login",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: TextStyle(color: Colors.red[700]),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.red[700]),
            ))
      ],
    );
  }
}

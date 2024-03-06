import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

Future<bool> checkUsername(String username) async {
  final response = await http
      .get(Uri.parse('http://10.42.0.34:8000/check-username/${username}'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data['exists'];
  } else {
    throw Exception('Failed to load username');
  }
}

Future<bool> checkPassword(String password) async {
  final response = await http
      .get(Uri.parse('http://10.42.0.34:8000/check-password/${password}'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data['exists'];
  } else {
    throw Exception('Failed to load password');
  }
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
              // Check if the username exists
              bool isUsernameValid =
                  await checkUsername(usernameController.text);

              // Check if the password exists
              bool isPasswordValid =
                  await checkPassword(passwordController.text);

              // If both username and password are valid, proceed to the home screen
              if (isUsernameValid && isPasswordValid) {
                // dispose();
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                // Show an error message if the credentials are incorrect
                showSnack("Username or Password is Incorrect");
              }
            } else {
              // Show an error message if either the username or password is empty
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Username and password cannot be empty.'),
              //     backgroundColor: const Color.fromARGB(255, 231, 208, 207),
              //   ),
              // );
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
              Navigator.pushNamed(context, '/signup');
            },
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.red[700]),
            ))
      ],
    );
  }
}

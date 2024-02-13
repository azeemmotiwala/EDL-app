import 'package:flutter/material.dart';


class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login Page"),
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      body: Column(children: [
        Center(
          child: Container(
            height: 150,
            width: 190,
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              // color: Colors.red,
            ),
            child: Center(
              child: Image.asset('assets/WEL-logo.png')
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Name',
              hintText: 'Enter Valid Email ID as abc@gmail.com',
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Enter your secure password',
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )
            ),
          )
        ),
        TextButton(
          onPressed:(){}, 
          child: Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.blue[900],
              fontSize: 15.0,
            ),
          )
        ),
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ],
      ),
    );
  }
}


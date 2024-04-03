// // // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // // All rights reserved. Use of this source code is governed by a
// // // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:edl_app/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/connection.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:edl_app/deviceprovider.dart';
import 'package:provider/provider.dart';

String startUrl = "http://192.168.43.144:8000";

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyscan =
    GlobalKey<ScaffoldMessengerState>();

final TextEditingController serialnoController = TextEditingController();

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

class Discard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BleScanner(),
    );
  }
}

class BleScanner extends StatefulWidget {
  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  bool check = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> discardDevice(String serialNo) async {
    showSnack("Discarded Successfully");
    //make api call with serial no, if no serial no exist in database, then show invalid serial no, if yes, then remove it from database;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // FlutterBluePlus.stopScan();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKeyscan,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Set background color to blue
          title: Text(
            'Discard Device Page',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Serial No:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: serialnoController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter device serial no.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Serial No',
                            prefixIcon: Icon(Icons.numbers_outlined),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  discardDevice(serialnoController.text);
                } else {
                  print('Serial number field is empty');
                }
              },
              child: Text(
                'Discard Device',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const CardButton({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:edl_app/connection.dart';
import 'package:edl_app/issueVerification.dart';
import 'package:http/http.dart' as http;

final TextEditingController emailController = TextEditingController();
final TextEditingController rollnoController = TextEditingController();
final TextEditingController locationController = TextEditingController();

String startUrl = "http://192.168.128.222:8000";

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
      throw Exception('Failed to send OTP');
    }
  } catch (e) {
    print('Error sending OTP: $e');
    // setState(() {
    //   _errorMessage = 'Failed to send OTP';
    // });
  }
}

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

class Issue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Issue(),
    );
  }
}

class _Issue extends StatefulWidget {
  @override
  _IssueState createState() => _IssueState();
}

class _IssueState extends State<_Issue> {
  late String _issueReason;
  late String _issueLocation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      // key: scaffoldMessengerKeyissue,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            height: MediaQuery.of(context).size.height / 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
              ),
            ),
          ),
          centerTitle: true,
          title: Text("Issuing Page"),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 8 / 8,
            child: Column(
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
                        //   Text(
                        //     'Reason for Issuing:',
                        //     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        //   ),
                        //   TextFormField(
                        //     onChanged: (value) {
                        //       _issueReason = value;
                        //     },
                        //     maxLines: 2,
                        //     decoration: InputDecoration(
                        //       border: OutlineInputBorder(),
                        //       hintText: 'Enter Reason',
                        //     ),
                        //   validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter a reason';
                        //   }
                        //   return null;
                        // },
                        // ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location of Use:',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: locationController,
                                    onChanged: (value) {
                                      _issueLocation = value;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Location',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a location';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width:
                                    8), // Add some spacing between the fields
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Roll No:',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    // initialValue: '210070018',
                                    // enabled: false,
                                    controller: rollnoController,
                                    onChanged: (value) {
                                      _issueLocation = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter Roll No.",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a Roll No.';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'LDAP Email ID:',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: emailController,
                          onChanged: (value) {
                            _issueReason = value;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter LDAP email ID',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a reason';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // ElevatedButton(
                //   // onPressed: isConnected
                //   //     ? () async {
                //   //         // Simulating a Bluetooth device
                //   //         await writeData(devices[0]);
                //   //         await readData(devices[0]);
                //   //       }
                //   //     : null,
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         // _submitIssue();
                //         print("hello");
                //       }
                //     },

                //   child: Text(
                //     'Issue device',
                //     style: TextStyle(fontSize: 18),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Issue with ID Card");
                        }
                      },
                      child: Text(
                        'Issue with ID Card',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                        height:
                            16), // Add some vertical spacing between the buttons
                    Text(
                      'or',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height:
                            16), // Add some vertical spacing between the buttons and the "or" text
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Issue via Email");
                          sendOTP(emailController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IssueOTPVerificationPage(
                                email: emailController.text,
                                onVerificationSuccess: () {
                                  // addUser(data);
                                  print('funciton called');
                                },
                                rollNo: rollnoController.text,
                                location: locationController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Issue via Email',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}




// void writeCharacteristic(
//     BluetoothDevice device, characteristicId, List<int> data) async {
//   List<BluetoothService> services = await device.discoverServices();
//   for (BluetoothService service in services) {
//     for (BluetoothCharacteristic characteristic in service.characteristics) {
//       if (characteristic.uuid == characteristicId) {
//         await characteristic.write(data);
//         print('Data written successfully.');
//       }
//     }
//   }
// }

// 28:CD:C1:08:97:9C
// 6e400003-b5a3-f393-e0a9-e50e24dcca9e

//write
//  serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, secondaryServiceUuid: null, characteristicUuid: 6e400002-b5a3-f393-e0a9-e50e24dcca9e

// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:edl_app/issuePage.dart';
import 'package:edl_app/return.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:edl_app/connection.dart';
import 'package:edl_app/issueVerification.dart';
import 'package:http/http.dart' as http;

final TextEditingController emailController = TextEditingController();
final TextEditingController rollnoController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController requestController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController returnDateController = TextEditingController();

String startUrl = "http://192.168.43.144:8000";

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool verified = false;

  String email = "";
  String rollNo = "";
  String location = "";
  String name = "";

  String phone_no = "";

  DateTime selectedIssueDate = DateTime.now();
  DateTime selectedReturnDate = DateTime.now().add(
      Duration(days: 365 * 3)); // Default return date is current date + 3 years

  @override
  void initState() {
    super.initState();
    // Clear text fields and reset selected return date when initializing the state

    requestController.clear();

    returnDateController.clear();
    selectedReturnDate = DateTime.now().add(Duration(days: 365 * 3));
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate ? selectedIssueDate : selectedReturnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(Duration(days: 365 * 3)), // Last date is current date + 3 years
    );
    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          selectedIssueDate = picked;
        } else {
          selectedReturnDate = picked;
          // Set the value of the return date text field
          returnDateController.text =
              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        }
      });
    }
  }

  void validate_requestid(String id) async {
    setState(() {
      verified = true;
      email = "vik@gmail.com";

      rollNo = "210070093";
      location = "hostel";
      name = " vikas";
      phone_no = "8306011719";
    });

    // final apiUrl = Uri.parse('http://10.59.1.225:8000/requests/$id');
    // try {
    //   final response = await http.get(apiUrl);
    //   if (response.statusCode == 200) {
    //     List<dynamic> userRequests =
    //         List<dynamic>.from(json.decode(response.body));
    //     bool hasRejected = userRequests.contains('rejected');
    //     bool hasPending = userRequests.contains('pending');
    //     bool allApproved = !hasPending && !hasRejected;
    //     if (allApproved == true) {
    //       verified = true;
    //     }

    //     return userRequests;
    //   } else {
    //     throw Exception('Failed to load user requests');
    //   }
    // } catch (error) {
    //   throw Exception('Failed to connect to the server');
    // }
  }

  @override
  void dispose() {
    // FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      // key: scaffoldMessengerKeyissue,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Set background color to blue
          title: Text(
            'Issuing Page',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
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
                              'Request ID:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              readOnly: verified,
                              controller: requestController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter request id';
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Request ID',
                                prefixIcon: Icon(Icons.format_indent_decrease),
                              ),
                            ),
                          ],
                        ),

                        if (verified) SizedBox(height: 20.0),
                        if (verified)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          16), // Adjust padding as needed
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(
                                            10), // Adjust border radius as needed
                                      ),
                                      child: Text(
                                        'Request ID Verified',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.check, color: Colors.green),
                                  ],
                                )
                              ]),
                        if (!verified)
                          CardButton(
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              print("Validate Request ID");
                              validate_requestid(requestController.text);
                              // }
                            },
                            text: 'Verify Request ID',
                            icon: Icons.email,
                          ),
                        // SizedBox(height: 20.0),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'Roll No:',
                        //       style: TextStyle(
                        //         fontSize: 18.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     TextFormField(
                        //       controller: rollnoController,
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return 'Please enter Roll No';
                        //         }
                        //       },
                        //       decoration: InputDecoration(
                        //         hintText: "Enter Roll No.",
                        //         border: OutlineInputBorder(),
                        //         prefixIcon: Icon(Icons.person),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 20.0),
                        // Text(
                        //   'LDAP Email ID:',
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // TextFormField(
                        //   controller: emailController,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter email ID';
                        //     }
                        //   },
                        //   maxLines: 1,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //     hintText: 'Enter LDAP email ID',
                        //     prefixIcon: Icon(Icons.email),
                        //   ),
                        // ),
                        // SizedBox(height: 20.0),
                        // Text(
                        //   'Name:',
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // TextFormField(
                        //   controller: nameController,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter your name';
                        //     }
                        //   },
                        //   maxLines: 1,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //     hintText: 'Enter your name',
                        //     prefixIcon: Icon(Icons.person),
                        //   ),
                        // ),
                        // SizedBox(height: 20.0),
                        // Text(
                        //   'Phone No:',
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // TextFormField(
                        //   controller: phoneController,
                        //   keyboardType: TextInputType.number,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter phone No.';
                        //     }
                        //   },
                        //   maxLines: 1,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //     hintText: 'Phone No.',
                        //     prefixIcon: Icon(Icons.phone),
                        //   ),
                        // ),
                        if (verified)
                          Column(
                            children: [
                              SizedBox(height: 20.0),
                              if (verified)
                                Text(
                                  'Issue Date:',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              TextFormField(
                                enabled: false, // Disable editing
                                initialValue:
                                    '${selectedIssueDate.year}-${selectedIssueDate.month.toString().padLeft(2, '0')}-${selectedIssueDate.day.toString().padLeft(2, '0')}',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Issue Date',
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Return Date:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      enabled: false,
                                      controller: returnDateController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Select Return Date',
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.date_range),
                                      onPressed: () {
                                        _selectDate(context, false);
                                        print(selectedReturnDate);
                                      }),
                                ],
                              ),
                              SizedBox(height: 20),
                              CardButton(
                                onPressed: () {
                                  // if (_formKey.currentState!.validate()) {
                                  // print("Issue via Email");
                                  // sendOTP(emailController.text);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IssuePage(
                                          rollNo: rollNo,
                                          location: location,
                                          name: name,
                                          issue_date: selectedIssueDate,
                                          return_date: selectedReturnDate,
                                          phone_no: phone_no,
                                        ),
                                      ));
                                  // }
                                },
                                text: 'Issue Device',
                                icon: Icons.email,
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
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

// class CardButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final IconData icon;

//   const CardButton({
//     required this.onPressed,
//     required this.text,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         onTap: onPressed,
//         title: Text(text),
//         leading: Icon(
//           icon,
//           color: Colors.blue, // Set icon color to blue
//         ),
//         trailing: Icon(Icons.arrow_forward_ios),
//       ),
//     );
//   }
// }

// // void writeCharacteristic(
// //     BluetoothDevice device, characteristicId, List<int> data) async {
// //   List<BluetoothService> services = await device.discoverServices();
// //   for (BluetoothService service in services) {
// //     for (BluetoothCharacteristic characteristic in service.characteristics) {
// //       if (characteristic.uuid == characteristicId) {
// //         await characteristic.write(data);
// //         print('Data written successfully.');
// //       }
// //     }
// //   }
// // }

// // 28:CD:C1:08:97:9C
// // 6e400003-b5a3-f393-e0a9-e50e24dcca9e

// //write
// //  serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, secondaryServiceUuid: null, characteristicUuid: 6e400002-b5a3-f393-e0a9-e50e24dcca9e

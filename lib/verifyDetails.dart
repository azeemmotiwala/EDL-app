import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/ip.dart';

import 'dart:math';

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

String generateRandomRequestId() {
  var random = Random();
  // Generate a random number between 1000 and 9999 (inclusive)
  int randomNumber = 1000 + random.nextInt(9000);
  return randomNumber.toString();
}

Future<void> addRequest(
  String deviceName,
  String rollNo,
  String email,
  String fm,
  String name,
  String phoneNo,
  String locationOfUse,
  String facultyStatus,
  String staffStatus,
  String adminStatus,
) async {
  // Define the API endpoint URL for adding a request
  final apiUrl = Uri.parse(ip + '/add-request/');

  // Create the payload for the request
  Map<String, dynamic> data = {
    'device_name': deviceName,
    'roll_no': rollNo,
    'email': email,
    'faculty_email': fm,
    'name': name,
    'phone_no': phoneNo,
    'location_of_use': locationOfUse,
    'faculty_status': facultyStatus,
    'staff_status': staffStatus,
    'admin_status': adminStatus,
  };

  // Encode the payload to JSON
  String body = json.encode(data);

  // Define the headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    // Send the HTTP POST request to add the request
    final response = await http.post(apiUrl, headers: headers, body: body);

    // Check the response status code
    if (response.statusCode == 200) {
      print('Request added successfully');
    } else if (response.statusCode == 404) {
      showSnack("Email not sent to Prof");
    } else if (response.statusCode == 403) {
      showSnack("Try again");
    } else {
      showSnack("Server error");
      print('Failed to add request: ${response.statusCode}');
    }
  } catch (error) {
    showSnack("Server error");

    print('Error adding request: $error');
  }
}

class VerifyDetailsPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String location;
  final String deviceName;
  final String facultyEmail;

  VerifyDetailsPage({
    required this.userData,
    required this.location,
    required this.deviceName,
    required this.facultyEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1.1 / 2,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetail('Email', userData['email']),
                  _buildDetail('Roll No', userData['roll_number']),
                  _buildDetail('Location of Use', location),
                  _buildDetail(
                    'Name',
                    userData['first_name'] + ' ' + userData['last_name'],
                  ),
                  _buildDetail(
                    'Phone No',
                    userData['contacts'][0]['number'],
                  ),
                  _buildDetail('Device Name', deviceName),
                  _buildDetail('Faculty Email', facultyEmail),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  addRequest(
                    deviceName,
                    userData['roll_number'],
                    userData['email'],
                    facultyEmail,
                    userData['first_name'] + ' ' + userData['last_name'],
                    userData['contacts'][0]['number'],
                    location,
                    "pending",
                    "pending",
                    "pending",
                  );

                  // Perform verification actions here
                  // For example, you can show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Verification Successful',
                        style: TextStyle(color: Colors.black),
                      ),
                      content:
                          Text('Your details have been verified successfully'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(context,
                                (Route<dynamic> route) => route.isFirst);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Verify and Request',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 3,
                  shadowColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.black87, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:math';

String generateRandomRequestId() {
  var random = Random();
  // Generate a random number between 1000 and 9999 (inclusive)
  int randomNumber = 1000 + random.nextInt(9000);
  return randomNumber.toString();
}


Future<void> addRequest(String deviceName, String rollNo, String email, String name, String phoneNo, String locationOfUse, String facultyStatus, String staffStatus, String adminStatus) async {
  // Define the API endpoint URL for adding a request
  final apiUrl = Uri.parse('http://192.168.0.125:8000/add-request/');

  // Create the payload for the request
  Map<String, dynamic> data = {
    'device_name': deviceName,
    'roll_no': rollNo,
    'email': email,
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
    } else {
      print('Failed to add request: ${response.statusCode}');
    }
  } catch (error) {
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
        title: Text('Verify Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard('Email', userData['email']),
            _buildCard('Roll No', userData['roll_number']),
            _buildCard('Location of Use', location),
            _buildCard('Name', userData['first_name'] + ' ' + userData['last_name']),
            _buildCard('Phone No', userData['contacts'][0]['number']),
            _buildCard('Device Name', deviceName),
            _buildCard('Faculty Email', facultyEmail),
            SizedBox(height: 20),
            
          ],
        ),
      ), 
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Perform verification actions here
          // For example, you can show a confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Verification Successful'),
              content: Text('Your details have been verified.'),
              actions: [
                TextButton(
                  onPressed: () {
                    addRequest(deviceName, userData['roll_number'], userData['email'], userData['first_name'] + ' ' + userData['last_name'], userData['contacts'][0]['number'], location, "pending", "pending", "pending");
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        label: Text('Verify and Request'),
        backgroundColor: Colors.blue[100],
        icon: Icon(Icons.verified),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      color: Colors.white, // Background color
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Title text color
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.black87), // Subtitle text color
        ),
      ),
    );
  }
}

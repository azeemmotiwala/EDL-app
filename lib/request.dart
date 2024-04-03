import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestPage extends StatefulWidget {
  final String rollNo;
  RequestPage({required this.rollNo});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<List<dynamic>> userRequests = [];

  @override
  void initState() {
    super.initState();
    getUserRequests(widget.rollNo).then((requests) {
      setState(() {
        userRequests = requests;
      });
    }).catchError((error) {
      print(error);
    });
  }

  Future<List<List<dynamic>>> getUserRequests(String rollNo) async {
    final apiUrl = Uri.parse('http://10.59.1.225:8000/requests/$rollNo');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        List<List<dynamic>> userRequests =
            List<List<dynamic>>.from(json.decode(response.body));
        return userRequests;
      } else {
        throw Exception('Failed to load user requests');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }

  String determineOverallStatus(List<dynamic> request) {

    bool hasRejected = request.contains('rejected');
    bool hasPending = request.contains('pending');
    bool allApproved = !hasPending && !hasRejected;
    if (allApproved) {
      return 'Approved';
    } else if (hasRejected) {
      return 'Rejected';
    } else {
      return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: userRequests.length,
        itemBuilder: (context, index) {
          final request = userRequests[index];
          final overallStatus = determineOverallStatus(request);

          Color statusColor = Colors.blue; // Default color
          if (overallStatus == 'Pending') {
            statusColor = Colors.red;
          } else if (overallStatus == 'Approved') {
            statusColor = Colors.green;
          }

          return ListTile(
            title: Text(
              request[1], // Index 1 represents the device name
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(request[0]), // Index 6 represents the location of use
            trailing: Chip(
              label: Text(
                overallStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              backgroundColor: statusColor.withOpacity(0.2),
            ),
          );
        },
      ),
    );
  }
}

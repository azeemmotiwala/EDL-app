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
    final apiUrl =
        Uri.parse('http://192.168.0.125:8000/get-requests/${rollNo}/');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        List<List<dynamic>> userRequests =
            List<List<dynamic>>.from(json.decode(response.body));
        print(userRequests);
        return userRequests;
      } else {
        throw Exception('Failed to load user requests');
      }
    } catch (error) {
      print(error);
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
        title: Text(
          'Requests',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: userRequests.length,
        itemBuilder: (context, index) {
          final request = userRequests[index];
          final overallStatus = determineOverallStatus(request);
          final requestId =
              request[0]; // Assuming index 0 represents the request ID

          Color statusColor = Colors.blue; // Default color
          IconData statusIcon = Icons.info_outline; // Default icon
          if (overallStatus == 'Pending') {
            statusColor = Colors.red;
            statusIcon = Icons.schedule;
          } else if (overallStatus == 'Approved') {
            statusColor = Colors.green;
            statusIcon = Icons.check_circle_outline;
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Perform action when status is clicked
                        // For example, navigate to a new screen or update status
                        print('Status clicked for request ID: $requestId');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                            size: 32,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Request ID: $requestId',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  request[
                                      1], // Index 1 represents the device name
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // SizedBox(height: 4),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Chip(
                            label: Text(
                              overallStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                                fontSize: 16,
                              ),
                            ),
                            backgroundColor: statusColor.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    ExpansionTile(
                      title: Text(
                        'More Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      children: [
                        SizedBox(
                          height: 30,
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  'Prof Stage Status: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Black color for text
                                  ),
                                ),
                                Text(
                                  '${request[8]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(request[
                                        8]), // Get color based on status
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  'Staff Stage Status: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Black color for text
                                  ),
                                ),
                                Text(
                                  '${request[9]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(request[
                                        9]), // Get color based on status
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  'Admin Stage Status: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Black color for text
                                  ),
                                ),
                                Text(
                                  '${request[10]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(request[
                                        10]), // Get color based on status
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Location of use: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black, // Black color for text
                                  ),
                                ),
                                TextSpan(
                                  text: request[6].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black, // Black color for text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.red; // Red color for "Pending" status
    case 'rejected':
      return Colors.blue; // Blue color for "Rejected" status
    case 'approved':
      return Colors.green; // Green color for "Approved" status
    default:
      return Colors.black; // Default color
  }
}

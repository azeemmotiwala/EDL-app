import 'dart:convert';

import 'package:edl_app/add.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/ip.dart';

class RequestPage extends StatefulWidget {
  final String rollNo;
  RequestPage({required this.rollNo});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<List<dynamic>> userRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserRequests(widget.rollNo).then((requests) {
      setState(() {
        userRequests = requests;
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      isLoading = false;
    });
  }

  Future<List<List<dynamic>>> getUserRequests(String rollNo) async {
    final apiUrl = Uri.parse(ip + '/get-requests/${rollNo}/');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        List<List<dynamic>> userRequests =
            List<List<dynamic>>.from(json.decode(response.body));
        print(userRequests);
        return userRequests;
      } else {
        showSnack("Server error");
        return [[]];
      }
    } catch (error) {
      print(error);
      showSnack("Server error");
      return [[]];
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userRequests.length,
              itemBuilder: (context, index) {
                final request = userRequests[index];
                final overallStatus = determineOverallStatus(request);
                final requestId = request[0];

                Color statusColor = Colors.blue;
                IconData statusIcon = Icons.info_outline;
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
                              print(
                                  'Status clicked for request ID: $requestId');
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        request[1],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${request[8]}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(request[8]),
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${request[9]}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(request[9]),
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${request[10]}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(request[10]),
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: request[7].toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
      return Colors.red;
    case 'rejected':
      return Colors.blue;
    case 'approved':
      return Colors.green;
    default:
      return Colors.black;
  }
}

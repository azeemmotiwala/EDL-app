import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogsPage extends StatefulWidget {
  final String rollNo;

  const LogsPage({required this.rollNo});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<dynamic> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.125:8000/logs/${widget.rollNo}'));
      if (response.statusCode == 200) {
        setState(() {
          logs = json.decode(response.body)['logs'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch logs');
      }
    } catch (e) {
      print('Error fetching logs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Logs Page',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? Center(
                  child: Text(
                    'No logs found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log ID: ${log[0]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Device Name: ${log[3]}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Issue Date: ${log[5]}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          _buildTextRow('Return Date', '${log[7]}'),
                          _buildTextRow('Return Deadline', '${log[6]}'),
                          _buildTextRow('Extended Deadline', '${log[8]}'),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildTextRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(subtitle),
        ],
      ),
    );
  }
}

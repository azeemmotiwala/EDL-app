import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {
  final String rollNo;

  const LogsPage({ required this.rollNo});
  
  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<dynamic> logs = [];

  @override
  void initState() {
    super.initState();
    // Fetch logs data when the page is initialized
    fetchLogs();
  }

Future<void> fetchLogs() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.125:8000/logs/${widget.rollNo}'));
      print(widget.rollNo);
      print("helo");
      if (response.statusCode == 200) {
        setState(() {
          logs = json.decode(response.body)['logs'];
        });
      } else {
        throw Exception('Failed to fetch logs');
      }
    } catch (e) {
      print('Error fetching logs: $e');
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
    body: ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Column(
          children: [
            ExpansionTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Log ID: ${log[0]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    Icon(
                      Icons.device_hub,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
              children: [
                _buildCard('Device Name', '${log[3]}'),
                _buildCard('Issue Date', '${log[5]}'),
                _buildCard('Return Date', '${log[7]}'),
                _buildCard('Return Deadline', '${log[6]}'),
                _buildCard('Extended Deadline', '${log[8]}'),
              ],
            ),
            Divider(color: Colors.blue[900], thickness: 2),
          ],
        );
      },
    ),
  );
}

Widget _buildCard(String title, String subtitle) {
  return Card(
    color: Colors.blue[50],
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.blue[900]),
      ),
    ),
  );
}
}
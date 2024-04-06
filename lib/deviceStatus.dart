import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeviceStatusPage extends StatefulWidget {
  @override
  _DeviceStatusPageState createState() => _DeviceStatusPageState();
}

class _DeviceStatusPageState extends State<DeviceStatusPage> {
  List<Map<String, dynamic>> uniqueDevices = [];

  @override
  void initState() {
    super.initState();
    getDeviceStatus();
  }

  Future<void> getDeviceStatus() async {
    final apiUrl = Uri.parse('http://192.168.0.125:8000/unique-devices/');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> devices = json.decode(response.body);
        setState(() {
          uniqueDevices = devices.map((device) {
            return {
              'device_name': device[0], // Extract device name
              'status': device[2] == 0 ? 'unavailable' : 'available', // Check availability
              'total_count': device[1], // Extract total count
              'available_count': device[2], // Extract available count
              'not_available_count': device[3], // Calculate not available count
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load device status');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to connect to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Status'),
      ),
      body: ListView.builder(
        itemCount: uniqueDevices.length,
        itemBuilder: (context, index) {
          final device = uniqueDevices[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(
                device['device_name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${device['status']}',
                    style: TextStyle(color: _getStatusColor(device['status'])),
                  ),
                  Text('Total Count: ${device['total_count']}'),
                  Text('Available Count: ${device['available_count']}'),
                  Text('Not Available Count: ${device['not_available_count']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'unavailable':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

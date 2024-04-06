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
              'status': device[2] == 0
                  ? 'Unavailable'
                  : 'Available', // Check availability
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
        title: Text(
          'Device Status',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set app bar background color
      ),
      body: ListView.builder(
        itemCount: uniqueDevices.length,
        itemBuilder: (context, index) {
          final device = uniqueDevices[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    device['device_name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Status', device['status']),
                        _buildInfoRow(
                            'Total Count', device['total_count'].toString()),
                        _buildInfoRow('Available Count',
                            device['available_count'].toString()),
                        _buildInfoRow('Not Available Count',
                            device['not_available_count'].toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    Color statusColor = value == 'Available' ? Colors.green : Colors.red;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: title == 'Status' ? statusColor : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

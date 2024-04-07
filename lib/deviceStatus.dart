import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/ip.dart';

class DeviceStatusPage extends StatefulWidget {
  @override
  _DeviceStatusPageState createState() => _DeviceStatusPageState();
}

class _DeviceStatusPageState extends State<DeviceStatusPage> {
  List<Map<String, dynamic>> uniqueDevices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDeviceStatus().then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getDeviceStatus() async {
    final apiUrl = Uri.parse(ip + '/unique-devices/');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> devices = json.decode(response.body);
        setState(() {
          uniqueDevices = devices.map((device) {
            return {
              'device_name': device[0],
              'status': device[2] == 0 ? 'Unavailable' : 'Available',
              'total_count': device[1],
              'available_count': device[2],
              'not_available_count': device[3],
            };
          }).toList();
        });
      } else {
        showSnack("Failed to load devices");
      }
    } catch (error) {
      print(error);
      showSnack('Failed to connect to the server');
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
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: uniqueDevices.length,
              itemBuilder: (context, index) {
                final device = uniqueDevices[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                              _buildInfoRow('Total Count',
                                  device['total_count'].toString()),
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

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

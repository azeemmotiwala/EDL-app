// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:edl_app/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/connection.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:edl_app/deviceprovider.dart';
import 'package:provider/provider.dart';

String startUrl = "http://192.168.43.144:8000";

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyscan =
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
  scaffoldMessengerKeyscan.currentState?.showSnackBar(snackbar);
}

class IssuePage extends StatelessWidget {
  final String rollNo;
  final String location;
  final String phone_no;
  final String name;
  final DateTime issue_date;
  final DateTime return_date;
  final String device;

  IssuePage(
      {required this.rollNo,
      required this.location,
      required this.phone_no,
      required this.name,
      required this.issue_date,
      required this.return_date,
      required this.device});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BleScanner(
        rollNo: rollNo,
        location: location,
        phone_no: phone_no,
        name: name,
        issue_date: issue_date,
        return_date: return_date,
        device: device,
      ),
    );
  }
}

class BleScanner extends StatefulWidget {
  final String rollNo;
  final String location;
  final String phone_no;
  final String name;
  final DateTime issue_date;
  final DateTime return_date;
  final String device;

  BleScanner(
      {required this.rollNo,
      required this.location,
      required this.phone_no,
      required this.name,
      required this.issue_date,
      required this.return_date,
      required this.device});

  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  List<BluetoothDevice> devices = [];
  List<String> readValues = [];
  bool check = true;
  late SharedPreferences _prefs;
  late bool isConnected = false;
  bool out = false;

  bool issued = false;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> issueDevice(
      String rollNo,
      String issueId,
      String deviceRfidId,
      String deviceName,
      String locationOfUse,
      DateTime issueDate,
      DateTime returnDeadline) async {
    final logsApiUrl = 'http://192.168.0.125:8000/logs/issue/';

    try {
      // Issue device by adding a new entry to logs
      final logsResponse = await http.post(
        Uri.parse(logsApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'roll_no': rollNo,
          'issue_id': issueId,
          'device_rfid_id': deviceRfidId,
          'device_name': deviceName,
          'location_of_use': locationOfUse,
          'issue_date': issueDate.toIso8601String(),
          'return_deadline': returnDeadline.toIso8601String(),
        }),
      );

      if (logsResponse.statusCode != 200) {
        print(
            'Failed to issue device. Logs status code: ${logsResponse.statusCode}');
        return;
      }
      print('Device issued successfully');
    } catch (e) {
      print('Error issuing device: $e');
    }
  }

  Future<void> updateDeviceStatus(String deviceRfidId, String newStatus) async {
    final devicesApiUrl =
        'http://192.168.0.125:8000/devices/${deviceRfidId}/status/${newStatus}/';

    try {
      // Update device status
      final devicesResponse = await http.put(
        Uri.parse(devicesApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, String>{
          'new_status': newStatus,
        }),
      );

      if (devicesResponse.statusCode != 200) {
        print(
            'Failed to update device status. Devices status code: ${devicesResponse.statusCode}');
        return;
      }

      print('Device status updated successfully');
    } catch (e) {
      print('Error updating device status: $e');
    }
  }

  Future<void> _initializeSharedPreferences() async {
    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    await _loadCommonVariable();

    if ((isConnected == true) && (devices.length != 0)) {
      await writeData(devices[0]);
      out = false;
      await readData(devices[0]);
    } else {
      showSnack("Device disconnected, connect again!");
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      context.read<DeviceProvider>().setDevices(devices);
    }

    // read

    // if (isConnected == false) {
    //   devices = [];
    //   startScanning();
    // }
    // Call _loadDevices after _prefs is initialized
  }

  Future<void> _loadCommonVariable() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isConnected =
          _prefs.getBool('isconnected') ?? false; // Default value if not found
    });
  }

  // Method to set the value of the common variable in shared preferences
  Future<void> _setCommonVariable(bool value) async {
    setState(() {
      isConnected = value;
    });
    await _prefs.setBool('isconnected', value);
  }

  Future<void> readData(BluetoothDevice device) async {
    try {
      List<BluetoothService> services =
          await device.discoverServices(timeout: 10000);
      services.forEach((service) async {
        var characteristics = service.characteristics;
        outerLoop:
        while (!out) {
          // print("hello");
          await Future.delayed(const Duration(seconds: 1));
          for (BluetoothCharacteristic c in characteristics) {
            if (c.properties.read) {
              while (!out) {
                try {
                  List<int> value = await c.read();
                  if (c.characteristicUuid.toString() ==
                      "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {
                    if (String.fromCharCodes(value) != "") {
                      print("went inside");
                      setState(() {
                        readValues.add(String.fromCharCodes(value));
                        issueDevice(
                            widget.rollNo,
                            "",
                            readValues[0],
                            widget.device,
                            widget.location,
                            widget.issue_date,
                            widget.return_date);
                        updateDeviceStatus(readValues[0], "Not Available");
                        issued = true;

                        out = true;
                      });
                      showSnack("Successfully Issued");

                      out = true;
                      break outerLoop;
                    }
                  }
                } catch (err) {
                  print("errrrrrrrrrrrr");
                  // Handle the error here
                  showSnack("Device disconnected, connect again!");
                  isConnected = false;
                  _setCommonVariable(false);
                  devices = [];
                  context.read<DeviceProvider>().setDevices(devices);
                  out = true;
                  break outerLoop;
                }
              }
            }
          }
        }
      });
    } catch (error) {
      print("errrrrrrrrrrrr");
      // Handle the error here
      showSnack("Device disconnected, connect again!");
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      context.read<DeviceProvider>().setDevices(devices);
    }
  }

  Future<void> writeData(BluetoothDevice device) async {
    try {
      final mtu = await device.mtu.first;
      print(mtu);
      // await device.requestMtu(512);
      // await device.requestMtu(100);
      List<BluetoothService> services = await device.discoverServices();
      // services.forEach((service) async {
      for (BluetoothService service in services) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.write) {
            final command = "issue";
            final convertedCommand = AsciiEncoder().convert(command);
            await c.write(convertedCommand);
            await Future.delayed(const Duration(seconds: 1));
            final command2 = "${widget.rollNo}";
            final convertedCommand2 = AsciiEncoder().convert(command2);
            await c.write(convertedCommand2);
            await Future.delayed(const Duration(seconds: 1));
            final command3 = "${widget.location}";
            final convertedCommand3 = AsciiEncoder().convert(command3);
            await c.write(convertedCommand3);
            await Future.delayed(const Duration(seconds: 1));
            final command4 =
                "${widget.issue_date.day}/${widget.issue_date.month}/${widget.issue_date.year}";
            final convertedCommand4 = AsciiEncoder().convert(command4);
            await c.write(convertedCommand4);
          }
        }
        // });
      }
    } catch (err) {
      // print("errrrrrrrrrrrr");
      // Handle the error here
      showSnack("Device disconnected, connect again!");
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      context.read<DeviceProvider>().setDevices(devices);
    }
  }

  void startScanning() async {
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            if (result.device.remoteId.toString() == "28:CD:C1:08:97:9C" &&
                check) {
              devices.add(result.device);
              check = false;
            }
          });
        }
      }
    });
    context.read<DeviceProvider>().setDevices(devices);
  }

  void connectReader(BluetoothDevice device) async {
    await device.connect();
    showSnack("Connected Succesfully");
    setState(() {
      isConnected = !isConnected;
      _setCommonVariable(isConnected);
    });
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    devices = deviceProvider.devices;

    return ScaffoldMessenger(
      key: scaffoldMessengerKeyscan,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Set background color to blue
          title: Text(
            'Issuing Page',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // ConnectionWidget(
            //   isConnected: isConnected,
            //   onConnectPressed: () {
            //     if (devices.length == 0) {
            //       print("not connected");
            //       showSnack("Try again");
            //     }
            //     else {
            //       if (isConnected == false) {
            //         connectReader(devices[0]);
            //       }
            //       else {
            //         devices[0].disconnect();
            //         setState(() {
            //           isConnected = !isConnected;
            //           _setCommonVariable(isConnected);
            //         });
            //         showSnack("Disconnected");
            //       }
            //     }
            //   },
            // ),
            SizedBox(height: 20),

            if (!issued)
              Center(
                child: Container(
                  width: 300, // Adjust width as needed
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 109, 163, 208),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bluetooth_searching,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Scan the Device...',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // ElevatedButton(
            //   onPressed: isConnected
            //       ? () async {
            //           if (devices.length != 0) {
            //             await writeData(devices[0]);
            //           } else {
            //             showSnack("Device disconnected, connect again!");
            //             isConnected = false;
            //             _setCommonVariable(false);
            //             devices = [];
            //             context.read<DeviceProvider>().setDevices(devices);
            //           }

            //           if (devices.length != 0) {
            //             out = false;
            //             await readData(devices[0]);
            //           } else {
            //             showSnack("Device disconnected, connect again!");
            //             isConnected = false;
            //             _setCommonVariable(false);
            //             devices = [];
            //             context.read<DeviceProvider>().setDevices(devices);
            //           }
            //         }
            //       : null,
            //   child: Text(
            //     'Issue Device',
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            // SizedBox(height: 20),

            // String deviceId,
            // String username,
            // String locationOfUse,
            // String phone_no,
            // String name,
            // DateTime issue_date,
            // DateTime return_date
            if (issued)
              Expanded(
                  child: ListView.builder(
                itemCount: 8, // Number of items
                itemBuilder: (context, index) {
                  // Use switch case to display different data based on index
                  switch (index) {
                    case 0:
                      return buildCard('Roll No:', widget.rollNo);
                    case 1:
                      return buildCard('Location:', widget.location);
                    case 2:
                      return buildCard('Name:', widget.name);
                    case 3:
                      return buildCard(
                        'Issue Date:',
                        '${widget.issue_date.year}-${widget.issue_date.month.toString().padLeft(2, '0')}-${widget.issue_date.day.toString().padLeft(2, '0')}',
                      );
                    case 4:
                      return buildCard(
                        'Return Date:',
                        '${widget.return_date.year}-${widget.return_date.month.toString().padLeft(2, '0')}-${widget.return_date.day.toString().padLeft(2, '0')}',
                      );
                    case 5:
                      return buildCard(
                        'Device Name:',
                        widget.device,
                      );
                    case 6:
                      return buildCard('Phone No:', widget.phone_no);
                    default:
                      return SizedBox(); // Return an empty SizedBox for safety
                  }
                },
              ))
          ],
        ),
      ),
    );
  }
}

Widget buildCard(String label, String value) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.lightBlueAccent),
          ),
          SizedBox(width: 25.0),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              // fontFamily: 'Roboto',
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}


// 28:CD:C1:08:97:9C
// 6e400003-b5a3-f393-e0a9-e50e24dcca9e

//write
//  serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, secondaryServiceUuid: null, characteristicUuid: 6e400002-b5a3-f393-e0a9-e50e24dcca9e

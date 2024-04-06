// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:edl_app/verification.dart';
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

class Return extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BleScanner(),
    );
  }
}

class BleScanner extends StatefulWidget {
  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  List<BluetoothDevice> devices = [];
  List<String> readValues = [];
  bool check = true;
  late SharedPreferences _prefs;
  late bool isConnected = false;
  // bool isConnected = false;
  bool out = false;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _returnDevice(DateTime.now(), "348108");
  }

  Future<void> _initializeSharedPreferences() async {
    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    await _loadCommonVariable();
    if (devices.length != 0) {
      await writeData(devices[0], "return\r");
    } else {
      showSnack("Device disconnected, connect again!");
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      context.read<DeviceProvider>().setDevices(devices);
    }

    if (devices.length != 0) {
      await readData(devices[0]);
    } else {
      showSnack("Device disconnected, connect again!");
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      context.read<DeviceProvider>().setDevices(devices);
    }
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

  Future<void> updateDeviceStatus(String deviceRfidId, String newStatus) async {
  final devicesApiUrl = 'http://192.168.0.125:8000/devices/${deviceRfidId}/status/${newStatus}/';

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
      print('Failed to update device status. Devices status code: ${devicesResponse.statusCode}');
      return;
    }
    print('Device status updated successfully');
  } catch (e) {
    print('Error updating device status: $e');
  }
}


  Future<void> _returnDevice(DateTime return_date, String rfidId) async {
    final apiUrl = Uri.parse('http://192.168.0.125:8000/logs/${rfidId}/return/${return_date.toIso8601String()}');
    // final returnDate = _returnDateController.text;
    try {
      final response = await http.put(
        apiUrl,
        // body: {'return_date': return_date.toIso8601String()},
      );
      if (response.statusCode == 200) { 
        
        updateDeviceStatus(rfidId, "Available");
        _getLogsByRfid(rfidId);

      } else {
      }
    } catch (error) {
    }
  }

  Future<void> _getLogsByRfid(String rfidId) async {
    
    try {
      final response = await http.get(Uri.parse('http://192.168.0.125:8000/logs/rfid/$rfidId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['logs']);
        print("'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

      } else if (response.statusCode == 404) {
      } else {
        throw Exception('Failed to fetch logs');
      }
    } catch (error) {
    } finally {
    }
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
                        out = true;
                        _returnDevice(DateTime.now(), readValues[0]);
                      });
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

  Future<void> writeData(BluetoothDevice device, String s) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.properties.write) {
            final command = s;
            final convertedCommand = AsciiEncoder().convert(command);
            await c.write(convertedCommand);
          }
        }
      }
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

  void startScanning() async {
    print("came for scanning==============================>");
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          // print("hello");
          // print("gll");
          setState(() {
            if (result.device.remoteId.toString() == "28:CD:C1:08:97:9C" &&
                check) {
              // print("hello");
              devices.add(result.device);

              check = false;
            }
          });
        }
      }
    });
    context.read<DeviceProvider>().setDevices(devices);

    // deviceProvider.setDevices(devices);
  }

  void connectReader(BluetoothDevice device) async {
    // Perform connection logic here
    // For simplicity, we toggle the connection state
    await device.connect();
    showSnack("Connected Succesfully");
    setState(() {
      isConnected = !isConnected;
      _setCommonVariable(isConnected);
    });
  }

  @override
  void dispose() {
    // FlutterBluePlus.stopScan();
    // writeData(devices[0], "stop return\r");
    out = true;
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
            'Return Page',
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
            //     } else {
            //       if (isConnected == false) {
            //         connectReader(devices[0]);
            //       } else {
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
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: isConnected
            //       ? () async {
            //           await writeData(devices[0]);
            //           await readData(devices[0]);
            //         }
            //       : null,
            //   child: Text(
            //     'Return device',
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: readValues.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4, // Add elevation for a shadow effect
                    margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16), // Add margin for spacing between cards
                    child: ListTile(
                      title: Text(
                        readValues[index],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold), // Customize text style
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors
                            .blue, // Set background color for the leading icon
                        child: Icon(Icons.check,
                            color: Colors
                                .white), // Set icon for the leading widget
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// 28:CD:C1:08:97:9C
// 6e400003-b5a3-f393-e0a9-e50e24dcca9e

//write
//  serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, secondaryServiceUuid: null, characteristicUuid: 6e400002-b5a3-f393-e0a9-e50e24dcca9e

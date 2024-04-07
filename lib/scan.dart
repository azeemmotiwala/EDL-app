// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/connection.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:edl_app/deviceprovider.dart';
import 'package:provider/provider.dart';
import 'package:edl_app/ip.dart';

String startUrl = ip;

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

class Scan extends StatelessWidget {
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
  bool out = false;
  bool showVerify = false;
  bool isempty = false;
  bool isVerified = false;
  // readValues.add("");
  @override
  void initState() {
    // readValues.add("210070093, Hostel - 6, 2024-04-01");
    // readValues.add("210070058");
    // readValues.add("h 6");
    // readValues.add("2024-12-01");
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    // await _setCommonVariable(true);
    await _loadCommonVariable();

    if ((devices.length != 0) || isConnected == true) {
      try {
        await writeData(devices[0], "scan\r");
        await readData(devices[0]);
      } catch (er) {
        showSnack("Device disconnected, connect again!");
      }
    } else {
      showSnack("Device disconnected, connect again!");
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      context.read<DeviceProvider>().setDevices(devices);
    }
    // Call _loadDevices after _prefs is initialized
  }

  Future<bool> verifyDevice(String rfidId) async {
    final apiUrl = Uri.parse(ip +
        '/devices/${rfidId}/${DateTime.now().toIso8601String()}/verified/verify/');
    try {
      final response = await http.put(apiUrl,
          // body: jsonEncode({
          //   'verify': 'verified', // Assuming 'verified' is the verification status
          //   'prv_verify_date': "2024-04-06T11:04:42.541Z", // Set current date as previous verification date
          // }),
          headers: {'Content-Type': 'application/json'} // Set request header
          );
      if (response.statusCode == 200) {
        // If the verification is successful, reload device statuss
        setState(() {
          isVerified = true;
        });
        showSnack("Verified Successfully");
        return true;
      } else if (response.statusCode == 404) {
        showSnack("Device not found");
        return false;
      } else {
        showSnack("Try again, not verified");
        return false;
        // throw Exception('Failed to verify device');
      }
    } catch (error) {
      showSnack("Server Error");
      print(error);
      return false;
      // throw Exception('Failed to connect to the server');
    }
  }

  Future<void> _loadCommonVariable() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isConnected = _prefs.getBool('isconnected') ?? false;
      print(isConnected); // Default value if not found
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
                        if (String.fromCharCodes(value).split(",").length ==
                            2) {
                          isempty = true;
                          print(String.fromCharCodes(value).split(",")[1]);
                          // showSnack("Scan ");
                        } else {
                          readValues = String.fromCharCodes(value).split(",");
                          showVerify = true;
                          showSnack("Scanned successfully");
                        }

                        out = true;
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
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            // if (result.device.remoteId.toString() == "28:CD:C1:08:97:9C" &&
            //     check) {
            devices.add(result.device);
            check = false;
            // }
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
    // FlutterBluePlus.stopScan();
    // print("disssssssssssssdissssss");
    out = true;
    // writeData(devices[0], "stop scan\r");
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
            'Scanning Page',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            if (!showVerify && !isempty)
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

            if (isempty)
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
                        Icons.info_outline,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tag is Empty...',
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

            if (showVerify && !isempty)
              ElevatedButton(
                onPressed: () {
                  verifyDevice(readValues[3]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isVerified)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Verified',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Icon(Icons.check_circle_rounded, color: Colors.green),
                        ],
                      ),
                    if (!isVerified)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verify",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          ])
                  ],
                ),
              ),

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
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: isConnected
            //       ? () async {
            //           await writeData(devices[0]);
            //           await readData(devices[0]);
            //         }
            //       : null,
            //   child: Text(
            //     'Scan RFID Tag',
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            // SizedBox(height: 20),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: readValues.length,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         elevation: 4, // Add elevation for a shadow effect
            //         margin: EdgeInsets.symmetric(
            //             vertical: 8,
            //             horizontal: 16), // Add margin for spacing between cards
            //         child: ListTile(
            //           title: Text(
            //             readValues[index],
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight:
            //                     FontWeight.bold), // Customize text style
            //           ),
            //           leading: CircleAvatar(
            //             backgroundColor: Colors
            //                 .blue, // Set background color for the leading icon
            //             child: Icon(Icons.check,
            //                 color: Colors
            //                     .white), // Set icon for the leading widget
            //           ),
            //           trailing: isVerified
            //               ? Icon(Icons.check, color: Colors.green)
            //               : null, // Show verified icon if isVerified is true
            //         ),
            //       );
            //     },
            //   ),
            // ),

            Expanded(
              child: ListView.builder(
                itemCount: readValues.length,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return buildCard('Roll No:', readValues[0]);
                    case 1:
                      return buildCard('Location:', readValues[1]);
                    case 2:
                      return buildCard('Issue Date:', readValues[2]);
                    case 3:
                      return buildCard('RFID:', readValues[3]);

                    default:
                      return SizedBox(); // Return an empty SizedBox for safety
                  }
                },
              ),
            )
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
          SizedBox(width: 8.0),
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


// void writeCharacteristic(
//     BluetoothDevice device, characteristicId, List<int> data) async {
//   List<BluetoothService> services = await device.discoverServices();
//   for (BluetoothService service in services) {
//     for (BluetoothCharacteristic characteristic in service.characteristics) {
//       if (characteristic.uuid == characteristicId) {
//         await characteristic.write(data);
//         print('Data written successfully.');
//       }
//     }
//   }
// }

// 28:CD:C1:08:97:9C
// 6e400003-b5a3-f393-e0a9-e50e24dcca9e

//write
//  serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, secondaryServiceUuid: null, characteristicUuid: 6e400002-b5a3-f393-e0a9-e50e24dcca9e

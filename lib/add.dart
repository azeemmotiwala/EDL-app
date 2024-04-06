// // // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // // All rights reserved. Use of this source code is governed by a
// // // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:edl_app/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:edl_app/connection.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:edl_app/deviceprovider.dart';
import 'package:provider/provider.dart';

String startUrl = "http://192.168.0.125:8000";

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyscan =
    GlobalKey<ScaffoldMessengerState>();

final TextEditingController devicenameController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController serialnoController = TextEditingController();

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

class Add extends StatelessWidget {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool out = false;

  Future<void> addDevice(String deviceId, String deviceName, String serialNo,
      String original_location, String description) async {
    readValues = [];
    final url = Uri.parse('${startUrl}/devices/');

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    Map<String, dynamic> body = {
      "serial_number": serialNo,
      "rfid_id": deviceId,
      "device_name": deviceName,
      'original_location': original_location,
      'status': "Available",
      'description': description,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        print('Device information added successfully');
        showSnack("Device Added Successfully");
        setState(() {
          serialnoController.clear();
          devicenameController.clear();
          locationController.clear();
          descriptionController.clear();
        });
      } else {
        print('Failed to add device information: ${response.reasonPhrase}');
        showSnack("Failed to Add, try again");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    serialnoController.clear();
    devicenameController.clear();
    locationController.clear();
    descriptionController.clear();
    _initializeSharedPreferences();
    // addDevice("128376", "SMD", "1837187", "WEL-4", "Working Device");
  }

  Future<void> _initializeSharedPreferences() async {
    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    await _loadCommonVariable();
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
                        addDevice(
                            readValues[0],
                            devicenameController.text,
                            serialnoController.text,
                            locationController.text,
                            descriptionController.text);
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
    // FlutterBluePlus.stopScan();
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
            'Adding Device Page',
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
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Serial No:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: serialnoController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter device serial no.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Serial No',
                            prefixIcon: Icon(Icons.numbers_outlined),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Device Name:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: devicenameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter device name';
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Device Name',
                            prefixIcon: Icon(Icons.device_hub),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Device Location:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: serialnoController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter device location';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Device Location',
                            prefixIcon: Icon(Icons.location_pin),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: serialnoController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter device description';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Device Description',
                            prefixIcon: Icon(
                              Icons.info_rounded,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isConnected
                  ? () async {
                      // Simulating a Bluetooth device
                      if (devices.length != 0) {
                        await writeData(devices[0], "add\r");
                        out = false;
                        await readData(devices[0]);
                      } else {
                        showSnack("Device disconnected, connect again!");
                        isConnected = false;
                        _setCommonVariable(false);
                        devices = [];
                        context.read<DeviceProvider>().setDevices(devices);
                      }
                    }
                  : null,
              child: Text(
                'Scan the device',
                style: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 20),
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
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const CardButton({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

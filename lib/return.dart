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

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    await _loadCommonVariable();
    if (isConnected == false) {
      devices = [];
      startScanning();
    }
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

  Future<void> updateDeviceInfo(String deviceId, String username, String locationOfUse) async {

    readValues = [];
    final url = Uri.parse('${startUrl}/devices/$deviceId/');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, String> body = {
      "device_id": "",
      "device_name": "",
      'username': username,
      'location_of_use': locationOfUse,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showSnack("Return Successful");
        print('Device information updated successfully');
      } else {
        showSnack("Fail to return, try again");
        print('Failed to update device information: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> readData(BluetoothDevice device) async {
    bool out = false;
    List<BluetoothService> services =
        await device.discoverServices(timeout: 10000);
    services.forEach((service) async {
      var characteristics = service.characteristics;
      while (!out) {
        // print("hello");
        await Future.delayed(const Duration(seconds: 1));
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.read) {
            while (true) {
              List<int> value = await c.read();
              if (c.characteristicUuid.toString() ==
                  "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {
                if (String.fromCharCodes(value) != "") {
                  print("went inside");
                  setState(() {
                    // print()
                    readValues.add(String.fromCharCodes(value));
                    updateDeviceInfo(readValues[0], "", "");
                    print(readValues.length);
                    out = true;
                  });
                  break;
                }
              }
            }
          }
        }
      }
    });
  }

  Future<void> writeData(BluetoothDevice device) async {
    // List<String> tempReadValues = [];
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          final command = "return\r";
          final convertedCommand = AsciiEncoder().convert(command);
          await c.write(convertedCommand);
        }
      }
    });
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
          'Return Page',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
      ),                      
      body: Column(
          children: [
            ConnectionWidget(
              isConnected: isConnected,
              onConnectPressed: () {
                if (devices.length == 0) {
                  print("not connected");
                  showSnack("Try again");
                } else {
                  if (isConnected == false) {
                    connectReader(devices[0]);
                  } else {
                    devices[0].disconnect();
                    setState(() {
                      isConnected = !isConnected;
                      _setCommonVariable(isConnected);
                    });
                    showSnack("Disconnected");
                  }
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected
                  ? () async {
                      await writeData(devices[0]);
                      await readData(devices[0]);
                    }
                  : null,
              child: Text(
                'Return device',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: readValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(readValues[index]),
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

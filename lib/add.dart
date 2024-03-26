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

String startUrl = "http://192.168.43.144:8000";

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyscan =
    GlobalKey<ScaffoldMessengerState>();

final TextEditingController devicenameController = TextEditingController();


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

Future<void> addDevice(String deviceId, String deviceName) async {

  readValues = [];
  final url = Uri.parse('${startUrl}/devices/');

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> body = {
    "device_id": deviceId,
    "device_name": deviceName,
    'username': "",
    'location_of_use': "",
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
    } 
    else {
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

  Future<void> writeData(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          final command = "add\r";
          final convertedCommand = AsciiEncoder().convert(command);
          await c.write(convertedCommand);
        }
      }
    });
  }


  Future<void> readData(BluetoothDevice device) async {
    bool out = false;
    List<BluetoothService> services = await device.discoverServices(timeout: 10000);
    services.forEach((service) async {
      var characteristics = service.characteristics;
      while (!out) {
        await Future.delayed(const Duration(seconds: 1));
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.read) {
            while (true) {
              List<int> value = await c.read();
              if (c.characteristicUuid.toString() == "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {
                if (String.fromCharCodes(value) != "") {
                  setState(() {
                    readValues.add(String.fromCharCodes(value));
                    addDevice(readValues[0], devicenameController.text);
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
          'Adding Device Page',
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
                  showSnack("Try again");
                } 
                else {
                  if (isConnected == false) {
                    connectReader(devices[0]);
                  } 
                  else {
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
                      await writeData(devices[0]);
                      await readData(devices[0]);
                    }
                  : null,
              child: Text(
                'Scan the device tag',
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
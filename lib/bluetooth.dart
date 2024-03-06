// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
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
  scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
}

class Bluetooth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BleScanner(),
    );
  }
}

class ConnectionWidget extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onConnectPressed;

  ConnectionWidget({required this.isConnected, required this.onConnectPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //   colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
      // ),

      //   gradient: LinearGradient(
      //     colors: [
      //       Color.fromARGB(255, 192, 157, 157),
      //       Color.fromARGB(255, 229, 226, 223)
      //     ],
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isConnected ? 'Connected to Reader' : 'Not Connected    ',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onConnectPressed,
                child: Text(
                  isConnected ? 'Disconnect' : 'Connect',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BleScanner extends StatefulWidget {
  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  // BluetoothDevice test =
  // int index = 0;
  bool check = true;
  @override
  void initState() {
    super.initState();
    startScanning();
  }

  List<String> readValues = [];

  Future<void> readData(BluetoothDevice device) async {
    // List<String> tempReadValues = [];
    bool out = false;
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      while (!out) {
        print("hello");
        await Future.delayed(const Duration(seconds: 1));
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.read) {
            // while (true) {
            List<int> value = await c.read();
            if (c.characteristicUuid.toString() ==
                "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {
              if (String.fromCharCodes(value) != "") {
                print("went inside");
                setState(() {
                  // print()
                  readValues.add(String.fromCharCodes(value));
                  print(readValues.length);
                });
                out = true;
                break;
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
          final command = "scan\r";
          final convertedCommand = AsciiEncoder().convert(command);
          await c.write(convertedCommand);
        }
      }
    });
  }

  void startScanning() async {
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
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
  }

  bool isConnected = false;

  void connectReader(BluetoothDevice device) async {
    // Perform connection logic here
    // For simplicity, we toggle the connection state
    await device.connect();
    showSnack("Connected Succesfully");
    setState(() {
      isConnected = !isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            height: MediaQuery.of(context).size.height / 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
              ),
            ),
          ),
          centerTitle: true,
          title: Text("Scanning Page"),
          elevation: 0.0,
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
                      // Simulating a Bluetooth device
                      await writeData(devices[0]);
                      await readData(devices[0]);
                    }
                  : null,
              child: Text(
                'Scan RFID Tag',
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

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
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

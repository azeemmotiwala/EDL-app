// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart';
import 'package:edl_app/connection.dart';

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
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    startScanning();
  }


  Future<void> readData(BluetoothDevice device) async {
    bool out = false;
    List<BluetoothService> services = await device.discoverServices(timeout: 10000);
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
                  print(readValues.length);
                  out = true;
                });
                break;
              }
            }
          }
        }
      }
    }});
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
  }

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
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKeyscan,
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
          title: Text("Return Page"),
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

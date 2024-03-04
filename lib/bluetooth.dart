// // Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// // All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Bluetooth extends StatelessWidget {
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

  void startScanning() async {
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            if (result.device.remoteId.toString() == "28:CD:C1:08:97:9C" &&
                check) {
              print("hello");
              devices.add(result.device);
              check = false;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: ElevatedButton(
        child: Text("Connect"),
        onPressed: () {
          if (devices.length == 0) {
            print("Not Connected");
          } else {
            connectToDevice(devices[0]);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}

Future<void> connectToDevice(BluetoothDevice device) async {
  await device.connect();
  // Once connected, you can perform operations on the device.
  // readCharacteristic(device, Guid("0000180f-0000-1000-8000-00805f9b34fb"));
  List<BluetoothService> services = await device.discoverServices();
  services.forEach((service) async {
    // do something with service
    var characteristics = service.characteristics;
    int i = 0;
    for (BluetoothCharacteristic c in characteristics) {
      i++;
      if (c.properties.read) {
        // while (true) {
        List<int> value = await c.read();
        if (c.characteristicUuid.toString() ==
            "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {
          print(String.fromCharCodes(value));
        }
      }
      if (c.properties.write) {
        final command = "Teri amdlllrjlrwngjlrwnglnwrlgknrwlkgnwrklglkerglk\r";
        final convertedCommand = AsciiEncoder().convert(command);
        await c.write(convertedCommand);
      }
    }
  });
}

// void connectToDevice(BluetoothDevice device) async {
//   await device.connect();

//   List<BluetoothService> services = await device.discoverServices();

//   for (BluetoothService service in services) {
//     for (BluetoothCharacteristic characteristic in service.characteristics) {
//       var value = await characteristic.read();
//       print(  );
//       // print(AsciiDecoder().convert(value)); /*** TAG-1***/
//       // print(utf8.decode(value)); /*** TAG-2***/
//       // if (characteristic.properties.write) {
//       //   if (characteristic.properties.notify) {
//       //     _rx_Write_Characteristic = characteristic;
//       //     _sendCommandToDevice();
//       //   }
//       // }
//     }
//   }
// }

void writeCharacteristic(
    BluetoothDevice device, characteristicId, List<int> data) async {
  List<BluetoothService> services = await device.discoverServices();
  for (BluetoothService service in services) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.uuid == characteristicId) {
        await characteristic.write(data);
        print('Data written successfully.');
      }
    }
  }
}

// 28:CD:C1:08:97:9C
// 6e400003-b5a3-f393-e0a9-e50e24dcca9e

//write
//  serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, secondaryServiceUuid: null, characteristicUuid: 6e400002-b5a3-f393-e0a9-e50e24dcca9e

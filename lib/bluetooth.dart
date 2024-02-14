// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> devices = [];

  // @override
  void initState() {
    super.initState();
    print("init state");
    startScanning();
  }

  void startScanning() async {
    print("waiting for scan");
    FlutterBluePlus.startScan();
    print("done with scan");
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            devices.add(result.device);
            print(result.device);
          });
        }
      }
    });
    print("now exit");
  }

  @override
  Widget build(BuildContext context) {
    print("in build");
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            // ignore: deprecated_member_use
            title: Text(devices[index].platformName),
            subtitle: Text(devices[index].remoteId.toString()),
          );
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

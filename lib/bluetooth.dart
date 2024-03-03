import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScanner extends StatefulWidget {
  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() async {
    print("Started Scanning");
    await FlutterBluePlus.startScan();
    print("Device Detected");
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
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

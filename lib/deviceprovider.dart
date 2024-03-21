import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceProvider extends ChangeNotifier {
  List<BluetoothDevice> _devices = [];

  List<BluetoothDevice> get devices => _devices;

  void setDevices(List<BluetoothDevice> devices) {
    _devices = devices;
    notifyListeners();
  }
}

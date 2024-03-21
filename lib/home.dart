import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:provider/provider.dart';
import 'package:edl_app/deviceprovider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // bool isConnected = false;

  late SharedPreferences _prefs;
  bool isConnected = false;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();

    _initializeSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);
      // Inside your method where you get the list of devices
      deviceProvider.setDevices(devices);
    });
  }

  Future<void> _initializeSharedPreferences() async {
    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    // _loadCommonVariable();
    _setCommonVariable(false);
    // Call _loadDevices after _prefs is initialized
  }

  // Method to load the common variable from shared preferences
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

  //  Future<void> _loadDevices() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   final devicesJson = _prefs.getStringList('bluetoothDevices');
  //   if (devicesJson != null) {
  //     setState(() {
  //       devices = devicesJson.map((json) => BluetoothDevice.fromJson(json)).toList();
  //     });
  //   }
  // }

  // // Method to save the list of devices to shared preferences
  // Future<void> _saveDevices() async {
  //   final devicesJson = devices.map((device) => device.toJson()).toList();
  //   await _prefs.setStringList('bluetoothDevices', devicesJson);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          flexibleSpace: Container(
            height: MediaQuery.of(context).size.height / 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
              ),
              // color: Colors.p,
            ),
          ),
          centerTitle: true,
          title: Text("Dashboard"),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 3 / 8,
              decoration: BoxDecoration(
                // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
                image: DecorationImage(
                    image: AssetImage('assets/photo1.png'), fit: BoxFit.fill),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(
                      //   // primary: Colors.red[700], // background color
                      //   // onPrimary: Colors.white, // text color
                      // ),
                      child: Text("Scan"),
                      onPressed: () {
                        // _setCommonVariable(true);
                        Navigator.pushNamed(context, '/scan');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(
                      //   primary: Colors.red[500], // background color
                      //   onPrimary: Colors.white, // text color
                      // ),
                      child: Text("Issue"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/issue');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(
                      //   primary: Colors.red[300], // background color
                      //   onPrimary: Colors.white, // text color
                      // ),
                      child: Text("Return"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/return');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

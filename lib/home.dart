import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:provider/provider.dart';
import 'package:edl_app/deviceprovider.dart';
import 'package:edl_app/connection.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Home({Key? key, required this.userData}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

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

class _HomeState extends State<Home> {
  late SharedPreferences _prefs;
  bool isConnected = false;
  List<BluetoothDevice> devices = [];
  List<String> readValues = [];

  bool check = true;

  @override
  void initState() {
    print("came again");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);
      // Inside your method where you get the list of devices
      deviceProvider.setDevices(devices);
    });
    _initializeSharedPreferences();
    // ignore: deprecated_member_use
  }

  Future<void> _initializeSharedPreferences() async {
    // ignore: deprecated_member_use

    await FlutterBluePlus.turnOn();
    _prefs = await SharedPreferences.getInstance();
    // _loadCommonVariable();
    print("tttttttttttt");
    await _setCommonVariable(false);
    await _loadCommonVariable();

    // if (isConnected == false) {
    // print(isConnected);
    // print("wewewewe");
    devices = [];
    startScanning();

    // }
  }

  Future<bool> _onPop() async {
    // Perform actions you want when navigating back to the home page
    print("Navigated back to home page");
    await _loadCommonVariable();
    // ignore: deprecated_member_use
    if ((isConnected == false) ||
        // ignore: deprecated_member_use
        (devices[0].state != BluetoothDeviceState.connected)) {
      // print(devices);
      isConnected = false;
      _setCommonVariable(false);
      devices = [];
      check = true;
      startScanning();
    }
    return true; // Return true to allow popping the route
  }

  void startScanning() async {
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          print(result);
          if (result.device.remoteId.toString() == "28:CD:C1:08:97:9C" &&
              check) {
            setState(() {
              devices.add(result.device);
              check = false;
              FlutterBluePlus.stopScan();

              // }
            });
            break;
          }
        }
      }
    });
    context.read<DeviceProvider>().setDevices(devices);
  }

  // Method to load the common variable from shared preferences
  Future<void> _loadCommonVariable() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isConnected = _prefs.getBool('isconnected') ?? false;
      print(isConnected);
      print("ininin"); // Default value if not found
    });
  }

  // Method to set the value of the common variable in shared preferences
  Future<void> _setCommonVariable(bool value) async {
    setState(() {
      isConnected = value;
    });
    await _prefs.setBool('isconnected', value);
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
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    devices = deviceProvider.devices;
    return ScaffoldMessenger(
        key: scaffoldMessengerKeyscan,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue, // Set background color to blue
            title: Text(
              'Dashboard',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            centerTitle: true,
          ),
          drawer: SideBar(
            userData: widget.userData,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/WEL-logo.png'),
              ),
              ConnectionWidget(
                isConnected: isConnected,
                onConnectPressed: () {
                  print(isConnected);
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
                        devices = [];
                        startScanning();
                      });
                      showSnack("Disconnected");
                    }
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          print("11111111111111");
                          if (isConnected == true) {
                            // FlutterBluePlus.stopScan();
                            // ignore: deprecated_member_use
                            // Navigator.popAndPushNamed(context, '/scan');
                            Navigator.of(context)
                                .pushNamed('/scan')
                                .then((value) {
                              print(devices);
                              _onPop();
                            });
                          } else {
                            showSnack("Not Connected");
                          }
                        } else if (index == 1) {
                          if (isConnected == true) {
                            // FlutterBluePlus.stopScan();

                            // Navigator.pushNamed(context, '/issue');
                            Navigator.of(context)
                                .pushNamed('/issue')
                                .then((value) {
                              print(devices);
                              _onPop();
                            });
                          } else {
                            showSnack("Not Connected");
                          }
                        } else if (index == 2) {
                          if (isConnected == true) {
                            // Navigator.pushNamed(context, '/return');
                            // FlutterBluePlus.stopScan();

                            Navigator.of(context)
                                .pushNamed('/return')
                                .then((value) {
                              _onPop();
                            });
                          } else {
                            showSnack("Not Connected");
                          }
                        } else if (index == 3) {
                          if (isConnected == false) {
                            // Navigator.pushNamed(context, '/add');
                            Navigator.of(context)
                                .pushNamed('/add')
                                .then((value) {
                              _onPop();
                            });
                          } else {
                            showSnack("Not Connected");
                          }
                        } else if (index == 4) {
                          FlutterBluePlus.stopScan();
                          // Navigator.pushNamed(context, '/update');
                          Navigator.of(context)
                              .pushNamed('/discard')
                              .then((value) {
                            _onPop();
                          });
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              _buildIcon(index),
                              SizedBox(width: 20),
                              Text(
                                _getTitle(index),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.qr_code;
      case 1:
        return Icons.assignment;
      case 2:
        return Icons.arrow_back;
      case 3:
        return Icons.add;
      case 4:
        return Icons.remove;
      default:
        return Icons.error;
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Scan';
      case 1:
        return 'Issue';
      case 2:
        return 'Return';
      case 3:
        return 'Add/ Update';
      case 4:
        return 'Discard';
      default:
        return 'Unknown';
    }
  }

  Widget _buildIcon(int index) {
    return Icon(
      _getIcon(index),
      size: 40,
      color: Colors.blue,
    );
  }
}

//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: SideBar(),
//         appBar: AppBar(
//           flexibleSpace: Container(
//             height: MediaQuery.of(context).size.height / 8,
//             color: Colors.red[900],
//             // decoration: const BoxDecoration(
//             //   // gradient: LinearGradient(
//             //   //   colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
//             //   // ),
//             //   // color: Colors.p,
//             // ),
//           ),
//           centerTitle: true,
//           title: Text("Dashboard"),
//           elevation: 0.0,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 3 / 8,
//                 decoration: BoxDecoration(
//                   // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
//                   image: DecorationImage(
//                       image: AssetImage('assets/photo1.png'), fit: BoxFit.fill),
//                 ),
//               ),
//               Column(
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 1.5,
//                       height: MediaQuery.of(context).size.height / 10,
//                       child: ElevatedButton(
//                         // style: ElevatedButton.styleFrom(
//                         //   // primary: Colors.red[700], // background color
//                         //   // onPrimary: Colors.white, // text color
//                         // ),
//                         child: Text("Scan"),
//                         onPressed: () {
//                           // _setCommonVariable(true);
//                           Navigator.pushNamed(context, '/scan');
//                         },
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 1.5,
//                       height: MediaQuery.of(context).size.height / 10,
//                       child: ElevatedButton(
//                         // style: ElevatedButton.styleFrom(
//                         //   primary: Colors.red[500], // background color
//                         //   onPrimary: Colors.white, // text color
//                         // ),
//                         child: Text("Issue"),
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/issue');
//                         },
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 1.5,
//                       height: MediaQuery.of(context).size.height / 10,
//                       child: ElevatedButton(
//                         // style: ElevatedButton.styleFrom(
//                         //   primary: Colors.red[300], // background color
//                         //   onPrimary: Colors.white, // text color
//                         // ),
//                         child: Text("Return"),
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/return');
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
// }

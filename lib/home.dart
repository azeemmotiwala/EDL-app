import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:provider/provider.dart';
import 'package:edl_app/deviceprovider.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.blue, // Set background color to blue
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
      ),      
      drawer: SideBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/WEL-logo.png'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.pushNamed(context, '/scan');
                    } else if (index == 1) {
                      Navigator.pushNamed(context, '/issue');
                    } else if (index == 2) {
                      Navigator.pushNamed(context, '/return');
                    } else if (index == 3) {
                      Navigator.pushNamed(context, '/add');
                    } else if (index == 4) {
                      Navigator.pushNamed(context, '/update');
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
    );
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
        return Icons.update;
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
        return 'Add';
      case 4:
        return 'Update';
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

// import 'package:edl_app/login.dart';
// import 'package:flutter/material.dart';

// class SideBar extends StatefulWidget {
//   const SideBar({super.key});

//   @override
//   State<SideBar> createState() => _SideBarState();
// }

// class _SideBarState extends State<SideBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text('Azeem Motiwala'),
//             accountEmail: Text('motiwalaazeem@gmail.com'),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.share),
//             title: Text('Share'),
//             onTap: () => null,
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('Request'),
//             onTap: () => null,
//             trailing: ClipOval(
//               child: Container(
//                 color: Colors.red,
//                 width: 20,
//                 height: 20,
//                 child: Center(
//                   child: Text(
//                     '8',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('Settings'),
//             onTap: () => null,
//           ),
//           Divider(),
//           ListTile(
//             title: Text('Log Out'),
//             leading: Icon(Icons.logout),
//             onTap: (){

//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edl_app/deviceStatus.dart';
import 'package:edl_app/login.dart';
import 'package:edl_app/logs.dart'; // Import the LogsPage
import 'package:edl_app/request.dart';
import 'package:flutter/material.dart';

class SideBarAdmin extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SideBarAdmin({Key? key, required this.userData}) : super(key: key);

  @override
  State<SideBarAdmin> createState() => _SideBarState();
}

class _SideBarState extends State<SideBarAdmin> {
  late String name;
  late String rollNumber;
  late String email;

  @override
  void initState() {
    super.initState();
    // Extract user data from widget.userData
    name = widget.userData['first_name'] ?? '';
    String lastName = widget.userData['last_name'] ?? '';
    rollNumber = widget.userData['roll_number'] ?? '';
    email = widget.userData['email'] ?? '';
    if (lastName.isNotEmpty) {
      name += ' $lastName';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              name,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/back.jpeg')),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.logout),
            onTap: () async {
              // Clear shared preferences data
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              // await prefs.remove('accessToken');
              await prefs.remove('userData');
              await prefs.remove("isprof");

              // Navigate back to the login page
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

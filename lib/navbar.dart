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

import 'package:edl_app/request.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SideBar({Key? key, required this.userData}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
            accountName: Text(name),
            accountEmail: Text(email),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestPage(rollNo: rollNumber),
                ),
              );
            },
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.logout),
            onTap: (){
              // Add logout functionality here
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

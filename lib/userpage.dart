// import 'package:flutter/material.dart';
// import 'package:edl_app/navbar.dart';

// class UserPage extends StatefulWidget {
  
//   final Map<String, dynamic> userData;
//   const UserPage({Key? key, required this.userData}) : super(key: key);


//   @override
//   State<UserPage> createState() => _UserState();
// }

// class _UserState extends State<UserPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text(
//           'Dashboard',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       drawer: SideBar(
//         userData: widget.userData,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Image.asset('assets/WEL-logo.png'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 2,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (index == 0) {
//                       Navigator.pushNamed(context, '/scan');
//                     } else if (index == 1) {
//                       Navigator.pushNamed(context, '/issue');
//                     } 
//                   },
//                   child: Card(
//                     margin: EdgeInsets.all(10),
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Row(
//                         children: [
//                           _buildIcon(index),
//                           SizedBox(width: 20),
//                           Text(
//                             _getTitle(index),
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getIcon(int index) {
//     switch (index) {
//       case 0:
//         return Icons.assignment;
//       case 1:
//         return Icons.extension;
//       default:
//         return Icons.error;
//     }
//   }

//   String _getTitle(int index) {
//     switch (index) {
//       case 0:
//         return 'Issue';
//       case 1:
//         return 'Extend';
//       default:
//         return 'Unknown';
//     }
//   }

//   Widget _buildIcon(int index) {
//     return Icon(
//       _getIcon(index),
//       size: 40,
//       color: Colors.blue,
//     );
//   }
// }


import 'package:edl_app/issueRequest.dart';
import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';
import 'package:edl_app/request.dart'; // Import the RequestPage

class UserPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserPage> createState() => _UserState();
}

class _UserState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
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
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      // Navigate to the RequestPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IssueUser(userData: widget.userData,),

                        ),
                      );
                    } else if (index == 1) {
                      Navigator.pushNamed(context, '/issue');
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
        return Icons.assignment;
      case 1:
        return Icons.extension;
      default:
        return Icons.error;
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Issue';
      case 1:
        return 'Extend';
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

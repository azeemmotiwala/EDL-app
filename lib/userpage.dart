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


import 'dart:convert';

import 'package:edl_app/issueRequest.dart';
import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';
import 'package:edl_app/request.dart'; // Import the RequestPage
import 'package:http/http.dart' as http;
import 'package:edl_app/ip.dart';

Future<bool> checkUserExistence(String rollNumber) async {
  final String apiUrl = ip1 + '/users/exists/$rollNumber'; // Replace this with your API endpoint

  try {
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['exists'];
    } else {
      print('Failed to check user existence: ${response.body}');
      return false;
    }
  } catch (error) {
    print('Error checking user existence: $error');
    return false;
  }
}
  

Future<void> createUserIfNotExists(Map<String, dynamic> user) async {
  final String rollNumber = user['roll_number'];
  bool userExists = await checkUserExistence(rollNumber);

  if (!userExists) {
    final String apiUrl = ip1 + '/users/'; // Replace this with your API endpoint
    
    // Convert user object to JSON
    final Map<String, dynamic> userData = {
      'roll_no': user['roll_number'],
      'name': user['first_name'] + ' ' + user['last_name'],
      'email': user['email'],
      'department': user['program']['department'],
      'degree': user['program']['degree'],
      'year_of_study': user['program']['join_year'].toString(),
      'phone_no': user['contacts'][0]['number'].toString()
    };
    print(userData);
    print("=========");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // User created successfully
        print('User created successfully');
      } else {
        // Error creating user
        print('Failed to create user: ${response.body}');
      }
    } catch (error) {
      print('Error creating user: $error');
    }
  } else {
    print('User already exists');
  }
}

class UserPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserPage> createState() => _UserState();
}

class _UserState extends State<UserPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createUserIfNotExists(widget.userData);
  }
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
              itemCount: 1,
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
      default:
        return Icons.error;
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Issue';
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

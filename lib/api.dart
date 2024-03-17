import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

String startUrl = "http://192.168.43.144:8000";

Future<bool> checkUsername(String username) async {
  final response = await http
      .get(Uri.parse('${startUrl}/check-username/${username}'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data['exists'];
  } else {
    throw Exception('Failed to load username');
  }
}

Future<bool> checkPassword(String password) async {
  final response = await http
      .get(Uri.parse('${startUrl}/check-password/${password}'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data['exists'];
  } else {
    throw Exception('Failed to load password');
  }
}

void addUser(data) async {
  try {
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    }; // Add headers if needed
    final response = await http.post(Uri.parse("${startUrl}/userinfo/"), headers: headers, body: json.encode(data));
    // Handle the response
    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


Future<bool> checkUserCredentials(String username, String password) async {
  final url = Uri.parse('${startUrl}/check-user-credentials/?username=${username}&password=${password}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['authenticated'];
    } else {
      throw Exception('Failed to load credentials');
    }
}


Future<bool> checkInstructorCredentials(String username, String password) async {
  final url = Uri.parse('${startUrl}/check-instructor-credentials/?username=${username}&password=${password}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['authenticated'];
    } else {  
      throw Exception('Failed to load credentials');
    }
}




// void apicall(BuildContext scaffoldContext, Map<String, dynamic> data, Map<String, String> headers, String url) async {
//   try {
//     final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));
//     if (response.statusCode == 200) {
//       print('Request successful: ${response.body}');
//     } else {
//       print('Error: ${response.statusCode}');
//       // Show a Snackbar using the Scaffold's context
//       ScaffoldMessenger.of(scaffoldContext).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${response.statusCode}'),
//           backgroundColor: Colors.red.shade400,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   } catch (e) {
//     print('Error: $e');
//     // Show a Snackbar using the Scaffold's context
//     ScaffoldMessenger.of(scaffoldContext).showSnackBar(
//       SnackBar(
//         content: Text('Error: $e'),
//         backgroundColor: Colors.red.shade400,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:edl_app/api.dart';

// final TextEditingController usernameController = TextEditingController();
// final TextEditingController passwordController = TextEditingController();
// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//     GlobalKey<ScaffoldMessengerState>();

// void showSnack(String title) {
//   final snackbar = SnackBar(
//       content: Text(
//     title,
//     textAlign: TextAlign.center,
//     style: TextStyle(
//       fontSize: 15,
//     ),
//   ));
//   scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
// }

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     // super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: ScaffoldMessenger(
//           key: scaffoldMessengerKey,
//           child: Scaffold(
//             body: Container(
//               margin: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _header(context),
//                   _inputField(context),
//                   _forgotPassword(context),
//                   _signup(context),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   _header(context) {
//     return const Column(
//       children: [
//         Text(
//           "EDL App",
//           style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//         ),
//         Text("Enter your credential to login"),
//       ],
//     );
//   }

//   _inputField(context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextField(
//           controller: usernameController,
//           decoration: InputDecoration(
//               hintText: "Username",
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none),
//               fillColor: Colors.red.withOpacity(0.1),
//               filled: true,
//               prefixIcon: const Icon(Icons.person)),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: passwordController,
//           decoration: InputDecoration(
//             hintText: "Password",
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(18),
//                 borderSide: BorderSide.none),
//             fillColor: Colors.red.withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.password),
//           ),
//           obscureText: true,
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () async {
            
//             // Navigator.pushReplacementNamed(context, '/home');
//             // If the credentials are valid, proceed to the home screen

//             if (usernameController.text.isNotEmpty &&
//                 passwordController.text.isNotEmpty) {

//               if ( usernameController.text == "admin" && passwordController.text == "edl123"){
//                 Navigator.pushReplacementNamed(context, '/home');
//               } 
//               // Check if the username exists
//               // bool checkUser = await checkUserCredentials(usernameController.text, passwordController.text);
//               // bool checkInstructor = await checkInstructorCredentials(usernameController.text, passwordController.text);
//               // If both username and password are valid, proceed to the home screen
//               // if (checkInstructor){
//               //   // dispose();
//               //   Navigator.pushReplacementNamed(context, '/home');
//               // }
//               // else if(checkUser) {
//               //   // dispose();
//               //   Navigator.pushReplacementNamed(context, '/userpage');
//               // } else {
//               //   // Show an error message if the credentials are incorrect
//               //   showSnack("Username or Password is Incorrect");
//               // }
//             } else {
//               showSnack('Username or password cannot by empty');
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             shape: const StadiumBorder(),
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             backgroundColor: Colors.red[700],
//           ),
//           child: const Text(
//             "Login",
//             style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87),
//           ),
//         )
//       ],
//     );
//   }

//   _forgotPassword(context) {
//     return TextButton(
//       onPressed: () {},
//       child: Text(
//         "Forgot password?",
//         style: TextStyle(color: Colors.red[700]),
//       ),
//     );
//   }

//   _signup(context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Dont have an account? "),
//         TextButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/signup');
//             },
//             child: Text(
//               "Sign Up",
//               style: TextStyle(color: Colors.red[700]),
//             ))
//       ],
//     );
//   }
// }


// import 'package:edl_app/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';

// const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU'; // Replace with your OAuth2 client ID
// const String clientSecret = 'WDxMJPKRZHdUvtBtlQv9j1y5ITwZxVfE8J9azhqp3n72SPshj44itgHTwNiywO0eH1CYZOhP1mzQbmNLtPKxhbJLTfoAMtjWRNrdYaPKG92aXBQoJplPzegLvdJDyzj2'; // Replace with your OAuth2 client secret

// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//     GlobalKey<ScaffoldMessengerState>();

// void showSnack(String title) {
//   final snackbar = SnackBar(
//       content: Text(
//     title,
//     textAlign: TextAlign.center,
//     style: TextStyle(
//       fontSize: 15,
//     ),
//   ));
//   scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
// }



// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   String _deepLink = '';
//   String? _accessToken;
//   Map<String, dynamic>? _userData;
//   bool _isLoading = false; // Add this variable to track loading state

//   @override
//   void initState() {
//     super.initState();
//     initUniLinks();
//   }

//   Future<void> initUniLinks() async {
//     // Get initial link
//     final initialLink = await getInitialLink();
//     // Handle initial link if available
//     if (initialLink != null) {
//       handleDeepLink(initialLink);
//     }
//     // Listen for deep links
//     linkStream.listen((String? link) {
//       if (link != null) {
//         handleDeepLink(link);
//       }
//     });
//   }

//   void handleDeepLink(String link) {
//     setState(() {
//       _deepLink = link;
//     });

//     // Extract authorization code from the deep link URL
//     final authorizationCode = extractAuthorizationCodeFromDeepLink(link);
//     if (authorizationCode != null) {
//       print('Authorization Code: $authorizationCode');
//       // Exchange authorization code for access token
//       exchangeAuthorizationCode(authorizationCode);
//     }
//   }

//   String? extractAuthorizationCodeFromDeepLink(String deepLink) {
//     final uri = Uri.parse(deepLink);
//     return uri.queryParameters['code'];
//   }

//   Future<void> exchangeAuthorizationCode(String authorizationCode) async {
//     final String basicAuth =
//         'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
//     final Uri tokenUri = Uri.parse('https://gymkhana.iitb.ac.in/profiles/oauth/token/');
//     final Map<String, String> headers = {
//       'Authorization': basicAuth,
//       'Content-Type': 'application/x-www-form-urlencoded'
//     };
//     final Map<String, String> body = {
//       'code': authorizationCode,
//       'grant_type': 'authorization_code',
//     };

//     final response = await http.post(tokenUri, headers: headers, body: body);
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final accessToken = jsonData['access_token'];
//       setState(() {
//         _accessToken = accessToken;
//       });
//       print('Access Token: $_accessToken');
//       // Fetch user data using access token
//       fetchUserData(accessToken);
//     } else {
//       print('Failed to exchange authorization code for access token');
//     }
//   }

//   Future<void> fetchUserData(String accessToken) async {
//     final userApiUrl = 'https://gymkhana.iitb.ac.in/profiles/user/api/user/?fields=first_name,last_name,type,profile_picture,sex,username,email,program,contacts,insti_address,secondary_emails,mobile,roll_number';
//     final headers = {'Authorization': 'Bearer $accessToken'};
//     final response = await http.get(Uri.parse(userApiUrl), headers: headers);
//     if (response.statusCode == 200) {
//       final userData = json.decode(response.body);
//       print('User Data: $userData');
//       setState(() {
//         _userData = userData;
//       });
//       Navigator.push(
//         context,
//       MaterialPageRoute(
//         builder: (context) => Home(),
//       ),
//     );

//     } else {
//       print('Failed to fetch user data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Page',
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue, // Set background color to blue
//           title: Text(
//             'Login Page',
//             style: TextStyle(color: Colors.white), // Set text color to white
//           ),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open the authorization URL
//                   launchAuthorizationUrl();
//                 },
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.blue[500], ),
//                 child: Text('Login with SSO', style: TextStyle(color: Colors.black),),
//               ),
//               SizedBox(height: 20),
//               if (_userData != null) ...[
//                 Text(
//                   'User Data:',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 if (_userData!['first_name'] != null && _userData!['last_name'] != null) 
//                   Text('Name: ${_userData!['first_name']} ${_userData!['last_name']}'),
//                 if (_userData!['email'] != null) 
//                   Text('Email: ${_userData!['email']}'),
//                 if (_userData!['roll_number'] != null) 
//                   Text('Roll Number: ${_userData!['roll_number']}'),
//                 if (_userData!['program'] != null) ...[
//                   Text('Department: ${_userData!['program']['department_name']}'),
//                   Text('Degree: ${_userData!['program']['degree_name']}'),
//                   Text('Join Year: ${_userData!['program']['join_year']}'),
//                   Text('Graduation Year: ${_userData!['program']['graduation_year']}'),
//                 ],
//                 if (_userData!['insti_address'] != null) ...[
//                   Text('Hostel: ${_userData!['insti_address']['hostel_name']}'),
//                   Text('Room: ${_userData!['insti_address']['room']}'),
//                 ],
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void launchAuthorizationUrl() async {
//     final authorizationUrl = 'https://gymkhana.iitb.ac.in/profiles/oauth/authorize/?' 
//         'client_id=$clientId&'
//         'response_type=code&'
//         'scope=basic profile picture sex ldap phone insti_address program secondary_emails send_mail&'
//         'state=some_state';

//     if (await canLaunch(authorizationUrl)) {
//       await launch(authorizationUrl);
//     } else {
//       print('Failed to launch authorization URL');
//     }
//   }
// }

import 'package:edl_app/userpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:edl_app/home.dart';

const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU'; // Replace with your OAuth2 client ID
const String clientSecret = 'WDxMJPKRZHdUvtBtlQv9j1y5ITwZxVfE8J9azhqp3n72SPshj44itgHTwNiywO0eH1CYZOhP1mzQbmNLtPKxhbJLTfoAMtjWRNrdYaPKG92aXBQoJplPzegLvdJDyzj2'; // Replace with your OAuth2 client secret

// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// void showSnack(String title) {
//   final snackbar = SnackBar(
//     content: Text(
//       title,
//       textAlign: TextAlign.center,
//       style: TextStyle(
//         fontSize: 15,
//       ),
//     ),
//   );
//   scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _deepLink = '';
  String? _accessToken;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Get initial link
    final initialLink = await getInitialLink();
    // Handle initial link if available
    if (initialLink != null) {
      handleDeepLink(initialLink);
    }
    // Listen for deep links
    linkStream.listen((String? link) {
      if (link != null) {
        handleDeepLink(link);
      }
    });
  }

  void handleDeepLink(String link) {
    setState(() {
      _deepLink = link;
    });

    // Extract authorization code from the deep link URL
    final authorizationCode = extractAuthorizationCodeFromDeepLink(link);
    if (authorizationCode != null) {
      print('Authorization Code: $authorizationCode');
      // Exchange authorization code for access token
      exchangeAuthorizationCode(authorizationCode);
    }
  }

  String? extractAuthorizationCodeFromDeepLink(String deepLink) {
    final uri = Uri.parse(deepLink);
    return uri.queryParameters['code'];
  }

  Future<void> exchangeAuthorizationCode(String authorizationCode) async {
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
    final Uri tokenUri = Uri.parse('https://gymkhana.iitb.ac.in/profiles/oauth/token/');
    final Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final Map<String, String> body = {
      'code': authorizationCode,
      'grant_type': 'authorization_code',
    };

    final response = await http.post(tokenUri, headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final accessToken = jsonData['access_token'];
      setState(() {
        _accessToken = accessToken;
        _isLoading = true; // Show loading screen while fetching user data
      });
      print('Access Token: $_accessToken');
      // Fetch user data using access token
      fetchUserData(accessToken);
    } else {
      print('Failed to exchange authorization code for access token');
    }
  }

  Future<void> fetchUserData(String accessToken) async {
    final userApiUrl = 'https://gymkhana.iitb.ac.in/profiles/user/api/user/?fields=first_name,last_name,type,profile_picture,sex,username,email,program,contacts,insti_address,secondary_emails,mobile,roll_number';
    final headers = {'Authorization': 'Bearer $accessToken'};
    final response = await http.get(Uri.parse(userApiUrl), headers: headers);
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print('User Data: $userData');
      setState(() {
        _userData = userData;
        _isLoading = false; // Hide loading screen after fetching user data
      });
      if( userData['roll_number'] == "210070093"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(userData: userData,),
          ),
        );
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(userData: userData,),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false; // Hide loading screen if user data fetch failed
      });
      print('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        // key: scaffoldMessengerKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Login Page',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: _isLoading ? _buildLoadingScreen() : _buildLoginScreen(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoginScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              launchAuthorizationUrl();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[500],
            ),
            child: Text('Login with SSO', style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 20),
          // if (_userData != null) ...[
          //   Text(
          //     'User Data:',
          //     style: TextStyle(fontSize: 18),
          //   ),
          //   SizedBox(height: 10),
          //   if (_userData!['first_name'] != null && _userData!['last_name'] != null)
          //     Text('Name: ${_userData!['first_name']} ${_userData!['last_name']}'),
          //   if (_userData!['email'] != null)
          //     Text('Email: ${_userData!['email']}'),
          //   if (_userData!['roll_number'] != null)
          //     Text('Roll Number: ${_userData!['roll_number']}'),
          //   if (_userData!['program'] != null) ...[
          //     Text('Department: ${_userData!['program']['department_name']}'),
          //     Text('Degree: ${_userData!['program']['degree_name']}'),
          //     Text('Join Year: ${_userData!['program']['join_year']}'),
          //     Text('Graduation Year: ${_userData!['program']['graduation_year']}'),
          //   ],
          //   if (_userData!['insti_address'] != null) ...[
          //     Text('Hostel: ${_userData!['insti_address']['hostel_name']}'),
          //     Text('Room: ${_userData!['insti_address']['room']}'),
          //   ],
          // ],
        ],
      ),
    );
  }

  void launchAuthorizationUrl() async {
    final authorizationUrl = 'https://gymkhana.iitb.ac.in/profiles/oauth/authorize/?' 
        'client_id=$clientId&'
        'response_type=code&'
        'scope=basic profile picture sex ldap phone insti_address program secondary_emails send_mail&'
        'state=some_state';

    if (await canLaunch(authorizationUrl)) {
      await launch(authorizationUrl);
    } else {
      print('Failed to launch authorization URL');
    }
  }
}
import 'dart:convert';
// import 'dart:js';
// import 'dart:js';
import 'package:edl_app/issueRequest.dart';
import 'package:edl_app/request.dart';
import 'package:edl_app/return.dart';
import 'package:edl_app/signup.dart';
import 'package:edl_app/userpage.dart';
import 'package:edl_app/verifyDetails.dart';
import 'package:flutter/material.dart';
import 'package:edl_app/home.dart';
import 'package:edl_app/loading.dart';
import 'package:edl_app/scan.dart';
import 'package:edl_app/login.dart';
import 'package:edl_app/issue.dart';
import 'package:edl_app/verification.dart';
import 'package:edl_app/userpage.dart';
import 'package:edl_app/issueVerification.dart';
import 'package:edl_app/issuePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:edl_app/deviceprovider.dart';
import 'package:edl_app/add.dart';
import 'package:edl_app/discard.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          // '/signup': (context) => SignupPage(),
          '/home': (context) => Home(
                userData: {},
              ),
          '/login': (context) => LoginPage(),
          '/scan': (context) => Scan(),
          '/issue': (context) => Issue(),
          '/verification': (context) => OTPVerificationPage(
                email: "",
                onVerificationSuccess: () => {},
              ),
          '/issueVerification': (context) => IssueOTPVerificationPage(
                email: "",
                onVerificationSuccess: () => {},
                rollNo: "",
                location: "",
                name: "",
                phone_no: "",
                issue_date: DateTime.now(),
                return_date: DateTime.now(),
              ),
          '/issuePage': (context) => IssuePage(
                rollNo: "",
                location: "",
                name: "",
                phone_no: "",
                issue_date: DateTime.now(),
                return_date: DateTime.now(),
              ),
          '/userPage': (context) => UserPage(
                userData: {},
              ),
          '/return': (context) => Return(),
          '/add': (context) => Add(),
          '/discard': (context) => Discard(),

          '/request': (context) => RequestPage(
                rollNo: "",
              ),
          '/issueUser': (context) => IssueUser(userData: {}),
          '/verifyDetails': (context) => VerifyDetailsPage(
              userData: {}, location: "", deviceName: "", facultyEmail: "")
        },
      )));
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';

// const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU'; // Replace with your OAuth2 client ID

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _deepLink = '';

//   @override
//   void initState() {
//     super.initState();
//     initUniLinks();
//   }

// Future<void> initUniLinks() async {
//   // Get initial link
//   final initialLink = await getInitialLink();
//   // Handle initial link if available
//   if (initialLink != null) {
//     handleDeepLink(initialLink);
//   }
//   // Listen for deep links
//   linkStream.listen((String? link) {
//     if (link != null) {
//       handleDeepLink(link);
//     }
//   });
// }

//   void handleDeepLink(String link) {
//     setState(() {
//       _deepLink = link;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OAuth2 with Deep Link Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('OAuth2 with Deep Link Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Deep Link: $_deepLink',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open the authorization URL
//                   launchAuthorizationUrl();
//                 },
//                 child: Text('Login with OAuth2'),
//               ),
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
//         'scope=basic&'
//         // 'redirect_uri=myapp://oauth/callback&'
//         'state=some_state';

//     if (await canLaunch(authorizationUrl)) {
//       await launch(authorizationUrl);
//     } else {
//       // Handle error
//       print('Failed to launch authorization URL');
//     }
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _deepLink = '';

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
//     }
//   }

//   String? extractAuthorizationCodeFromDeepLink(String deepLink) {
//     final uri = Uri.parse(deepLink);
//     return uri.queryParameters['code'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OAuth2 with Deep Link Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('OAuth2 with Deep Link Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Deep Link: $_deepLink',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open the authorization URL
//                   launchAuthorizationUrl();
//                 },
//                 child: Text('Login with OAuth2'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void launchAuthorizationUrl() async {
//     final authorizationUrl = 'https://gymkhana.iitb.ac.in/profiles/oauth/authorize/?'
//         'client_id=TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU&'
//         'response_type=code&'
//         'scope=basic&'
//         'state=some_state';

//     if (await canLaunch(authorizationUrl)) {
//       await launch(authorizationUrl);
//     } else {
//       print('Failed to launch authorization URL');
//     }
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';

// const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU'; // Replace with your OAuth2 client ID
// const String clientSecret = 'WDxMJPKRZHdUvtBtlQv9j1y5ITwZxVfE8J9azhqp3n72SPshj44itgHTwNiywO0eH1CYZOhP1mzQbmNLtPKxhbJLTfoAMtjWRNrdYaPKG92aXBQoJplPzegLvdJDyzj2'; // Replace with your OAuth2 client secret

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _deepLink = '';

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
//       // 'redirect_uri': 'REDIRECT_URI', // Uncomment and replace with your redirect URI if required
//     };

//     final response = await http.post(tokenUri, headers: headers, body: body);
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final accessToken = jsonData['access_token'];
//       print('Access Token: $accessToken');
//     } else {
//       print('Failed to exchange authorization code for access token');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OAuth2 with Deep Link Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('OAuth2 with Deep Link Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Deep Link: $_deepLink',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open the authorization URL
//                   launchAuthorizationUrl();
//                 },
//                 child: Text('Login with OAuth2'),
//               ),
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
//         'scope=basic&'
//         'state=some_state';

//     if (await canLaunch(authorizationUrl)) {
//       await launch(authorizationUrl);
//     } else {
//       print('Failed to launch authorization URL');
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';

// const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU'; // Replace with your OAuth2 client ID
// const String clientSecret = 'WDxMJPKRZHdUvtBtlQv9j1y5ITwZxVfE8J9azhqp3n72SPshj44itgHTwNiywO0eH1CYZOhP1mzQbmNLtPKxhbJLTfoAMtjWRNrdYaPKG92aXBQoJplPzegLvdJDyzj2'; // Replace with your OAuth2 client secret

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _deepLink = '';
//   String? _accessToken;

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
//       // Parse and use user data as needed
//     } else {
//       print('Failed to fetch user data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OAuth2 with Deep Link Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('OAuth2 with Deep Link Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Deep Link: $_deepLink',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open the authorization URL
//                   launchAuthorizationUrl();
//                 },
//                 child: Text('Login with OAuth2'),
//               ),
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


// import 'package:edl_app/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';

// const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU'; // Replace with your OAuth2 client ID
// const String clientSecret = 'WDxMJPKRZHdUvtBtlQv9j1y5ITwZxVfE8J9azhqp3n72SPshj44itgHTwNiywO0eH1CYZOhP1mzQbmNLtPKxhbJLTfoAMtjWRNrdYaPKG92aXBQoJplPzegLvdJDyzj2'; // Replace with your OAuth2 client secret

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _deepLink = '';
//   String? _accessToken;
//   Map<String, dynamic>? _userData;

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
//               // Text(
//               //   'Deep Link: $_deepLink',
//               //   style: TextStyle(fontSize: 18),
//               // ),
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

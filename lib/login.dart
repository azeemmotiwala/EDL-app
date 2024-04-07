import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edl_app/userpage.dart';
import 'package:edl_app/home.dart';

const String clientId = 'TJh0OvVfNjOiFn6USmuL4QjaXm7np6dnQNSLxPyU';
const String clientSecret =
    'WDxMJPKRZHdUvtBtlQv9j1y5ITwZxVfE8J9azhqp3n72SPshj44itgHTwNiywO0eH1CYZOhP1mzQbmNLtPKxhbJLTfoAMtjWRNrdYaPKG92aXBQoJplPzegLvdJDyzj2';

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
    checkLoginStatus();

    initUniLinks();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString('userData');
    final bool? isprof = prefs.getBool('isprof');

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      if (isprof == true) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              userData: userData,
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(
              userData: userData,
            ),
          ),
        );
      }
    }
  }

  Future<void> initUniLinks() async {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleDeepLink(initialLink);
    }
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

    final authorizationCode = extractAuthorizationCodeFromDeepLink(link);
    if (authorizationCode != null) {
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
    final Uri tokenUri =
        Uri.parse('https://gymkhana.iitb.ac.in/profiles/oauth/token/');
    final Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final Map<String, String> body = {
      'code': authorizationCode,
      'grant_type': 'authorization_code',
    };
    try {
      final response = await http.post(tokenUri, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final accessToken = jsonData['access_token'];
        setState(() {
          _accessToken = accessToken;
          _isLoading = true;
        });
        fetchUserData(accessToken);
      } else {
        print('Failed to exchange authorization code for access token');
      }
    } catch (err) {}
  }

  Future<void> fetchUserData(String accessToken) async {
    final userApiUrl =
        'https://gymkhana.iitb.ac.in/profiles/user/api/user/?fields=first_name,last_name,type,profile_picture,sex,username,email,program,contacts,insti_address,secondary_emails,mobile,roll_number';
    final headers = {'Authorization': 'Bearer $accessToken'};
    try {
      final response = await http.get(Uri.parse(userApiUrl), headers: headers);
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', json.encode(userData));
        await prefs.setBool("isprof", false);
        // if (userData['roll_number'] == "210070093") {
        //   Navigator.pop(context);
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Home(
        //         userData: userData,
        //       ),
        //     ),
        //   );
        // } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(
              userData: userData,
            ),
          ),
        );
        // }
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to fetch user data');
      }
    } catch (err) {
      showSnack("Server error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Login Page',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // _buildBackgroundAnimation(),
            _isLoading ? _buildLoadingScreen() : _buildLoginScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundAnimation() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Your Background Animation',
          style: TextStyle(color: Colors.white),
        ),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Login as User',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Or",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Login as Admin',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void launchAuthorizationUrl() async {
    final authorizationUrl =
        'https://gymkhana.iitb.ac.in/profiles/oauth/authorize/?'
        'client_id=$clientId&'
        'response_type=code&'
        'scope=basic profile picture sex ldap phone insti_address program secondary_emails send_mail&'
        'state=some_state';

    // if (await canLaunch(authorizationUrl)) {
    try {
      await launch(authorizationUrl);
    } catch (Err) {
      showSnack("Server error");
    }
    // } else {
    //   print('Failed to launch authorization URL');
    // }
  }
}

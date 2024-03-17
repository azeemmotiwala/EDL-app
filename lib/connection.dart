
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectionWidget extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onConnectPressed;

  ConnectionWidget({required this.isConnected, required this.onConnectPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //   colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
      // ),

      //   gradient: LinearGradient(
      //     colors: [
      //       Color.fromARGB(255, 192, 157, 157),
      //       Color.fromARGB(255, 229, 226, 223)
      //     ],
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isConnected ? 'Connected to Reader' : 'Not Connected    ',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onConnectPressed,
                child: Text(
                  isConnected ? 'Disconnect' : 'Connect',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



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



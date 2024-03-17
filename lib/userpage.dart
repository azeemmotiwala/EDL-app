import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserState();
}

class _UserState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          flexibleSpace: Container(
            height: MediaQuery.of(context).size.height / 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
              ),
              // color: Colors.p,
            ),
          ),
          centerTitle: true,
          title: Text("Dashboard"),
          elevation: 0.0,
        ),
    );
}
}

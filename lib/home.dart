import 'package:flutter/material.dart';
import 'package:edl_app/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 3 / 8,
              decoration: BoxDecoration(
                // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
                image: DecorationImage(
                    image: AssetImage('assets/photo1.png'), fit: BoxFit.fill),
              ),
            ),
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 10,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   // primary: Colors.red[700], // background color
                    //   // onPrimary: Colors.white, // text color
                    // ),
                    child: Text("Scan"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/scan');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 10,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.red[500], // background color
                    //   onPrimary: Colors.white, // text color
                    // ),
                    child: Text("Issue"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/issue');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 10,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.red[300], // background color
                    //   onPrimary: Colors.white, // text color
                    // ),
                    child: Text("Return"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/return');
                    },
                  ),
                ),
              ),
            ],
          ),

          ],
        ));
  }
}

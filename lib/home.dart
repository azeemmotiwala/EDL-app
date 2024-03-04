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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 30),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    height: MediaQuery.of(context).size.height / 8,
                    // color: Colors.red,
                    child: ElevatedButton(
                      child: Text("Scan"),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/bluetooth');
                      },
                    ),
                    // decoration: BoxDecoration(
                    // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
                    // borderRadius: BorderRadius.circular(20),
                    // image: DecorationImage(
                    //   image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                    //   fit: BoxFit.fitHeight
                    //   ),
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 0, 30),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    height: MediaQuery.of(context).size.height / 8,
                    child: ElevatedButton(
                      child: Text("Issue"),
                      onPressed: () {},
                    ),

                    // decoration: BoxDecoration(
                    // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
                    // ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 30),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    height: MediaQuery.of(context).size.height / 8,

                    child: ElevatedButton(
                      child: Text("Return"),
                      onPressed: () {},
                    ),
                    // decoration: BoxDecoration(
                    // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 0, 30),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    height: MediaQuery.of(context).size.height / 8,
                    child: ElevatedButton(
                      child: Text("Products"),
                      onPressed: () {},
                    ),
                    // decoration: BoxDecoration(
                    // gradient: LinearGradient( colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],),
                    // ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

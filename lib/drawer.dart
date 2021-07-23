import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/myhomepage.dart';
import 'package:test_app/welcome.dart';

class drawer extends StatefulWidget {

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {

  @override
  Widget build(BuildContext context) {
    logOut() async {
      var prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()),(route)=> false);
      print("Logged Out");
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage("https://cdn3.iconfinder.com/data/icons/communication-232/384/Account_circle-512.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      width: 95,
                      height: 95),
                  const Text(
                    "name",
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          ListTile(onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(title: "Green House")));
          },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: const Text(
                "Dashboard",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          ListTile(onTap: logOut,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: const Text(
                "Logout",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

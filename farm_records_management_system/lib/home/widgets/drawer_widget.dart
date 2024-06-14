import 'package:farm_records_management_system/home/components/sections/task_section.dart';
import 'package:farm_records_management_system/home/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              accountName: Text(
                "Aeneas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "aeneas@aeneid.com",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/aeneas.jpg"),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
            leading: Icon(
              CupertinoIcons.home,
              color: Color(0xFF3388E3C),
            ),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
            leading: Icon(
              CupertinoIcons.person,
              color: Color(0xFF3388E3C),
            ),
            title: Text(
              "My Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
            leading: Icon(
              Icons.description,
              color: Color(0xFF3388E3C),
            ),
            title: Text(
              "My Farm Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmTaskPage(),
                  ));
            },
            leading: Icon(
              CupertinoIcons.settings,
              color: Color(0xFF3388E3C),
            ),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xFF3388E3C),
            ),
            title: Text(
              "Log Out",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

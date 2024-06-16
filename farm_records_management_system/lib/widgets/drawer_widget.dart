import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:farm_records_management_system/profileManagement/login.dart';
import 'package:farm_records_management_system/profileManagement/myAccountPage.dart';
import 'package:farm_records_management_system/profileManagement/myFarmPage.dart';
import 'package:farm_records_management_system/profileManagement/settingsPage.dart';
import 'package:farm_records_management_system/profileManagement/aboutPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final Map<String, dynamic> farmer;

  const DrawerWidget({super.key, required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              accountName: Text(
                "${farmer['firstName'] ?? 'FirstName'} ${farmer['lastName'] ?? 'LastName'}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                farmer['email'] ?? 'email@example.com',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(farmer: farmer),
                ),
              );
            },
            leading: const Icon(
              CupertinoIcons.home,
              color: Color(0xff3388e3c),
            ),
            title: const Text(
              "Home",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyAccountPage(farmer: farmer),
                ),
              );
            },
            leading: const Icon(
              CupertinoIcons.person,
              color: Color(0xff3388e3c),
            ),
            title: const Text(
              "My Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFarmPage(farmer: farmer),
                ),
              );
            },
            leading: const Icon(
              CupertinoIcons.cart,
              color: Color(0xff3388e3c),
            ),
            title: const Text(
              "My Farm",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            leading: const Icon(
              CupertinoIcons.settings,
              color: Color(0xff3388e3c),
            ),
            title: const Text(
              "Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ),
              );
            },
            leading: const Icon(
              Icons.info,
              color: Color(0xff3388e3c),
            ),
            title: const Text(
              "About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(0xff3388e3c),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

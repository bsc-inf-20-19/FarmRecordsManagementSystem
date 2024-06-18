import 'package:farm_records_management_system/farmer/farmer_DAO.dart';
import 'package:farm_records_management_system/profileManagement/login.dart';
import 'package:farm_records_management_system/profileManagement/registration.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Records Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => MyHomePage(),
      },
    );
  }
}

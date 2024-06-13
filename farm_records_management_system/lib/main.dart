import 'package:farm_records_management_system/profileManagement/login.dart';
import 'package:farm_records_management_system/profileManagement/registration.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

void main() async {
  // Ensure database is created
  await DatabaseHelper;

void main() {
  sqfliteFfiInit();
  // Set the database factory
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Freshify App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF33691E)),
      // home: MyHomePage(),
        initialRoute: '/',
      routes: {
         '/': (context) => LoginScreen(),
         '/register': (context) => RegistrationScreen(),
      },
    );
  }
}
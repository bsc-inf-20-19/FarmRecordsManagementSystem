import 'package:farm_records_management_system/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Freshify App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF33691E)),
      home: MyHomePage(),
    );
  }
}
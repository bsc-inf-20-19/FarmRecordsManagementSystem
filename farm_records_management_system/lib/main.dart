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
      title: "My Farm",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF33691E) ),
      home: const MyHomePage(farmer: {},),
        initialRoute: '/login',
      routes: {
         '/login': (context) => LoginScreen(),
         '/register': (context) => RegistrationScreen(),
      },
    );
  }
}

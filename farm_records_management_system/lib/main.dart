import 'dart:io';

import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS){
  sqfliteFfiInit();
  // Set the database factory
  databaseFactory = databaseFactoryFfi;
  }
  else {
    databaseFactory = databaseFactory;
  }
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
      home: const MyHomePage(),
    );
  }
}
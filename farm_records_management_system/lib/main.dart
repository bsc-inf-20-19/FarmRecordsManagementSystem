import 'package:farm_records_management_system/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  // Set the database factory
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}
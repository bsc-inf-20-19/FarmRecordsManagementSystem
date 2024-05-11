import 'dart:async';

import 'package:farm_records_management_system/Models/Expenses_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
     static Future<void> initialize() async {
    // Initialize the sqflite ffi database factory
    sqfliteFfiInit();
    // Set the database factory to use ffi
    databaseFactory = databaseFactoryFfi;
  }

  static Future<Database> _openDatabase() async {
     await initialize();
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'farm_database.db');
    print('Database location: $path'); // Print the database location
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<FutureOr<void>> _createDatabase(
      Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS expenses ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      expenseName TEXT NOT NULL,
     description TEXT NOT NULL,
      amount REAL)
  ''');
  }

  static Future<int> insertExpense(
      String expenseName, String description, double amount) async {
    final db = await _openDatabase();
    final data = {
      'expenseName': expenseName,
      'description': description,
      'amount': amount,
    };
    return await db.insert('expenses', data);
  }

  static insertUser(String name, int age) {}
}

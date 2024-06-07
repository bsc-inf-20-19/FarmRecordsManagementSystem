import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS treatments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      status TEXT,
      treatment TEXT,
      field TEXT,
      product TEXT,
      quantity TEXT
      );
    ''');
  
  }

  static Future<int> insertUser(String name, int age) async {
    final db = await _openDatabase();
    final data = {
      'name': name, 
      'age': age,
    };
    return await db.insert('users', data);
  }

   static Future<int> insertTreatments(String status, String treatmentType, 
   String field, String productUsed, String quantity) async {
    final db = await _openDatabase();
    final data = {
      'status': status, 
      'treatment': treatmentType,
      'field': field,
      'product': productUsed,
      'quantity': quantity,
    };
    return await db.insert('treatments', data);
  }

}
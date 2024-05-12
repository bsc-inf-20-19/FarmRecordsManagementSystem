import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');

    // Check if the database file is read-only
    if (await File(path).exists()) {
      final fileStat = await File(path).stat();
      final hasWritePermission =
          (fileStat.mode & 0200) != 0; // Check write permissions

      if (!hasWritePermission) {
        // If the file is read-only, delete and recreate it
        await File(path).delete();
        await File(path).writeAsBytes(await File(path).readAsBytes(), mode: FileMode.write);
      }
    }

    return openDatabase(
      path,
      version: 2, // Increment this to trigger schema upgrades
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS treatments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        status TEXT,
        treatment_type TEXT,
        field TEXT,
        product_used TEXT,
        quantity REAL,
        specific_to_planting TEXT
      )
      ''',
    );
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createDatabase(db, newVersion); // Ensure schema upgrades
    }
  }

  // CRUD operations for treatments
  static Future<int> insertTreatment(Map<String, dynamic> data) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.insert('treatments', data);
  }

  static Future<List<Map<String, dynamic>>> getTreatments() async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.query('treatments');
  }

  static Future<Map<String, dynamic>?> getTreatment(int id) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    List<Map<String, dynamic>> result = await db.query(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> deleteTreatment(int id) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.delete('treatments', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateTreatment(int id, Map<String, dynamic> data) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.update(
      'treatments',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

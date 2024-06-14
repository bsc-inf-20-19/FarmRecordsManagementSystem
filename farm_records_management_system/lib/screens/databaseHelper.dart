import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');
    print('Database path: $databasePath');

    // Check if the database file is read-only
    if (await File(path).exists()) {
      final fileStat = await File(path).stat();
      final hasWritePermission =
          (fileStat.mode & 0200) != 0; // Check write permissions

      if (!hasWritePermission) {
        // If the file is read-only, delete and recreate it
        await File(path).delete();
        await File(path)
            .writeAsBytes(await File(path).readAsBytes(), mode: FileMode.write);
      }
    }

    // Open the database
    return openDatabase(
      path,
      version: 2, // Increment this to trigger schema upgrades
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  // Method to create the database tables
  static Future<void> _createDatabase(Database db, int version) async {
    // Create a table for Treatments
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

    // Create a table for Expenses
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        expense_type TEXT,
        field TEXT,
        amount REAL,
        description TEXT,
        specific_to_field TEXT,
        customer_name TEXT
      )
      ''',
    );

    // Create a table for Plantings
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS plantings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        crop TEXT,
        field TEXT,
        description TEXT,
        cropCompany TEXT,
        cropType TEXT,
        cropPlotNumber TEXT,
        seedType TEXT,
        cropHarvest TEXT
      )
      ''',
    );

    // Create a table for Crops
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS crops (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        harvestUnits TEXT,
        notes TEXT
      )
      ''',
    );
  }

  // Method to handle database upgrades
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        '''
        CREATE TABLE IF NOT EXISTS crops (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          harvestUnits TEXT,
          notes TEXT
        )
        ''',
      );
    }
  }

  // CRUD operations for treatments
  static Future<int> insertTreatment(Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.insert('treatments', data);
  }

  static Future<List<Map<String, dynamic>>> getTreatments() async {
    Database db = await _openDatabase();
    return await db.query('treatments');
  }

  static Future<Map<String, dynamic>?> getTreatment(int id) async {
    Database db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> deleteTreatment(int id) async {
    Database db = await _openDatabase();
    return await db.delete('treatments', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateTreatment(int id, Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.update(
      'treatments',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for expenses
  static Future<int> insertTransaction(Map<String, dynamic> tdata) async {
    Database db = await _openDatabase();
    return await db.insert('expenses', tdata);
  }

  static Future<int> deleteTransaction(int id) async {
    Database db = await _openDatabase();
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Getter methods for expenses
  static Future<Map<String, dynamic>?> getTransaction(int id) async {
    Database db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    Database db = await _openDatabase();
    return await db.query('expenses');
  }

  // CRUD operations for plantings
  static Future<int> insertPlanting(Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.insert('plantings', data);
  }

  static Future<List<Map<String, dynamic>>> getPlantings(DateTime selectedDate, {required endDate, required startDate}) async {
    Database db = await _openDatabase();
    return await db.query('plantings');
  }

  static Future<Map<String, dynamic>?> getPlanting(int id) async {
    Database db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'plantings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> deletePlanting(int id) async {
    Database db = await _openDatabase();
    return await db.delete('plantings', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updatePlanting(int id, Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.update(
      'plantings',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static getPlantingsByDate(DateTime selectedDate) {}

  // Method to fetch unique crop names for autocomplete suggestions
  static Future<List<String>> getCropSuggestions() async {
    Database db = await _openDatabase();
    final List<Map<String, dynamic>> crops = await db.query(
      'plantings',
      columns: ['crop'],
      distinct: true,
    );
    return crops.map((e) => e['crop'] as String).toList();
  }

  // CRUD operations for crops
  static Future<int> insertCrop(Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.insert('crops', data);
  }

  static Future<List<Map<String, dynamic>>> getCrops() async {
    Database db = await _openDatabase();
    return await db.query('crops');
  }

  static Future<Map<String, dynamic>?> getCrop(int id) async {
    Database db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'crops',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> deleteCrop(int id) async {
    Database db = await _openDatabase();
    return await db.delete('crops', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateCrop(int id, Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.update(
      'crops',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
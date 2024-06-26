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
      version: 1, // Increment this to trigger schema upgrades
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

 // Create a table for harvests
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS harvests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        cropList TEXT,
        batchNo TEXT,
        harvestQuantity TEXT,
        harvestQuality TEXT,
        unitCost TEXT,
        harvestIncome TEXT,
        harvestNotes TEXT,
      )
      ''',
    );

  //Create the 'livestock' table
    await db.execute('''
    CREATE TABLE livestock (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      icon INTEGER
    )
    ''');
  }

  // Method to handle database upgrades
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Perform necessary upgrades here
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

  // CRUD operations for expenses
  static Future<int> insertTransaction(Map<String, dynamic> tdata) async {
    Database db = await _openDatabase();
    return await db.insert('expenses', tdata);
  }

  static Future<int> deleteTransaction(int id) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Getter methods for expenses
  static Future<Map<String, dynamic>?> getTransaction(int id) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    List<Map<String, dynamic>> result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null; 
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.query('expenses');
  }

    // CRUD operations for harvests
  static Future<int> insertHarvest(Map<String, dynamic> data) async {
    Database db = await _openDatabase();
    return await db.insert('harvests', data);
  }

  static Future<List<Map<String, dynamic>>> getHarvests() async {
    Database db = await _openDatabase();
    return await db.query('harvests');
  }

  static Future<Map<String, dynamic>?> getHarvest(int id) async {
    Database db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'harvests',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  
  static Future<int> deleteHarvest(int id) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.delete('harvests', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateHarvest(int id, Map<String, dynamic> data) async {
    Database db = await _openDatabase(); // Ensure proper initialization
    return await db.update(
      'harvests',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // Inserts a row into the 'livestock' table
  Future<int> insertLivestock(Map<String, dynamic> row) async {
    Database db = await _openDatabase();  // Get the database instance
    // Insert the row into the table and return the id of the inserted row
    return await db.insert('livestock', row);
  }

  // Queries all rows from the 'livestock' table
  Future<List<Map<String, dynamic>>> queryAllLivestock() async {
    Database db = await _openDatabase();  // Get the database instance
    // Query all rows from the table and return them as a list of maps
    return await db.query('livestock');
  }

  // Deletes a row from the 'livestock' table by id
  Future<int> deleteLivestock(int id) async {
    Database db = await _openDatabase();  // Get the database instance
    // Delete the row with the specified id and return the number of affected rows
    return await db.delete('livestock', where: 'id = ?', whereArgs: [id]);
  }


}

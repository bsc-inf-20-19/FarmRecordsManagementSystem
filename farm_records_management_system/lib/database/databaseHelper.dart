import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  factory DatabaseHelper() => instance;

  // Table names
  String farmersTable = 'farmersTable';
  String farmTable = 'farmTable';
  String cropsTable = 'cropsTable';
  String incomeTable = 'incomeTable'; // Newly added
  String expenseTable = 'expenseTable'; // Newly added
  String inventoryTable = 'inventoryTable';
  String treatmentsTable = 'treatmentsTable';
  // other table names...

  // Farmer columns
  String farmersID = 'farmersID';
  // Income columns
  String incomeID = 'incomeID';
  String amount = 'amount';
  String date = 'date';
  String description = 'description';
  // Expense columns
  String expenseID = 'expenseID';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, 'farm_management.db');
    final db = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return db;
  }

  // Method to create the database tables
  void _createDb(Database db, int version) async {
    // Create a table for Treatments
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS $treatmentsTable (
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

    await db.execute('''
    CREATE TABLE $farmersTable (
      $farmersID INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName TEXT,
      lastName TEXT,
      email TEXT,
      phone TEXT,
      password TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE $farmTable (
      farmID INTEGER PRIMARY KEY AUTOINCREMENT,
      $farmersID INTEGER,
      farmName TEXT,
      size TEXT,
      type TEXT,
      FOREIGN KEY ($farmersID) REFERENCES $farmersTable($farmersID)
    )
  ''');

    await db.execute('''
      CREATE TABLE $cropsTable (
        cropID INTEGER PRIMARY KEY AUTOINCREMENT,
        farmersID INTEGER,
        cropName TEXT,
        cropType TEXT,
        plantingDate TEXT,
        harvestDate TEXT,
        cropYield INTEGER,
        FOREIGN KEY (farmersID) REFERENCES $farmersTable(farmersID)
      )
    ''');

    await db.execute('''
    CREATE TABLE $incomeTable (
      $incomeID INTEGER PRIMARY KEY AUTOINCREMENT,
      $amount REAL NOT NULL,
      $date TEXT NOT NULL,
      $description TEXT,
      $farmersID INTEGER,
      FOREIGN KEY (farmersID) REFERENCES $farmersTable(farmersID)
    )
  ''');

    await db.execute('''
    CREATE TABLE $expenseTable (
      $expenseID INTEGER PRIMARY KEY AUTOINCREMENT,
      $amount REAL NOT NULL,
      $date TEXT NOT NULL,
      $description TEXT,
      $farmersID INTEGER,
      FOREIGN KEY (farmersID) REFERENCES $farmersTable(farmersID)
    )
  ''');

    await db.execute('''
  CREATE TABLE $inventoryTable (
    ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemName TEXT NOT NULL,
    Quantity INTEGER NOT NULL,
    PurchaseDate TEXT,
    Threshold INTEGER NOT NULL,
    $farmersID INTEGER,
    FOREIGN KEY (farmersID) REFERENCES $farmersTable (farmersID)
  ) 
  ''');
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

    // Create a table for Fields
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS fields (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fieldName TEXT,
        fieldType TEXT,
        lightProfile TEXT,
        fieldStatus TEXT,
        fieldSize REAL,
        notes TEXT
      )
      ''',
    );

    // Create a table for Tasks
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskName TEXT,
        status TEXT,
        date TEXT,
        isSpecificToPlanting INTEGER,
        field TEXT,
        notes TEXT
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
        cropHarvest TEXT
      )
      ''',
    );

  }

   Future<int> deleteTransaction(int id) async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

   Future<Map<String, dynamic>?> getTransaction(int id) async {
    Database db = await _initDb(); // Ensure proper initialization
    List<Map<String, dynamic>> result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

   Future<List<Map<String, dynamic>>> getTransactions() async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.query('expenses');
  }

  // CRUD operations for fields
   Future<int> insertField(Map<String, dynamic> data) async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.insert('fields', data);
  }

   Future<List<Map<String, dynamic>>> getFields() async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.query('fields');
  }

   Future<Map<String, dynamic>?> getField(int id) async {
    Database db = await _initDb(); // Ensure proper initialization
    List<Map<String, dynamic>> result = await db.query(
      'fields',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

   Future<int> deleteField(int id) async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.delete('fields', where: 'id = ?', whereArgs: [id]);
  }

   Future<int> updateField(int id, Map<String, dynamic> data) async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.update(
      'fields',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for tasks
   Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await _initDb();
    return await db.insert('tasks', task);
  }

   Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await _initDb();
    return await db.query('tasks');
  }

   Future<Map<String, dynamic>?> getTaskById(int id) async {
    Database db = await _initDb();
    List<Map<String, dynamic>> result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

   Future<int> deleteTask(int id) async {
    Database db = await _initDb();
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

   Future<int> updateTask(int id, Map<String, dynamic> data) async {
    Database db = await _initDb();
    return await db.update(
      'tasks',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Perform necessary upgrades here
    }
  }

  Future<List<Map<String, dynamic>>> getTreatments() async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.query('treatmentsTable');
  }

  Future<Map<String, dynamic>?> getTreatment(int id) async {
    Database db = await _initDb(); // Ensure proper initialization
    List<Map<String, dynamic>> result = await db.query(
      'treatmentsTable',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteTreatment(int id) async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.delete('treatmentsTable', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTreatment(int id, Map<String, dynamic> data) async {
    Database db = await _initDb(); // Ensure proper initialization
    return await db.update(
      'treatmentsTable',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTreatments(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert(DatabaseHelper.instance.treatmentsTable, row);
  }

  Future<Map<String, dynamic>> getFinancialReport(int farmerID) async {
    Database db = await this.db;
    List<Map<String, dynamic>> incomeResult = await db.rawQuery('''
      SELECT SUM($amount) as totalIncome
      FROM $incomeTable
    ''');
    List<Map<String, dynamic>> expenseResult = await db.rawQuery('''
      SELECT SUM($amount) as totalExpense
      FROM $expenseTable
    ''');
    return {
      'totalIncome': incomeResult.first['totalIncome'] ?? 0,
      'totalExpense': expenseResult.first['totalExpense'] ?? 0,
      'netIncome': (incomeResult.first['totalIncome'] ?? 0) -
          (expenseResult.first['totalExpense'] ?? 0)
    };
  }
  // // CRUD operations for plantings
  Future<int> insertPlanting(Map<String, dynamic> data) async {
    Database db = await _initDb();
    return await db.insert('plantings', data);
  }

  Future<List<Map<String, dynamic>>> getPlantings(DateTime selectedDate, {required endDate, required startDate}) async {
    Database db = await _initDb();
    return await db.query('plantings');
  }

  Future<Map<String, dynamic>?> getPlanting(int id) async {
    Database db = await _initDb();
    List<Map<String, dynamic>> result = await db.query(
      'plantings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deletePlanting(int id) async {
    Database db = await _initDb();
    return await db.delete('plantings', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePlanting(int id, Map<String, dynamic> data) async {
    Database db = await _initDb();
    return await db.update(
      'plantings',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  getPlantingsByDate(DateTime selectedDate) {}

  // Method to fetch unique crop names for autocomplete suggestions
  Future<List<String>> getCropSuggestions() async {
    Database db = await _initDb();
    final List<Map<String, dynamic>> crops = await db.query(
      'plantings',
      columns: ['crop'],
      distinct: true,
    );
    return crops.map((e) => e['crop'] as String).toList();
  }
}

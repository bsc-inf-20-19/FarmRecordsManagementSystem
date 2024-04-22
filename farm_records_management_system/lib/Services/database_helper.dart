import 'package:farm_records_management_system/Models/Expenses_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'Farm.db';

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE expenses(id INTEGER PRIMARY KEY, amount REAL,expenseName TEXT NOT NULL, date TEXT NOT NULL, description TEXT NOT NULL);"),
          version: _version
    );
  }

  static Future<int> addExpense(Expenses expenses) async {
        final db = await _getDB();
        return await db.insert("Expenses", expenses.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateExpense(Expenses expenses) async {
    final db = await _getDB();
    return await db.update("Expenses", expenses.toJson(),
        where: 'id = ?',
        whereArgs: [expenses.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteExpense(Expenses expenses) async {
    final db = await _getDB();
    return await db.delete(
      "Note",
      where: 'id = ?',
      whereArgs: [expenses.id],
    );
  }

  static Future<List<Expenses>?> getAllExpenses() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Expenses");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Expenses.fromJson(maps[index]));
  }
}

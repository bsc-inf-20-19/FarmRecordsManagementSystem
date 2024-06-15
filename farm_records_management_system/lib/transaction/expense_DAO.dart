import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDAO {
  static final ExpenseDAO instance = ExpenseDAO._instance();
  ExpenseDAO._instance();

  Future<int> insertExpense(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert(DatabaseHelper.instance.expenseTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllExpenses(int farmerID) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.query(DatabaseHelper.instance.expenseTable);
  }

  Future<int> updateExpense(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper.instance.db;
    int id = row['id'];
    return await db.update(
      DatabaseHelper.instance.expenseTable,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.delete(
      DatabaseHelper.instance.expenseTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDAO {
  static final IncomeDAO instance = IncomeDAO._instance();
  IncomeDAO._instance();

  Future<int> insertIncome(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert(DatabaseHelper.instance.incomeTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllIncomes(int farmerID) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.query(DatabaseHelper.instance.incomeTable);
  }
    Future<int> updateIncome(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper.instance.db;
    int id = row['id'];
    return await db.update(
      DatabaseHelper.instance.incomeTable,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteIncome(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.delete(
      DatabaseHelper.instance.incomeTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:farm_records_management_system/screens/databaseHelper.dart';
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
}

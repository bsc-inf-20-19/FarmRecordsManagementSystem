import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'farmer.dart';

class FarmerDAO {
  static final FarmerDAO instance = FarmerDAO._instance();
  FarmerDAO._instance();

  Future<int> insertFarmer(Farmer farmer) async {
    Database db = await DatabaseHelper.instance.db;
    final int result = await db.insert(DatabaseHelper.instance.farmersTable, farmer.toMap());
    return result;
  }

  Future<Farmer?> getFarmer(int id) async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.instance.farmersTable,
      where: '${DatabaseHelper.instance.farmersID} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Farmer.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateFarmer(Farmer farmer) async {
    Database db = await DatabaseHelper.instance.db;
    final int result = await db.update(
      DatabaseHelper.instance.farmersTable,
      farmer.toMap(),
      where: '${DatabaseHelper.instance.farmersID} = ?',
      whereArgs: [farmer.farmersID],
    );
    return result;
  }

  Future<int> deleteFarmer(int id) async {
    Database db = await DatabaseHelper.instance.db;
    final int result = await db.delete(
      DatabaseHelper.instance.farmersTable,
      where: '${DatabaseHelper.instance.farmersID} = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<Farmer?> getFarmerByEmailAndPassword(String email, String password) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map<String, dynamic>> results = await db.query(
      DatabaseHelper.instance.farmersTable,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return Farmer.fromMap(results.first);
    } else {
      return null;
    }
  }

  Future<int> registerFarmer(String firstName, String lastName, String email, String password) async {
    Database db = await DatabaseHelper.instance.db;

    List<Map<String, dynamic>> existingFarmers = await db.query(
      DatabaseHelper.instance.farmersTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingFarmers.isNotEmpty) {
      return -1;
    }

    Map<String, dynamic> farmer = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    return await db.insert(DatabaseHelper.instance.farmersTable, farmer);
  }
}

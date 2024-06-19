import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class FarmerDAO {
  static final FarmerDAO instance = FarmerDAO._instance();
  static Database? _db;

  FarmerDAO._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await DatabaseHelper.instance.db;
    }
    return _db!;
  }

  Future<Map<String, dynamic>?> getFarmerByEmailAndPassword(String email, String hashedPassword) async {
    Database db = await this.db;
    List<Map<String, dynamic>> result = await db.query(
      'farmersTable',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> registerFarmer(String firstName, String lastName, String email, String hashedPassword) async {
    Database db = await this.db;

    // Check if email already exists
    List<Map<String, dynamic>> existing = await db.query(
      'farmersTable',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (existing.isNotEmpty) {
      return -1; // Email already exists
    }

    // Insert new farmer
    return await db.insert('farmersTable', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': hashedPassword,
    });
  }

  Future<void> sendVerificationEmail(String email) async {
    // Placeholder for sending verification email
    print('Sending verification email to $email');
  }
}

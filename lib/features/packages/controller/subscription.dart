import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:sqflite/sqflite.dart';

class PackagesController {
  static final PackagesController _instance = PackagesController._internal();

  factory PackagesController() {
    return _instance;
  }

  PackagesController._internal();

  // Table name and column constants
  static const String packageTable = DatabaseHelper.packageTable;
    static const String subscriptionTable = DatabaseHelper.tableSubscription;

  // Insert a pregnancy into local storage
  Future<Map<String, dynamic>?> insertPackage(Map<String, dynamic> package) async {
    final db = await DatabaseHelper().database;
    await db.insert(packageTable, package, conflictAlgorithm: ConflictAlgorithm.replace, );
    Map<String, dynamic>? packs = await loadPackage();
   return packs;
  }

  // Load the first user from the local database
  Future<Map<String, Object?>?> loadPackage() async {
    final db = await DatabaseHelper().database;

    // Fetch the first user from the table
    List<Map<String, Object?>> result = await db.query(
      packageTable,
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Insert a pregnancy into local storage
  Future<Map<String, dynamic>?> insertSubscription(Map<String, dynamic> subscription) async {
    final db = await DatabaseHelper().database;
    int sub = await db.insert(subscriptionTable, subscription, conflictAlgorithm: ConflictAlgorithm.replace, );
    if (sub >1) {
          return await loadSubcription();
    } else {
        return {'success':false, "message":"error occured"};
    }
  }

  // Load the first user from the local database
  Future<Map<String, dynamic>?> loadSubcription() async {
    final db = await DatabaseHelper().database;

    // Fetch the first user from the table
    List<Map<String, dynamic>> result = await db.query(
      subscriptionTable,
      limit: 1
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> loadSubscription(int userId) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      subscriptionTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateSubscription(Map<String, dynamic> subscription) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      subscriptionTable,
      subscription,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future<Map<String, dynamic>> unsubscribe(int userId) async {
    final db = await DatabaseHelper().database;
    try {
      int deletedCount = await db.delete(
        subscriptionTable,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      if (deletedCount > 0) {
        return {'success': true, 'message': 'Unsubscribed successfully'};
      } else {
        return {'success': false, 'message': 'No subscription found to unsubscribe'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error during unsubscribe: $e'};
    }
  }

}

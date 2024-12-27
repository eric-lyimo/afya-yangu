import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const int _databaseVersion = 11;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Table name and column constants
  static const String tableName = 'user';
  static const String columnUserId = 'userId';
  static const String columnName = 'name';
  static const String columnEmail = 'email';
  static const String columnPhone = 'phone';
  static const String columnPassword = 'password';
  static const String columnTitle = "title";
  static const String columnDob = "dob";
  static const String columnGender = "gender";
  static const String tablePreg = 'pregnancy';
  static const String columnLmp = 'lmp';
  static const String columnEdd = 'edd';
  static const String columnId = 'id';
  static const String columnCycle = 'cycle';
  static const String columnPackageName = 'name';
  static const String columnPackageId = 'packageId';
  static const String columnDate = 'date';
  static const String columnValidity = 'validity';
   static const String tableSubscription = 'subscription';
    static const String packageTable = 'packages';

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'afya_db.db');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < newVersion) {
    // Upgrade logic for version 9 and later
    if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tablePreg (
          $columnUserId INTEGER,
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnEdd TEXT NOT NULL UNIQUE,
          $columnCycle TEXT NOT NULL,
          $columnLmp TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 11) {
      // Step 1: Create a new table with the updated schema
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${tablePreg}_new (
          $columnUserId INTEGER,
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnEdd TEXT NOT NULL UNIQUE,
          $columnCycle INTEGER NOT NULL, -- Changed type to INTEGER
          $columnLmp TEXT NOT NULL
        )
      ''');

      // Step 2: Copy data from the old table to the new table
      await db.execute('''
        INSERT INTO ${tablePreg}_new ($columnUserId, $columnId, $columnEdd, $columnCycle, $columnLmp)
        SELECT $columnUserId, $columnId, $columnEdd, CAST($columnCycle AS INTEGER), $columnLmp
        FROM $tablePreg
      ''');

      // Step 3: Drop the old table
      await db.execute('DROP TABLE IF EXISTS $tablePreg');

      // Step 4: Rename the new table to the old table name
      await db.execute('ALTER TABLE ${tablePreg}_new RENAME TO $tablePreg');
    }


    // Upgrade logic for version 11 and later
    if (oldVersion < 9) {
      // Create $packageTable if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $packageTable (
          $columnName TEXT NOT NULL,
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT
        )
      ''');

      // Create $tableSubscription if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableSubscription (
          $columnUserId INTEGER NOT NULL,
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnPackageId INTEGER NOT NULL,
          $columnDate TEXT NOT NULL,
          $columnValidity TEXT
        )
      ''');
    }
  }
}


  // Create the user table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPhone TEXT NOT NULL,
        $columnPassword TEXT NOT NULL,
        $columnTitle TEXT NULL,
        $columnGender TEXT NULL,
        $columnDob TEXT NULL
      )
    ''');
  }

  // Insert a user into local storage
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(tableName, user);
  }

  // Load the first user from the local database
  Future<Map<String, dynamic>?> loadUser() async {
    final db = await database;

    // Fetch the first user from the table
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Make API call to register the user
  Future<Map<String, dynamic>> registerUser({ required String name, required String phone, required String password, required String username, required String confirmpassword}) async {

    final url = Uri.parse('http://192.168.21.114/mtmerurrh/api/register'); // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'username':username,
          'password': password,
          'confirm_password':confirmpassword
        }),
        headers: {'Content-Type': 'application/json'},
      );
        final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
          // Persist user state in local database
          await insertUser({
            columnName: name,
            columnPhone: phone,
            columnPassword: password,
            columnEmail: '', // Set empty since phone is used
          });

        return {'success': true, 'data': responseData['data']};

      } else {
          return {'success': false, 'message': responseData['message']};
        }

    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Check if a user is already registered locally
  Future<bool> isUserRegistered(String phone) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: '$columnPhone = ?',
      whereArgs: [phone],
    );
    return result.isNotEmpty;
  }

  // Login user locally
  Future<Map<String, dynamic>?> loginUser(String phone, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: '$columnPhone = ? AND $columnPassword = ?',
      whereArgs: [phone, password],
    );
    return result.isNotEmpty ? result.first : null;
  }


Future<Map<String, dynamic>> updateUserProfile({required BuildContext context,required Users user}) async {
  try {
    // Example API endpoint (replace with your actual endpoint)
    const String apiUrl = 'http://192.168.2.69/mtmerurrh/api/profile/update';

    // Show a loading indicator
    showDialog(context: context,barrierDismissible: false,builder: (BuildContext context) { return const Center(child: CircularProgressIndicator());},);

    // Data to send in the request body
     final Map<String, dynamic> requestBody = user.toMap();
     print(requestBody);

      Map<String, dynamic> resp = await updateUserProfileInSQLite(user);

      if (resp['success']) {
      await Provider.of<UserProvider>(context, listen: false).updateUserProfile(user);

      final response = await http.post(Uri.parse(apiUrl),headers: {'Content-Type': 'application/json'},body: jsonEncode(requestBody));

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close loading indicator
        return {"success": true, "message": "User successfully updated"};
      } else {
        Navigator.of(context).pop(); // Close loading indicator
        return {"success": false, "message": "Failed to update user profile via API"};
      }
    } else {
      Navigator.of(context).pop(); 
      return {"success": false, "message": resp['message']};

    }
  } catch (error) {
    Navigator.of(context).pop(); 
    return {"success": false, "message": error.toString()};
  }
}

Future<Map<String, dynamic>> updateUserProfileInSQLite(Users user) async {
  try {
    // Get database reference
    final db = await database;

    // Perform the update query using phone as a unique identifier
    int count = await db.update(tableName,user.toMap(), where: '$columnUserId = ?', whereArgs: [user.userId]);

    // Check if the update was successful
    if (count > 0) {
      return {"success": true, "message": "updated fields:$count"};
    } else {
      return {"success": false, "message": "No user updated in local storage"};
    }
  } catch (error) {
    return {"success": false, "message": error.toString()};
  }
}


 Future<void> deleteAllUsers() async {
    final db = await database;

    try {
      await db.delete(tableName); // Deletes all rows in the 'users' table
      print("All users deleted successfully.");
    } catch (e) {
      print("Error deleting users: $e");
    }
  }

  Future<int> getCurrentDatabaseVersion() async {
  final db = await database; // Ensure you have the database instance
  final result = await db.rawQuery('PRAGMA user_version;');
  return result.isNotEmpty ? result.first.values.first as int : 0;
}


}

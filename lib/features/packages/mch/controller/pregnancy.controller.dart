import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancies.model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';


class PregnancyController {
  static final PregnancyController _instance = PregnancyController._internal();

  factory PregnancyController() {
    return _instance;
  }

  PregnancyController._internal();

  // Table name and column constants
  static const String tableName = 'pregnancy';

  // Insert a pregnancy into local storage
  Future<int> insertPregnancy(Map<String, dynamic> pregnancy) async {
    final db = await DatabaseHelper().database;
    return await db.insert(tableName, pregnancy, conflictAlgorithm: ConflictAlgorithm.replace, );
  }

  // Load the first user from the local database
  Future<List<Map<String, dynamic>>?> loadPregnancy() async {
    final db = await DatabaseHelper().database;

    // Fetch the first user from the table
    List<Map<String, dynamic>> result = await db.query(
      tableName,
    );

    return result.isNotEmpty ? result : null;
  }

  // Make API call to register the user
  Future<Map<String, dynamic>> registerPregnancy(Pregnancies pregnancy) async {
    try {
      final url = Uri.parse('http://192.168.21.114/mtmerurrh/api/register'); 
      int resp = await insertPregnancy(pregnancy.toMap());

      if (resp >1) {
        final response = await http.post( url, body: pregnancy.toJson(), headers: {'Content-Type': 'application/json'},);
        final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        
        return {'success': true, 'data': responseData['data']};

      } else {
          return {'success': false, 'message': responseData['message']};
        }
      } else {
          return {'success': false, 'message': "Error inserting data"};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

Future<Map<String, dynamic>> updatePregnancy({required BuildContext context,required Pregnancies pregnancy}) async {
  try {
    // Example API endpoint (replace with your actual endpoint)
    const String apiUrl = 'http://192.168.2.69/mtmerurrh/api/profile/update';

    // Show a loading indicator
    showDialog(context: context,barrierDismissible: false,builder: (BuildContext context) { return const Center(child: CircularProgressIndicator());},);

    // Data to send in the request body
     final Map<String, dynamic> requestBody = pregnancy.toMap();
     print(requestBody);

      Map<String, dynamic> resp = await updatePregnancyInSQLite(pregnancy);

      if (resp['success']) {
      // await Provider.of<PregnancyState>(context, listen: false).updatePregnancy(pregnancy);

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

Future<Map<String, dynamic>> updatePregnancyInSQLite(Pregnancies pregnancy) async {
  try {
    // Get database reference
    final db = await DatabaseHelper().database;

    // Perform the update query using phone as a unique identifier
    int count = await db.update(tableName,pregnancy.toMap(), where: 'id = ?', whereArgs: [pregnancy.id]);

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
}

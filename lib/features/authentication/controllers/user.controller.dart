import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/config/api.config.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io'; // For SocketException

class UserController {
  static final UserController _instance = UserController._internal();

  factory UserController() {
    return _instance;
  }

  UserController._internal();

  final storage = const FlutterSecureStorage();

// Save PIN (same as password in your case)
Future<void> savePin(String pin) async {
  await storage.write(key: 'user_pin', value: pin);
}

// Get PIN
Future<String?> getPin() async {
  return await storage.read(key: 'user_pin');
}

  // Make API call to register the user
  Future<Map<String, dynamic>> registerUser({ 
    required String name, required String phone, required String password, required String title, required String confirmpassword, required String gender, required String dob 
    }) async {

    const String apiUrl = '${ApiConfig.baseUrl}/users/register';
    final url = Uri.parse(apiUrl); 


    try {
    final response = await http.post(
        url,
        body: jsonEncode({ 'name': name, 'phone': phone, 'title':title, 'password': password, 'dob':dob, 'gender':gender,}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {

        return {'success': true, 'data': responseData['data']};

      } else {
          return {'success': false, 'message': responseData};
        }

    } catch (e) {
      print(e);
      return {'success': false, 'message': e.toString()};
    }
  }



Future<Map<String, dynamic>> loginUser({
  required String phone,
  required String password,
  required BuildContext context,
}) async {
  const String apiUrl = '${ApiConfig.baseUrl}/users/login';
  final url = Uri.parse(apiUrl);

  try {
    final response = await http
        .post(
          url,
          body: jsonEncode({'phone': phone, 'password': password}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15)); // Prevents hanging forever

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final userData = responseData['data']['data']['user'];

      Users user = Users(
        token: responseData['data']['access_token'],
        email: userData['email'] ?? "example@gmail.com",
        phone: userData['phone'],
        name: userData['name'],
        dob: userData['dob'] ?? "Nil",
        gender: userData['gender'],
        title: userData['title'] ?? "Nil",
        userId: userData['id'],
      );

      final userProvider = Provider.of<UserState>(context, listen: false);
      userProvider.setUser(user);

        // Save PIN locally (same as password)
      await savePin(password);

      return {'success': true, 'message': "Mafanikio! Karibu tena, ${user.name}."};
    } else {
      // Try to parse error message, fallback to generic
      try {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? "(${response.statusCode}). Tafadhali jaribu tena."
        };
      } catch (_) {
        return {
          'success': false,
          'message': "(${response.statusCode}). Tafadhali jaribu tena."
        };
      }
    }
  } on SocketException {
    return {'success': false, 'message': "Hakuna Mtandao. Tafadhali angalia muunganisho wako wa intaneti."};
  } on TimeoutException {
    return {'success': false, 'message': "Muda umeisha. Tafadhali jaribu tena."};
  } on FormatException {
    return {'success': false, 'message': "Muundo wa jibu batili. Tafadhali jaribu tena baadaye."};
  } catch (e) {
    return {'success': false, 'message': "Unexpected error: ${e.toString()}"};
  }
}


  Future<Map<String, dynamic>> updateUserProfile({required BuildContext context,required Users user}) async {
    try {

      const String apiUrl = '${ApiConfig.baseUrl}/profile/update';

      showDialog(context: context,barrierDismissible: false,builder: (BuildContext context) { return const Center(child: CircularProgressIndicator());},);

      final Map<String, dynamic> requestBody = user.toMap();

        await Provider.of<UserState>(context, listen: false).updateUserProfile(user);

        final response = await http.post(Uri.parse(apiUrl),headers: {'Content-Type': 'application/json'},body: jsonEncode(requestBody));

        if (response.statusCode == 200) {
          Navigator.of(context).pop(); // Close loading indicator
          return {"success": true, "message": "User successfully updated"};
        } else {
          Navigator.of(context).pop(); // Close loading indicator
          return {"success": false, "message": "Failed to update user profile via API"};
        }
    } catch (error) {
      Navigator.of(context).pop(); 
      return {"success": false, "message": error.toString()};
    }
  }

}

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/config/api.config.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController {
  static final UserController _instance = UserController._internal();

  factory UserController() {
    return _instance;
  }

  UserController._internal();

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

  Future<Map<String, dynamic>> loginUser({ required String phone, required String password, required BuildContext context}) async {

    const String apiUrl = '${ApiConfig.baseUrl}/users/login';
    final url = Uri.parse(apiUrl); 

    try {
    final response = await http.post(
        url,
        body: jsonEncode({  'phone': phone, 'password': password}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
      final userData = responseData['data']['data']['user'];
      
        Users user = Users(
          token: responseData['data']['access_token'],
          email: userData['email']??"example@gmail.com",
          phone: userData['phone'],
          name: userData['name'],
          dob: userData['dob']?? "Nil", 
          gender: userData['gender'],
          title: userData['title']?? "Nil", 
          userId: userData['id']
        );

        final userProvider = Provider.of<UserState>(context, listen: false);
        userProvider.setUser(user);

        return {'success': true, 'message': "Successfuly logged in"};
      } else {
        return {'success': false, 'message': responseData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
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

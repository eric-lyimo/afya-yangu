import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/config/api.config.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:http/http.dart' as http;
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancies.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancy.logs.dart';
import 'dart:convert';

import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';

//import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';

class PregnancyController {

  Map<String, String> getHeaders (Users user) {
    return{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
    };
  }

  // Fetch a single pregnancy by ID
  Future<Map<String, dynamic>?> fetchPregnancyById(int pregnancyId) async {
    try {
      
    } catch (e) {
      throw Exception('Failed to fetch pregnancy: $e');
    }
    return null;
  }

  // Create a new pregnancy
  Future<Map<String, dynamic>> createPregnancy(
      Map<String, dynamic> pregnancyData, Users user, PregnancyState pregnancyState) async {
    const String apiUrl = '${ApiConfig.baseUrl}/pregnancies/store';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        body: jsonEncode(pregnancyData),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      final responseData = jsonDecode(response.body);
              print(responseData);
      if (response.statusCode == 201) {

        // Successfully created pregnancy, update the state
        Pregnancies pregnancy = Pregnancies(
          id: responseData['data']['id'], 
          userId: responseData['data']['user_id'], 
          edd: responseData['data']['edd'], 
          lmp: responseData['data']['lmp'], 
          cycle: responseData['data']['cycle']
        ); 

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await pregnancyState.savePregnancyData(pregnancy);
      });
        return {'success': true, 'message': "Pregnancy Data Saved Successfuly"};
      } else {
        return {'success': false, 'message': responseData['error'] ?? 'An error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

    Future<Map<String, dynamic>> createPregnancyLogs(PregnancyLogs logs, Users user,PregnancyState pregnancyState) async {
    
    const String apiUrl = '${ApiConfig.baseUrl}/pregnancy/logs/store';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        body: jsonEncode(logs.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      final responseData = jsonDecode(response.body);

  
      
      if (response.statusCode == 201) {
        List<PregnancyLogs> logs = [];

        logs.add(PregnancyLogs.fromJson(responseData['data']));

        WidgetsBinding.instance.addPostFrameCallback((_) async {
        await pregnancyState.savePregnancyLogs(logs);
      });
        return {'success': true, 'message': "Pregnancy Data Saved Successfuly"};
      } else {
        return {'success': false, 'message': responseData};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getPregnancyLogs( Users user) async {
  const String apiUrl = '${ApiConfig.baseUrl}/pregnancy/logs/view';
  final url = Uri.parse(apiUrl);

  try {
    final response = await http.get(
      url,
      headers:{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
    );
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': responseData['data']};
    } else {
      return {'success': false, 'message': responseData};
    }
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}


  // Update an existing pregnancy
Future<Map<String, dynamic>> updatePregnancy(int pregnancyId, Map<String, dynamic> pregnancyData, Users user) async {
  const String apiUrl = '${ApiConfig.baseUrl}/pregnancy/update';
  final url = Uri.parse('$apiUrl/$pregnancyId');

  try {
    final response = await http.put(
      url,
      body: jsonEncode(pregnancyData),
      headers:{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
    );
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': responseData['data']};
    } else {
      return {'success': false, 'message': responseData};
    }
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}


  // Delete a pregnancy by ID
  Future<void> deletePregnancy(int pregnancyId) async {
    try {
      
    } catch (e) {
      throw Exception('Failed to delete pregnancy: $e');
    }
  }

    // Delete a pregnancy by ID
  Future<Map<String, dynamic>> deletePregnancyLog(int pregnancyId,Users user,PregnancyState pregnancyState) async {

    const String apiUrl = '${ApiConfig.baseUrl}/pregnancy/logs/delete';
    final url = Uri.parse('$apiUrl/$pregnancyId');

    try {
      final response = await http.delete(
        url,
        headers:{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
      );
      
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
        await pregnancyState.deletePregnancyLogs(PregnancyLogs.fromJson(responseData['data']));
      });
        return {'success': true, 'message': responseData['message']};
      } else {
      
        return {'success': false, 'message': responseData['message']};
      }
    } catch (e) {
  
      return {'success': false, 'message': e.toString()};
    }
  }
}

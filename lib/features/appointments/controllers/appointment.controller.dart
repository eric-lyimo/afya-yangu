import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mtmeru_afya_yangu/config/api.config.dart';

class AppointmentController {
  Future<List<Map<String, dynamic>>> fetchAvailableDoctors(String token) async {
    const String apiUrl = '${ApiConfig.baseUrl}/doctors/list';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {

          return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        throw Exception('Failed to fetch doctors: $responseData');
      }
    } catch (e) {
      throw Exception('Exception occurred: $e');
    }
  }

  Future<List<Map>> fetchConsultations(String token) async {
    const String apiUrl = '${ApiConfig.baseUrl}/booking/list';
    final url = Uri.parse(apiUrl);

  try {
    final response = await http.get(
      url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Assuming your API returns two arrays: previous and upcoming
          return List<Map<String, dynamic>>.from(data['data']);

      // Call setState if you're inside a StatefulWidget
    } else {
        throw Exception('Failed to load data. Status: ${response.body}');
    }
  } catch (e) {
    print('Error fetching consultations: $e');
    throw Exception('Error fetching consultations: $e');
  }
}


  Future<Map<String, dynamic>> createBooking({
    required String type,
    required String status,
    required int doctorId,
    required int clinicId,
    required int userId,
    String? link,
    required DateTime time,
    required String token,
  }) async {
    const String apiUrl = '${ApiConfig.baseUrl}/booking/create';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'time': time.toIso8601String(),
          'type': type,
          'status': status,
          'doctor_id': doctorId,
          'clinic_id': clinicId,
          'user_id': userId,
          'link': link ?? '',
        }),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': responseBody['data'],
        };
      } else {
        return {
          'success': false,
          'error': responseBody['message'] ?? 'Unknown error',
          'details': responseBody,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}

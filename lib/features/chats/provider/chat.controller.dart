import 'package:mtmeru_afya_yangu/config/api.config.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatController {

  Future<List<Map>> getChatUsers(Users user) async {
    const String apiUrl = '${ApiConfig.baseUrl}/chats/participants';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
         
        final data = responseData['data'];

        List<Map> users =[];
        for (var json in data) {
          users.add({
            'name':json['name'],
            'id':json['id'],
            'last_sms':json['last_message']['message'],
            'sent_at':json['last_message']['sent_at'],
            'last_seen':json['last_seen'],
            'chats_id':json['chats_id'],
            'image':"assets/images/samia.jpg",
          });
        }

        return users;
      } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch users');
      }

    } catch (e) {
        throw Exception('Error fetching chat users: $e');
    }
  }
}

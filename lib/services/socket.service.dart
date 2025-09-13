import 'dart:convert';
import 'package:mtmeru_afya_yangu/config/api.config.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';
import 'package:http/http.dart' as http;

class SocketService {
  late PusherClient pusher;
  static const String reverbKey = "b9imbvc39p99jyfwk0n7";
  static const String websocketUrl = "192.168.20.139";
  static const String wsAuth = "http://192.168.20.139:8000/api/broadcasting/auth";

  
  void init(String sanctumToken) {
    final options = PusherOptions(
      key: reverbKey,
      host: websocketUrl,
      wsPort: 8080, 
      encrypted: false, 
      authOptions: PusherAuthOptions(
        wsAuth,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $sanctumToken',
        }
      ),
      autoConnect: false,
    );

     pusher = PusherClient( options: options);

    pusher.onConnectionEstablished((data) {
      print("Connection established: ${pusher.connected}");
    });
    pusher.onConnectionError((error) {
      print("Connection error - $error");
    });
    pusher.onError((error) {
      print("Error - $error");
    });
    pusher.onDisconnected((data) {
      print("Disconnected - $data");
    });
    pusher.connect();

  }

  // Listen to Private Channels
  void listenToChat(Channel channel, Function(dynamic) onMessageReceived) {
    channel.bind('message.sent', (data) {
      print('event received - message.sent - $data');
      onMessageReceived(data);
    });
  }


  Future<Map> loadMessages (int chatId,String token) async{
    final String apiUrl = '${ApiConfig.baseUrl}/chats/$chatId/messages';
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
 
        return {'success': true, 'data': responseData['data']};

      } else {
        print(responseData);
          return {'success': false, 'message': responseData};
        }

    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  // Subscribe to a Channel
  Channel subscribeToChannel(int chatId) {
    return pusher.private('chat.$chatId');
  }

  // Disconnect WebSocket
  void disconnect(Channel channel) {
    channel.unsubscribe();
  }
}

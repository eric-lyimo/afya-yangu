import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/chats/components/typing.chat.dart';
import 'package:mtmeru_afya_yangu/features/chats/models/chat.messages.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:mtmeru_afya_yangu/services/socket.service.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client_socket/channels/channel.dart';

class AfyaChatBody extends StatefulWidget {
  final int chatId;
  final String sanctumToken;
  const AfyaChatBody({super.key, required this.chatId, required this.sanctumToken});

  @override
  _AfyaChatBodyState createState() => _AfyaChatBodyState();
}

class _AfyaChatBodyState extends State<AfyaChatBody> {
  final SocketService socketService = SocketService();
  late Channel channel;
  final List<ChatMessage> messages = [];
  late Future<List<ChatMessage>> _messagesFuture; // Future for loading messages

  @override
  void initState() {
    super.initState();

    socketService.init(widget.sanctumToken);
    channel = socketService.subscribeToChannel(widget.chatId);

    // Fetch messages and listen for new ones
    _messagesFuture = getMessages();
    socketService.listenToChat(channel, (data) {
      print('data received - $data');
      if (mounted) {
        setState(() {
          messages.add(data);
        });
      }
    });
  }

Future<List<ChatMessage>> getMessages() async {
  try {
    final data = await socketService.loadMessages(widget.chatId, widget.sanctumToken);

    if (data['success'] == true) {
      // Parse messages
      List<ChatMessage> fetchedMessages = parseChatMessages(data['data']);

      if (mounted) {
        setState(() {
          messages.clear();
          messages.addAll(fetchedMessages);
        });
      }
      return fetchedMessages;
    } else {
      return [];
    }
  } catch (e) {
    print("Error loading messages: $e");
    return [];
  }
}


List<ChatMessage> parseChatMessages(Map<String, dynamic> data) {
  return data.values.map((message) => ChatMessage.fromJson(message)).toList();
}

@override
void dispose() {
  socketService.disconnect(channel);
  super.dispose();
}


String formatTimestamp(String timestamp) {
  DateTime messageTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));

  if (DateFormat('yyyy-MM-dd').format(messageTime) == DateFormat('yyyy-MM-dd').format(now)) {
    // Messages sent today: Show only the time
    return DateFormat('hh:mm a').format(messageTime);
  } else if (DateFormat('yyyy-MM-dd').format(messageTime) == DateFormat('yyyy-MM-dd').format(yesterday)) {
    // Messages sent yesterday: Show "Yesterday at HH:MM AM/PM"
    return "Yesterday at ${DateFormat('hh:mm a').format(messageTime)}";
  } else {
    // Older messages: Show full date with time
    return DateFormat('MMMM d, yyyy \'at\' hh:mm a').format(messageTime);
  }
}

@override
Widget build(BuildContext context) {
  Users user = Provider.of<UserState>(context).user!;

  return Column(
    children: [
      Expanded(
        child: FutureBuilder<List<ChatMessage>>(
          future: _messagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Failed to load messages"));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text("No messages yet"));
            }

            return ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                ChatMessage message = messages[index];

                // Format the timestamp to a human-readable format
                String formattedTime = formatTimestamp(message.sentAt);

                return Container(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: message.senderId == user.userId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: message.senderId == user.userId
                              ? Colors.grey.shade200
                              : Colors.blue[200],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          message.message,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 4), // Space between message and timestamp
                      Text(
                        formattedTime, // Display formatted time
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      const AfyaTypingBar(),
    ],
  );
}
}

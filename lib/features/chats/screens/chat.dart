import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/common/components/search.bar.dart';
import 'package:mtmeru_afya_yangu/features/chats/components/chat.list.dart';
import 'package:mtmeru_afya_yangu/features/chats/provider/chat.controller.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';

class AfyaChat extends StatefulWidget {
  const AfyaChat({super.key});

  @override
  State<AfyaChat> createState() => _AfyaChatState();
}

class _AfyaChatState extends State<AfyaChat> {
  List<Map> chatUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatUsers(); 
  }

  Future<void> fetchChatUsers() async {
    try {
      Users? user = Provider.of<UserState>(context, listen: false).user;
      if (user == null) {
        Future.microtask(() {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You Are Currently have no any chat")),
            );
          }
        });
        return;
      }

      List<Map> users = await ChatController().getChatUsers(user);
      if (mounted) {
        setState(() {
          chatUsers = users;
          isLoading = false;
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        Future.microtask(() {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error fetching chats: ${e.toString()}")),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<UserState>(context).user!;
    return AfyaLayout(
      title: 'Live Chat',
      subtitle: '',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Conversations",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.add, color: Colors.pink, size: 20),
                          SizedBox(width: 2),
                          Text("Add New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const AfyaSearchBar(),
             isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loader
                : ListView.builder(
                    itemCount: chatUsers.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AfyaConversationList(
                        chatId: chatUsers[index]['chats_id'],
                        name: chatUsers[index]['name'],
                        imageUrl: chatUsers[index]['image'],
                        messageText:chatUsers[index]['last_sms']??'no sms',
                        time: chatUsers[index]['sent_at']??'',
                        isMessageRead: (index == 0 || index == 3), 
                        sanctumToken: user.token,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

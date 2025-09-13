import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/chats/components/chat.body.dart';

class AfyaChatDetail extends StatefulWidget {
  final int chatId;
  final String sanctumToken;
  const AfyaChatDetail({super.key, required this.chatId, required this.sanctumToken});

  @override
  State<AfyaChatDetail> createState() => _AfyaChatDetailState();
}


class _AfyaChatDetailState extends State<AfyaChatDetail> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,color: Colors.black,),
                ),
                const SizedBox(width: 2,),
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/samia.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Kriss Benwat",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      const SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
                const Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),
      body: AfyaChatBody(chatId: widget.chatId, sanctumToken: widget.sanctumToken),
    );

  }
}
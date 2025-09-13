import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/chats/screens/chat.detail.dart';

class AfyaConversationList extends StatefulWidget {
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
  final bool isMessageRead;
  final int chatId;
  final String sanctumToken;
  const AfyaConversationList({super.key, required this.name, required this.messageText, required this.imageUrl, required this.time, required this.isMessageRead, required this.chatId, required this.sanctumToken});

  @override
  State<AfyaConversationList> createState() => _AfyaConversationListState();
}

class _AfyaConversationListState extends State<AfyaConversationList> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                        print(widget.chatId);
                          return AfyaChatDetail(chatId: widget.chatId, sanctumToken: widget.sanctumToken,);
                        }));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.name, style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 6,),
                            Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,color: Colors.green,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
    );
  }
}
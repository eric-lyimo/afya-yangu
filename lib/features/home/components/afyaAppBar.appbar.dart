import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/chats/screens/chat.dart';
import 'package:mtmeru_afya_yangu/features/home/components/emergency.dart';

class AfyaLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;

  const AfyaLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        title: Text(title),
        toolbarHeight: 60,
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(FontAwesomeIcons.circleInfo)
            ),
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const AfyaChat()));
            }, 
            icon: const Icon(FontAwesomeIcons.comments)
            ),
          IconButton(
            onPressed: (){}, 
            icon: const Icon(FontAwesomeIcons.bell)
          ),
        ],         
      ),
  
    body: body,
    floatingActionButton:
      const Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: EmergencyButton(),
        ),
      ),  
    );
  }
}

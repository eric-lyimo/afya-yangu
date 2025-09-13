import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/home/components/emergency.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';

class MchLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final TabController tabController;

  const MchLayout({
    super.key,
    required this.title,
    required this.body, required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserState>().user;

    void handleUnsubscribe(int userId) async {

    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 252, 252),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Unsubscribe'),
                content: const Text('Unsubscribing means that all the pregnancy data currently in place will be erased , the pregnancy tracker will reset to default. This action cant be undone. Are you sure yo want to unsubscribe?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); 
                      handleUnsubscribe(user!.userId);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
            }, 
          icon: const Icon(FontAwesomeIcons.rightFromBracket)),
          const Tooltip(
            message: "click to unsubscribe",
          )
          
        ],
        title:  Text(title),
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(FontAwesomeIcons.heart), text: "Tracker"),
            Tab(icon: Icon(FontAwesomeIcons.personBreastfeeding), text: "Child Health"),
            Tab(icon: Icon(FontAwesomeIcons.bookOpen), text: "Resources"),
          ],
        ),
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

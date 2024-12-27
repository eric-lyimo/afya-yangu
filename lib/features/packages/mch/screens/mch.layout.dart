import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/charts/screens/chat.dart';
import 'package:mtmeru_afya_yangu/features/home/components/emergency.dart';
import 'package:mtmeru_afya_yangu/features/packages/controller/subscription.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';
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
    var user = context.watch<UserProvider>().user;

    void handleUnsubscribe(int userId) async {
    final result = await PackagesController().unsubscribe(userId);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unsubscribed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      await context.read<PregnancyState>().clearSubscription();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Error occurred during unsubscribe'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
    return SafeArea(
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
         flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft
                )  
            ),
          ),
        title:  Text(title),
        backgroundColor: Colors.blue,
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(FontAwesomeIcons.heart), text: "Tracker"),
            Tab(icon: Icon(FontAwesomeIcons.personBreastfeeding), text: "Child Health"),
            Tab(icon: Icon(FontAwesomeIcons.bookOpen), text: "Resources"),
          ],
        ),
      ),
        body: body,
        floatingActionButton: Stack(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmergencyButton(),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AfyaChat()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.commentMedical,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

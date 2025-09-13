import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/settings/components/basic.information.dart';
import 'package:mtmeru_afya_yangu/features/settings/components/contact.info.dart';
import 'package:mtmeru_afya_yangu/features/settings/components/family.props.dart';

class PersonalProfile extends StatelessWidget {
  const PersonalProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: "Personal Profile",
      subtitle: "",
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).primaryColorDark,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(icon: Icon(FontAwesomeIcons.userPen), text: "Personal Particulars"),
                  Tab(icon: Icon(FontAwesomeIcons.addressBook), text: "Contacts"),
                  Tab(icon: Icon(FontAwesomeIcons.peopleRoof), text: "Family Profiles"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    BasicInfo(),
                    ContactInformationPage(),
                    FamilyMember()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

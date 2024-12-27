import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/investigations.screen.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/medical.conditions.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/medication.screen.dart';

class Medications extends StatelessWidget {
  const Medications({super.key});

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: "Medications",
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
                  Tab(icon: Icon(FontAwesomeIcons.pills), text: "Medications"),
                  Tab(icon: Icon(FontAwesomeIcons.stethoscope), text: "Medical Conditions"),
                  Tab(icon: Icon(FontAwesomeIcons.flaskVial), text: "Investigations"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    MedicationScreen(),
                    VitalSignsScreen(),
                    MedicalInvestigationsScreen()
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

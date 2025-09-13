import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/components/pregnancy.week.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/components/symptoms.logs.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancy.logs.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/symptoms.log.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';
import 'package:provider/provider.dart';

class MchServices extends StatelessWidget {
    final Map<String, dynamic> weekDetails;

  const MchServices({super.key, required this.weekDetails});



  @override
  Widget build(BuildContext context) {
    var logs = context.watch<PregnancyState>().logs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
              children: [
                _serviceCard(
                  context: context,
                  icon: FontAwesomeIcons.circlePlus,
                  title: 'Log Symptoms',
                  iconColor: Theme.of(context).primaryColor,
                  handle: () => openLogModal(context),
                ),
                _serviceCard(
                  context: context,
                  icon: FontAwesomeIcons.notesMedical,
                  handle: ()=>showLogsModal(context,logs),
                  title: 'Logged Symptoms',
                  iconColor: Colors.lightGreen,
                ),
                _serviceCard(
                  context: context,
                  icon: FontAwesomeIcons.personPregnant,
                  title: 'Your Body',
                  handle: ()=> showPregnancyWeekModal(context,weekDetails),
                  iconColor: Colors.purple,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _serviceCard({
    required BuildContext context,
    required IconData icon,
    VoidCallback? handle,
    required String title,
    Color backgroundColor = Colors.white,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: InkWell(
            onTap: handle,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [backgroundColor.withOpacity(0.9), backgroundColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 35,
                    color: iconColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
  
  void showLogsModal(BuildContext context, List<PregnancyLogs> logs) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const SymptomLogsDetails(),
  );
  }
  
void showPregnancyWeekModal(BuildContext context, Map<String, dynamic> weekDetails) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PregnancyWeekModal(
      weekDetails: weekDetails,
    ),  
  );
}

void openLogModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const SymptomLoggerScreen(),
  );


}
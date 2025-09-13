import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/appointments/controllers/appointment.controller.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/home/components/doctors.list.dart';
import 'package:mtmeru_afya_yangu/features/home/components/packages.card.dart';
import 'package:mtmeru_afya_yangu/features/home/components/reminder.card.dart';
import 'package:mtmeru_afya_yangu/features/home/components/service.card.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
//import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
//import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    final AppointmentController appointmentController = AppointmentController();
    List<Map<String, String>> doctors=[];
  @override
  void initState() {
    super.initState();
    _loadConsultations();
  }

  void _loadConsultations() async {
    final user = Provider.of<UserState>(context, listen: false).user;
    final result = await appointmentController.fetchAvailableDoctors(user!.token);
    setState(() {
      doctors = result.map<Map<String, String>>((e) => e.cast<String, String>()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.day}/${now.month}/${now.year}"; // Format date

    return AfyaLayout(
      title:"Welcome Back",
      subtitle: "",
      body: homeContent(formattedDate, context),
    );
  }

  SingleChildScrollView homeContent(String formattedDate, BuildContext context) {

   // var provider = context.watch<UserState>().user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    // Announcements Section
          const Text(
            "Announcements",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.blue[50],
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.announcement,
                    color: Colors.blue,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Upcoming maintenance: Dec 3, 2024. Some features may be unavailable.",
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Text(
            "Our Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const ServicesScrollView(),

          const SizedBox(height: 10),
          const Text(
            "Our Packages",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const PackagesHorizontalScrollView(),

          const ReminderSection(),

          DoctorList(doctors: doctors,),
        ],
      ),
    );
  }
}

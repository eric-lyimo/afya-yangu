import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/home/components/doctors.list.dart';
import 'package:mtmeru_afya_yangu/features/home/components/packages.card.dart';
import 'package:mtmeru_afya_yangu/features/home/components/reminder.card.dart';
import 'package:mtmeru_afya_yangu/features/home/components/service.card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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

    //var provider = context.watch<UserProvider>();

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

          const DoctorList(),
        ],
      ),
    );
  }

  // Welcome Header
  Widget _buildWelcomeHeader(String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Today is $date",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

}

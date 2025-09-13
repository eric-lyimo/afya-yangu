import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class AwaitingBaby extends StatelessWidget {
  const AwaitingBaby({super.key});

  @override
  Widget build(BuildContext context) {
      String? dueDate = "12/12/2024";
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Lottie.asset('assets/images/baby.json', height: 200),
          ), // Soothing Lottie animation for waiting
          const SizedBox(height: 20),
          const Text(
            "Awaiting Baby",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Your due date is: $dueDate\n\n"
            "Relax and prepare for the arrival of your bundle of joy. Here are some tips to keep you comfortable while you wait:",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          _buildTipCard(
            title: "Stay Active",
            description: "Gentle exercises can help reduce stress and improve mood.",
            icon: FontAwesomeIcons.personRunning,
            backgroundColor: Colors.blueAccent,
          ),
          const SizedBox(height: 10),
          _buildTipCard(
            title: "Prepare Your Bag",
            description:
                "Pack your hospital bag with essentials well in advance.",
            icon: FontAwesomeIcons.briefcaseMedical,
            backgroundColor: Colors.teal,
          ),
          const SizedBox(height: 10),
          _buildTipCard(
            title: "Stay Informed",
            description: "Explore our educational resources for guidance.",
            icon: FontAwesomeIcons.book,
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

  // Tip Card
  Widget _buildTipCard({
    required String title,
    required String description,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }


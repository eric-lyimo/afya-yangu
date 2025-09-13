import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
     return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          "Vaccination Schedule",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildCardWithAnimation(
          title: "Polio Vaccine",
          description: "Scheduled for: 10/12/2024",
          icon: FontAwesomeIcons.syringe,
          backgroundColor: Colors.teal,
        ),
        const SizedBox(height: 10),
        _buildCardWithAnimation(
          title: "Measles Vaccine",
          description: "Scheduled for: 24/12/2024",
          icon: FontAwesomeIcons.syringe,
          backgroundColor: Colors.orange,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: () {
            // Open dialog to add a vaccination
          },
          icon: const Icon(FontAwesomeIcons.plus, color: Colors.white),
          label: const Text("Add Vaccination"),
        ),
      ],
    );

  }
}
  Widget _buildCardWithAnimation({
    required String title,
    required String description,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/prescription.details.dart';

class MedicationList extends StatelessWidget {
  const MedicationList({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>showModalBottomSheet(
        context: context,
        builder: (context) => PrescriptionDetails(context: context)
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Prevent internal scrolling
        itemCount: 5, // Replace with your actual list count
        itemBuilder: (BuildContext context, int index) {
          return MedicationCard(
            name: "Medicine ${index + 1}",
            dosage: "1 tablet, 3 times a day",
            duration: "10 days",
            nextIntake: "8:00 PM",
          );
        },
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String duration;
  final String nextIntake;

  const MedicationCard({
    super.key,
    required this.name,
    required this.dosage,
    required this.duration,
    required this.nextIntake,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication Name and Next Intake
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Next: $nextIntake",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dosage and Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Icon(FontAwesomeIcons.pills, size: 20, color: Theme.of(context).primaryColorDark),
                Text(
                  dosage,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 10),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Status Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Action for marking as taken or viewing details
                },
                icon: const Icon(FontAwesomeIcons.circleCheck, size: 16),
                label: const Text("Mark as Taken"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

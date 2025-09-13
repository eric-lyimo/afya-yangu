import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedicineTrackerCard extends StatelessWidget {
  const MedicineTrackerCard({super.key});

 @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Overall Medication Tracker",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.grey),
                  onPressed: () {
                    // Show detailed information or guide
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Summary Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Medications: 5",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Next Intake: Today, 8:00 PM",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to refill page
                  },
                  icon: const Icon(FontAwesomeIcons.pills, size: 16),
                  label: const Text("Refill All"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Overall Progress",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: 0.65, // Replace with actual aggregated progress
                  backgroundColor: Colors.grey[300],
                  color: Theme.of(context).primaryColor,
                  minHeight: 8,
                ),
                const SizedBox(height: 5),
                const Text(
                  "65% of doses completed this cycle",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Medications Summary
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _medicationSummaryChip("Paracetamol", true),
                _medicationSummaryChip("Ibuprofen", true),
                _medicationSummaryChip("Amoxicillin", false),
                _medicationSummaryChip("Vitamin D", true),
                _medicationSummaryChip("Cough Syrup", false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _medicationSummaryChip(String name, bool isTaken) {
    return Chip(
      avatar: Icon(
        isTaken ? Icons.check_circle : Icons.error,
        color: isTaken ? Colors.green : Colors.red,
        size: 20,
      ),
      label: Text(name),
      backgroundColor: isTaken ? Colors.green[50] : Colors.red[50],
      labelStyle: TextStyle(
        color: isTaken ? Colors.green[800] : Colors.red[800],
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

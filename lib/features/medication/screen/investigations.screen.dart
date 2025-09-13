import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/investigation.sheet.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/investigations.card.dart';

class MedicalInvestigationsScreen extends StatelessWidget {
  const MedicalInvestigationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pending Investigations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...mockPendingInvestigations.map((investigation) {
              return InvestigationCard(
                title: investigation['name'],
                subtitle: 'Department: ${investigation['department']}',
                status: investigation['status'],
                isPending: true,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return InvestigationDetailsSheet(
                        name: investigation['name'],
                        summary: 'Pending Investigation',
                        completionDate: 'Requested on ${investigation['requestedDate']}',
                      );
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Results Investigations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...mockCompletedInvestigations.map((result) {
              return InvestigationCard(
                title: result['name'],
                subtitle: 'Completed: ${result['completionDate']}',
                status: 'Completed',
                isPending: false,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return InvestigationDetailsSheet(
                        name: result['name'],
                        summary: result['summary'],
                        completionDate: result['completionDate'],
                      );
                    },
                  );
                },
              );
            }),
          ],
        ),
    );
  }
}
final List<Map<String, dynamic>> mockPendingInvestigations = [
  {
    'id': '1',
    'name': 'Complete Blood Count (CBC)',
    'department': 'Hematology',
    'requestedDate': '2024-12-15',
    'status': 'Scheduled',
  },
  {
    'id': '2',
    'name': 'X-Ray Chest',
    'department': 'Radiology',
    'requestedDate': '2024-12-16',
    'status': 'In Progress',
  },
];

final List<Map<String, dynamic>> mockCompletedInvestigations = [
  {
    'id': '3',
    'name': 'Lipid Profile',
    'summary': 'Normal',
    'completionDate': '2024-12-10',
  },
  {
    'id': '4',
    'name': 'Thyroid Function Test',
    'summary': 'Abnormal',
    'completionDate': '2024-12-12',
  },
];

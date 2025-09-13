import 'package:flutter/material.dart';

class InvestigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final bool isPending; // Differentiates pending/completed
  final VoidCallback onTap;

  InvestigationCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.isPending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPending ? Colors.orange : Colors.green,
          child: Icon(
            isPending ? Icons.hourglass_empty : Icons.check_circle,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPending ? Colors.orange[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isPending ? 'Pending' : 'Completed',
                style: TextStyle(
                  color: isPending ? Colors.orange : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

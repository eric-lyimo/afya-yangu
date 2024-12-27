import 'package:flutter/material.dart';

class InvestigationDetailsSheet extends StatelessWidget {
  final String name;
  final String summary;
  final String completionDate;

  const InvestigationDetailsSheet({super.key, 
    required this.name,
    required this.summary,
    required this.completionDate,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.5,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            height: MediaQuery.sizeOf(context).height*0.5,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Text(
                  'Investigation Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Name: $name', style: const TextStyle(fontSize: 16)),
                Text('Completion Date: $completionDate', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text(
                  'Summary:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(summary, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading result PDF...')),
                      );
                    },
                    child: const Text('Download PDF'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

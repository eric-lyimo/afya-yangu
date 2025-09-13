import 'package:flutter/material.dart';

class VitalSignDetails extends StatelessWidget {
  final String title;
  final String unit;
  final List<Map<String, String>> readings;

  const VitalSignDetails({super.key, required this.title, required this.unit, required this.readings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
          ),
          const SizedBox(height: 16.0),
          ToggleButtons(
            isSelected: const [true, false, false],
            onPressed: (index) {
              // Add logic to switch between Daily, Weekly, Monthly
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Daily"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Weekly"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Monthly"),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Placeholder for Chart
          const Expanded(
            child: Center(
              child: Text("Chart goes here"),
            ),
          ),
          const Divider(),
          const Text(
            "Reading History",
          ),
          Expanded(
            child: ListView.separated(
              itemCount: readings.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final reading = readings[index];
                return ListTile(
                  title: Text("${reading['value']} $unit"),
                  subtitle: Text("${reading['date']} at ${reading['time']}"),
                  trailing: Text(
                    reading['change']!,
                    style: TextStyle(
                      color: reading['change']!.startsWith('+') ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
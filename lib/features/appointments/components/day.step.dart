import 'package:flutter/material.dart';

class AfyaClinicDays extends StatefulWidget {
  const AfyaClinicDays({super.key});

  @override
  State<AfyaClinicDays> createState() => _AfyaClinicDaysState();
}

class _AfyaClinicDaysState extends State<AfyaClinicDays> {
  String? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Click to select Day',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            'Monday',
            'Tuesday',
            'Thursday',
            'Saturday',
          ].map((days) {
            return OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedDay = days;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: _selectedDay == days
                    ? Colors.blue[100]
                    : null,
                side: const BorderSide(color: Colors.blue),
              ),
              child: Text(
                days,
                style: TextStyle(
                  color: _selectedDay == days
                      ? Colors.blue
                      : Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
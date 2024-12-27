import 'package:flutter/material.dart';

class AfyaClinicTime extends StatefulWidget {
  const AfyaClinicTime({super.key});

  @override
  State<AfyaClinicTime> createState() => _AfyaClinicTimeState();
}

class _AfyaClinicTimeState extends State<AfyaClinicTime> {
  String ? _selectedTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Click to select Time',
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
          ].map((time) {
            return OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedTime = time;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: _selectedTime ==time
                    ? Colors.blue[100]
                    : null,
                side: const BorderSide(color: Colors.blue),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: _selectedTime ==time
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
import 'package:flutter/material.dart';

class AfyaClinics extends StatefulWidget {
  const AfyaClinics({super.key});

  @override
  State<AfyaClinics> createState() => _AfyaClinicsState();
}

class _AfyaClinicsState extends State<AfyaClinics> {
    String? _selectedClinic;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Click to select clinic',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            'OPD',
            'Pediatric Clinic (POPD)',
            'Urology',
            'Gynecology Clinic',
            'Medical Clinic (MOPD)',
            'Ears, Nose and Throat (ENT)',
            'Ophthalmology (Eye)',
            'Orthopedic Clinic',
            'Surgical Clinic (SOPD)',
            'Dental Clinic',
            'Endoscopy',
          ].map((clinic) {
            return OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedClinic = clinic;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: _selectedClinic == clinic
                    ? Colors.blue[100]
                    : null,
                side: const BorderSide(color: Colors.blue),
              ),
              child: Text(
                clinic,
                style: TextStyle(
                  color: _selectedClinic == clinic
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
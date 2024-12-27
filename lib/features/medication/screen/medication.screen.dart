import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/medication.card.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/medication.list.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 30,
                  child: Text(
                    "Today, 28 Nov 2024",
                    style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.left,
                  )),
            ),
            const MedicineTrackerCard(),
            const MedicationList(),
          ],
        ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white70,
          elevation: 2,
          child: Container(
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [MedName(), MedicationButton()],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LowerBand(
                      title: 'Duration',
                      subtitle: '10 days',
                    ),
                    LowerBand(
                      subtitle: '1*3',
                      title: 'Dosage',
                    ),
                    LowerBand(
                      title: 'Instructions',
                      subtitle: 'After Meal',
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LowerBand extends StatelessWidget {
  final String title;
  final String subtitle;
  const LowerBand({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        Text(subtitle,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Theme.of(context).primaryColorDark))
      ],
    );
  }
}

class MedName extends StatelessWidget {
  const MedName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(FontAwesomeIcons.pills,
              size: 30, color: Theme.of(context).primaryColorDark),
        ),
        Text(
          "Paracetamol",
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class MedicationButton extends StatelessWidget {
  const MedicationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.calendarCheck,
              size: 22,
              color: Colors.white,
            ),
            SizedBox(height: 4),
            Text(
              "Start",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

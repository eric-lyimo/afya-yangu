import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrescriptionDetails extends StatelessWidget {
  const PrescriptionDetails({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Medicine Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Medicine Status Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status: Taking",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Next Intake: Today, 8:00 PM",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Refill medicine action
                },
                icon: const Icon(FontAwesomeIcons.pills, size: 18),
                label: const Text("Refill"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              ),
            ],
          ),
          const Divider(height: 30),

          // Schedule Section
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ScheduleCard(
                icon: FontAwesomeIcons.clock,
                title: "Morning",
                subtitle: "8:00 AM",
              ),
              _ScheduleCard(
                icon: FontAwesomeIcons.clock,
                title: "Afternoon",
                subtitle: "2:00 PM",
              ),
              _ScheduleCard(
                icon: FontAwesomeIcons.clock,
                title: "Evening",
                subtitle: "8:00 PM",
              ),
            ],
          ),
          const Divider(height: 30),

          // Previous History Section
          ListTile(
            leading: const Icon(FontAwesomeIcons.clockRotateLeft, color: Colors.blue),
            title: const Text("Previous Intakes"),
            subtitle: const Text("Last intake: Today, 2:00 PM"),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                // Show detailed history
              },
            ),
          ),

          // Action Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: FontAwesomeIcons.pause,
                label: "Pause",
                color: Colors.orange,
                onPressed: () {
                  // Pause medication
                },
              ),
              _ActionButton(
                icon: FontAwesomeIcons.check,
                label: "Mark as Taken",
                color: Colors.green,
                onPressed: () {
                  // Mark as taken
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ScheduleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Icon(icon, color: Theme.of(context).primaryColorDark),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label,
          backgroundColor: color,
          onPressed: onPressed,
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

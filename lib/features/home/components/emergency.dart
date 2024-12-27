import 'package:flutter/material.dart';

class EmergencyButton extends StatefulWidget {
  const EmergencyButton({super.key});

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulse Animation
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: 70 + 10 * _animationController.value,
              height: 70 + 10 * _animationController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.4 * (1 - _animationController.value)),
              ),
            );
          },
        ),
        // Emergency Button
        FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => _showEmergencyOptions(context),
          child: const Icon(Icons.local_hospital, size: 32),
        ),
      ],
    );
  }

  // Bottom Sheet for Emergency Options
  void _showEmergencyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Emergency Services",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.call, color: Colors.red),
              title: const Text("Call Ambulance"),
              onTap: () {
                // Implement call ambulance
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text("Contact Doctor"),
              onTap: () {
                // Implement contact doctor
              },
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom, color: Colors.blue),
              title: const Text("Notify Family"),
              onTap: () {
                // Implement notify family
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}

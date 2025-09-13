import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeMedicalServicesScreen extends StatelessWidget {
  const HomeMedicalServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Medical Services"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("Available Services", Icons.medical_services_outlined),
            const SizedBox(height: 15),
            _buildServiceCards(context),

            const SizedBox(height: 25),
            _sectionHeader("Track Your Health", Icons.health_and_safety_outlined),
            const SizedBox(height: 15),
            _buildHealthMonitoringSection(context),

            const SizedBox(height: 25),
            _sectionHeader("Upcoming Appointments", Icons.event_note),
            const SizedBox(height: 15),
            _buildAppointmentList(context),

            const SizedBox(height: 25),
            _sectionHeader("Emergency Services", Icons.local_hospital_outlined),
            const SizedBox(height: 15),
            _buildEmergencySection(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _serviceCard(context, "Lab Tests", FontAwesomeIcons.vial, Colors.teal, () {
          // Navigate to Lab Tests feature
        }),
        _serviceCard(context, "Nursing Care", FontAwesomeIcons.userNurse, Colors.orange, () {
          // Navigate to Nursing Care feature
        }),
        _serviceCard(context, "Physiotherapy", FontAwesomeIcons.dumbbell, Colors.blueGrey, () {
          // Navigate to Physiotherapy feature
        }),
        _serviceCard(context, "Dietitian Consult", FontAwesomeIcons.carrot, Colors.green, () {
          // Navigate to Dietitian Consult feature
        }),
      ],
    );
  }

  Widget _serviceCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMonitoringSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Home Health Monitoring",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _healthMetricTile("Blood Pressure", "120/80", FontAwesomeIcons.heartbeat, Colors.red),
                _healthMetricTile("Blood Sugar", "90 mg/dL", FontAwesomeIcons.tint, Colors.blue),
                _healthMetricTile("Heart Rate", "72 bpm", FontAwesomeIcons.heartbeat, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthMetricTile(String metric, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 5),
        Text(
          metric,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }

  Widget _buildAppointmentList(BuildContext context) {
    return Column(
      children: [
        _appointmentTile("Dr. Smith", "Cardiology", "Dec 15, 2024", "10:00 AM"),
        _appointmentTile("Dr. Jane Doe", "Dermatology", "Dec 20, 2024", "3:00 PM"),
        // Add more appointments as needed
      ],
    );
  }

  Widget _appointmentTile(String doctorName, String specialty, String date, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withOpacity(0.2),
        child: const Icon(Icons.person, color: Colors.blueAccent),
      ),
      title: Text(
        doctorName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("$specialty • $date • $time"),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to appointment details
      },
    );
  }

  Widget _buildEmergencySection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.local_hospital, color: Colors.redAccent, size: 30),
        title: const Text(
          "Emergency Ambulance",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text("Call an ambulance for urgent medical needs."),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to Emergency Services feature
        },
      ),
    );
  }
}

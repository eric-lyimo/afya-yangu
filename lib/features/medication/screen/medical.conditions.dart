
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/vitals.add.dart';
import 'package:mtmeru_afya_yangu/features/medication/components/vitals.details.dart';

class VitalSignsScreen extends StatefulWidget {
  const VitalSignsScreen({super.key});

  @override
  State<VitalSignsScreen> createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends State<VitalSignsScreen> {
  final List<Map<String, dynamic>> _vitals = [
    {"name": "Weight", "value": "70.5 kg", "time": "8:00 AM"},
    {"name": "Blood Pressure", "value": "120/80 mmHg", "time": "9:00 AM"},
  ];

  final List<Map<String, String>> _complaints = [];

  void _addVital(Map<String, dynamic> vital) {
    setState(() {
      _vitals.add(vital);
    });
  }

  void _addComplaint(String complaint) {
    setState(() {
      _complaints.add({"complaint": complaint, "date": DateTime.now().toString()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _sectionHeader("Track Your Health", Icons.health_and_safety_outlined, context, false),
        const SizedBox(height: 15),
        _buildHealthMonitoringSection(context),

        const SizedBox(height: 25),
        _sectionHeader("Vital Signs", Icons.health_and_safety_outlined, context, true),
        ..._vitals.map((vital) => VitalSignCard(
              title: vital['name']!,
              value: vital['value']!,
              time: vital['time']!,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => VitalSignDetails(
                    title: "${vital['name']} Readings",
                    unit: vital['name'] == "Weight" ? "kg" : "mmHg",
                    readings: [
                      {"date": "Nov 28, 2024", "time": "8:00 AM", "value": vital['value'], "change": "0"},
                    ],
                  ),
                );
              },
            )),
        const SizedBox(height: 25),
        _sectionHeader("Medical Complaints", FontAwesomeIcons.stethoscope, context, true),
        ..._complaints.map((complaint) => _buildComplaintCard(complaint)),
      ],
    );
  }

  Widget _buildComplaintCard(Map<String, String> complaint) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(FontAwesomeIcons.fileMedicalAlt, color: Colors.white),
        ),
        title: Text(
          complaint['complaint']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Date: ${complaint['date']}"),
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
                _healthMetricTile("Blood Pressure", "120/80", FontAwesomeIcons.heartCircleCheck, Colors.red),
                _healthMetricTile("Blood Sugar", "90 mg/dL", FontAwesomeIcons.tint, Colors.blue),
                _healthMetricTile("Heart Rate", "72 bpm", FontAwesomeIcons.heartPulse, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, BuildContext context, bool add) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        if (add)
          IconButton(
            onPressed: () {
              if (title == "Vital Signs") {
                showBottomSheet(
                  context: context,
                  builder: (context) => AddVitalSheet(
                    onAdd: (vital) => _addVital(vital),
                  ),
                );
              } else if (title == "Medical Complaints") {
                _showAddComplaintDialog(context);
              }
            },
            icon: Icon(
              FontAwesomeIcons.circlePlus,
              color: Theme.of(context).primaryColor,
            ),
          ),
      ],
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

  void _showAddComplaintDialog(BuildContext context) {
    final TextEditingController complaintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Medical Complaint"),
          content: TextField(
            controller: complaintController,
            decoration: const InputDecoration(labelText: "Enter your complaint"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (complaintController.text.isNotEmpty) {
                  _addComplaint(complaintController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class VitalSignCard extends StatelessWidget {
  final String title;
  final String value;
  final String time;
  final VoidCallback onTap;

  const VitalSignCard({
    super.key,
    required this.title,
    required this.value,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.monitor_heart,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reading: $value",
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 4),
            Text(
              "Time: $time",
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20.0, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

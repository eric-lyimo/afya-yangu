import 'package:flutter/material.dart';

class ConsultationsTab extends StatefulWidget {
  const ConsultationsTab({super.key});

  @override
  _ConsultationsTabState createState() => _ConsultationsTabState();
}

class _ConsultationsTabState extends State<ConsultationsTab> {
  List<String> upcomingSessions = ["Session 1: 12/14/2024", "Session 2: 12/16/2024"];
  List<String> pastSessions = ["Session 1: 12/10/2024 (Completed)"];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _selectedTherapist;

  // Mock list of therapists
  final List<String> therapists = [
    'Dr. John Doe',
    'Dr. Jane Smith',
    'Dr. Emily Green'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Consultations",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _bookSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: const Text(
              "Book a Therapy Session",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _buildSessionSection("Upcoming Sessions", upcomingSessions, isUpcoming: true),
          const SizedBox(height: 20),
          _buildSessionSection("Past Sessions", pastSessions),
        ],
      ),
    );
  }

  Widget _buildSessionSection(String title, List<String> sessions, {bool isUpcoming = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...sessions.map((session) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                session,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: isUpcoming
                  ? IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.grey),
                      onPressed: () => _showSessionDetail(session),
                    )
                  : null,
              onTap: () => _showSessionDetail(session),
            ),
          );
        }),
      ],
    );
  }

  void _bookSession() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0).add(EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Book Therapy Session",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedTherapist,
                  hint: const Text("Select a Therapist"),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTherapist = newValue;
                    });
                  },
                  items: therapists.map((therapist) {
                    return DropdownMenuItem<String>(
                      value: therapist,
                      child: Text(therapist),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: "Therapist",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Select Date",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: "Select Time",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: const Icon(Icons.access_time, color: Colors.blueAccent),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      _timeController.text = selectedTime.format(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      upcomingSessions.add(
                        'Session with $_selectedTherapist on ${_dateController.text} at ${_timeController.text}',
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Confirm Booking",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSessionDetail(String session) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Session Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                session,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/controller/pregnancy.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/symptoms.log.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';

class SymptomLogsDetails extends StatefulWidget {
  const SymptomLogsDetails({super.key});

  @override
  _SymptomLogsDetailsState createState() => _SymptomLogsDetailsState();
}

class _SymptomLogsDetailsState extends State<SymptomLogsDetails> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    Users? user = context.read<UserState>().user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color:  Color.fromARGB(255, 250, 252, 252), // Set a light background color
              borderRadius:  BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                // Header with drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // Title and Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Symptom Logs",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedFilter,
                      items: ['All', 'Happy', 'Sad'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (filter) {
                        setState(() {
                          selectedFilter = filter!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Logs List with Consumer
                Expanded(
                  child: Consumer<PregnancyState>(
                    builder: (context, pregnancyState, child) {
                      final logs = pregnancyState.logs;
                      return logs.isEmpty
                          ? const Center(child: Text("No logs available."))
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return buildLogCard(log.toMap(), pregnancyState, user!);
                              },
                            );
                    },
                  ),
                ),
                // Add Log Button
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const SymptomLoggerScreen(),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


Widget buildLogCard(
    Map<String, dynamic> log, PregnancyState pregnancyState, Users user) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 241, 239, 239),
          blurRadius: 8,
          offset: Offset(0, 6),
        ),
      ],
      color: const Color.fromARGB(255, 243, 245, 249), // Ensure the container is white
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.mood,
                  color: log['mood'] == 'happy' ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  log['mood'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Text(
            //   formatDateTime(log['created_at']),
            //   style: TextStyle(
            //     color: Colors.grey.shade600,
            //     fontSize: 14,
            //     fontStyle: FontStyle.italic,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            // Mood Chip with dynamic selected state and gradient
            ChoiceChip(
              label: Text("Appetite: ${log['appetite']}"),
              selected: log['appetite'] == 'Selected',
              backgroundColor: Colors.pink,
              selectedColor: Colors.pinkAccent,
              labelStyle: const TextStyle(color: Colors.white),
              onSelected: (bool selected) {
                setState(() {
                  log['appetite'] = selected ? 'Selected' : 'Not Selected';
                });
              },
            ),
            // Symptoms Chip with dynamic selected state and gradient
            ChoiceChip(
              label: Text("Symptoms: ${log['symptoms']}"),
              selected: log['symptoms'] == 'Selected',
              backgroundColor: Colors.blue,
              selectedColor: Colors.blueAccent,
              labelStyle: const TextStyle(color: Colors.white),
              onSelected: (bool selected) {
                setState(() {
                  log['symptoms'] = selected ? 'Selected' : 'Not Selected';
                });
              },
            ),
          ],
        ),
        if (log['comment'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[50], // Subtle background color
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 236, 233, 233),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "Comments: ${log['comment']}",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8,),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Add confirmation dialog here
                confirmDeleteLog(log['id'], user, pregnancyState);
              },
            ),
          ],
        ),
      ],
    ),
  );
}


  void confirmDeleteLog(
      int logId, Users user, PregnancyState pregnancyState) async {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Delete Log'),
            content: const Text('Are you sure you want to delete this log?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  PregnancyController pregnancyController =
                      PregnancyController();
                  Map<String, dynamic> resp = await pregnancyController
                      .deletePregnancyLog(logId, user, pregnancyState);

                  Navigator.of(context).pop();
                  if (resp['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(resp['message']),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(resp['message']),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Delete"),
              ),
            ],
          );
        },
      ),
    );
  }

  String formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}";
  }
}

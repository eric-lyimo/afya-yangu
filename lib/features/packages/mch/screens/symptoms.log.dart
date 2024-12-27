import 'package:flutter/material.dart';


class SymptomLoggerScreen extends StatefulWidget {
  const SymptomLoggerScreen({super.key});

  @override
  _SymptomLoggerScreenState createState() => _SymptomLoggerScreenState();
}

class _SymptomLoggerScreenState extends State<SymptomLoggerScreen> {
  final Map<String, bool> selectedSymptoms = {};

  final Map<String, List<Map<String, dynamic>>> symptoms = {
    "General Symptoms": [
      {"label": "Everything is fine", "emoji": "😊"},
      {"label": "Cramps", "emoji": "😖"},
      {"label": "Tender breasts", "emoji": "🤱"},
      {"label": "Headache", "emoji": "🤕"},
      {"label": "Acne", "emoji": "🌼"},
      {"label": "Backache", "emoji": "💆‍♀️"},
    ],
    "Mood": [
      {"label": "Calm", "emoji": "🌊"},
      {"label": "Happy", "emoji": "😊"},
      {"label": "Energetic", "emoji": "⚡"},
      {"label": "Irritated", "emoji": "😡"},
      {"label": "Sad", "emoji": "😢"},
      {"label": "Anxious", "emoji": "😰"},
      {"label": "Depressed", "emoji": "🌧️"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9, 
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: symptoms.entries.map((category) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              category.key,
                              style:  TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 3.0,
                            ),
                            itemCount: category.value.length,
                            itemBuilder: (context, index) {
                              final symptom = category.value[index];
                              final label = symptom["label"];
                              final emoji = symptom["emoji"];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSymptoms[label] =
                                        !(selectedSymptoms[label] ?? false);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedSymptoms[label] ?? false
                                        ? Colors.pink[100]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          label,
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saveSymptoms,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Symptoms"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Theme.of(context).primaryColorDark,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
      },
    );
  }

  void _saveSymptoms() {
    final selected = selectedSymptoms.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Selected Symptoms"),
          content: Text(
            selected.isNotEmpty
                ? selected.join(", ")
                : "No symptoms selected.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

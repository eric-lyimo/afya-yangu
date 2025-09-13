import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/controller/pregnancy.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancies.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancy.logs.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';

class SymptomLoggerScreen extends StatefulWidget {
  const SymptomLoggerScreen({super.key});

  @override
  _SymptomLoggerScreenState createState() => _SymptomLoggerScreenState();
}

class _SymptomLoggerScreenState extends State<SymptomLoggerScreen> {
final Map<String, bool> selectedSymptoms = {};

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
    commentController.dispose();
    super.dispose();
  }

PregnancyLogs? pregnancyLog;
Pregnancies? preg;
Users? user;
PregnancyState? pregnancyState;
bool isLoading = false; // Tracks loading state

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  // Fetch the current pregnancy state and user state from the provider
  preg = Provider.of<PregnancyState>(context, listen: false).pregnancy;
  pregnancyState = context.read<PregnancyState>();
  user = Provider.of<UserState>(context, listen: false).user;

  // Initialize the PregnancyLogs object if not already initialized
  if (preg != null && pregnancyLog == null) {
    setState(() {
      pregnancyLog = PregnancyLogs(
        id: null,
        pregnancyId: preg!.id,
        exercise: null,
        mood: null,
        appetite: null,
        vaginalDischarge: null,
        comment: null,
        activities: null,
        swelling: null,
        symptoms: null,
        stool: null,
      );
    });
  }

}


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
      maxChildSize: 0.95,
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8, // Horizontal spacing between chips
                          runSpacing: 8, // Vertical spacing between chips
                          children: [
                            // Generate symptom chips
                            ...category.value.map((symptom) {
                              final label = symptom["label"];
                              final emoji = symptom["emoji"];
                              return ChoiceChip(
                                avatar: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                label: Text(label),
                                selected: selectedSymptoms[label] ?? false,
                                onSelected: (isSelected) {
                                  setState(() {
                                    selectedSymptoms[label] = isSelected;
                                    _updatePregnancyLog(category.key, label);
                                  });
                                },
                                selectedColor: Colors.pinkAccent.shade100,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),
            // Input chip for adding a comment
            InputChip(
              avatar: const Icon(Icons.comment, size: 18),
              label: const Text("Add a comment"),
              onPressed: () async {
                final comment = await _showCommentDialog();
                if (comment != null && comment.isNotEmpty) {
                  setState(() {
                    commentController.text = comment;
                    pregnancyLog = pregnancyLog!.copyWith(comment: comment);
                  });
                }
              },
              backgroundColor: Colors.white,
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            // Display the added comment
            if (pregnancyLog?.comment != null && pregnancyLog!.comment!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pregnancyLog!.comment!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          pregnancyLog = pregnancyLog!.copyWith(comment: null);
                        });
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : (preg != null && pregnancyLog != null
                        ? _savePregnancyLog
                        : null),
                icon: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(isLoading ? "Saving..." : "Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _showCommentDialog() async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add a Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: "Enter your comment here"),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final comment = commentController.text;
              Navigator.pop(context, comment);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}


  void _updatePregnancyLog(String category, String label) {
    if (pregnancyLog == null) return;

    setState(() {
      switch (category) {
        case "Mood":
          pregnancyLog = pregnancyLog!.copyWith(mood: label);
          break;
        case "General Symptoms":
          final updatedSymptoms =
              (pregnancyLog!.symptoms?.split(", ") ?? [])..add(label);
          pregnancyLog = pregnancyLog!.copyWith(
            symptoms: updatedSymptoms.join(", "),
          );
          break;
        default:
          break;
      }
    });
  }

Future<void> _savePregnancyLog() async {
    if (pregnancyLog == null || preg == null) return;

    setState(() {
      isLoading = true;
    });

    try {
     final resp = await PregnancyController().createPregnancyLogs(pregnancyLog!, user!, pregnancyState!);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();

      if (resp['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pregnancy Log Saved Successfully!"),
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

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving Pregnancy Log: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

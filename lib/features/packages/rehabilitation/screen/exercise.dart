import 'package:flutter/material.dart';
import 'dart:async';

class ExercisePlan {
  String exerciseName;
  int countsPerSets;
  String howTo;
  int sets;
  String status; // 'pending', 'completed', 'ongoing'

  ExercisePlan({
    required this.exerciseName,
    required this.countsPerSets,
    required this.howTo,
    required this.sets,
    this.status = 'pending',
  });
}

class ExercisesTab extends StatefulWidget {
  const ExercisesTab({super.key});

  @override
  _ExercisesTabState createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<ExercisesTab> {
  List<ExercisePlan> exercises = [
    ExercisePlan(
      exerciseName: "Arm Stretching",
      countsPerSets: 10,
      howTo: "Lift your arms overhead and stretch for 10 seconds.",
      sets: 3,
    ),
    ExercisePlan(
      exerciseName: "Leg Raises",
      countsPerSets: 15,
      howTo: "Lift your legs alternately and hold for 5 seconds.",
      sets: 2,
    ),
  ];

  Map<String, String> feedback = {};
  Map<String, int> progress = {};
  late Timer _timer;
  bool _isRunning = false;
  Duration elapsed = Duration.zero;
  String currentExercise = '';
  int currentSet = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startExercise(ExercisePlan exercise) {
    setState(() {
      currentExercise = exercise.exerciseName;
      currentSet = 1;
      elapsed = Duration.zero;
      _isRunning = true;
      exercise.status = 'ongoing';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsed += const Duration(seconds: 1);
      });
    });
  }

  void _finishExercise(ExercisePlan exercise) {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      exercise.status = 'completed';
    });
    _showFeedbackSheet(exercise);
  }

  void _nextSet(ExercisePlan exercise) {
    if (currentSet < exercise.sets) {
      setState(() {
        currentSet++;
        elapsed = Duration.zero; // Reset elapsed time for the next set.
      });
    } else {
      _finishExercise(exercise);
    }
  }

  void _showExerciseDetail(ExercisePlan exercise) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      exercise.exerciseName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Visual Guide (Placeholder for video or animation)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 100,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Exercise Instructions
                  const Text(
                    "How to Perform:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exercise.howTo,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Timer and Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sets: $currentSet/${exercise.sets}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Elapsed Time: ${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      CircularProgressIndicator(
                        value: currentSet / exercise.sets,
                        backgroundColor: Colors.grey[200],
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Start and Finish Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: !_isRunning ? () => _startExercise(exercise) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(120, 50),
                        ),
                        child: const Text("Start"),
                      ),
                      ElevatedButton(
                        onPressed: _isRunning
                            ? () => _nextSet(exercise)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(120, 50),
                        ),
                        child: Text(currentSet < exercise.sets ? "Next Set" : "Finish"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFeedbackSheet(ExercisePlan exercise) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Feedback for ${exercise.exerciseName}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("How did you feel during the exercise?"),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    feedback[exercise.exerciseName] = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Feedback",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                child: const Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.fitness_center, color: Colors.blueAccent),
              title: Text(
                exercise.exerciseName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Sets: ${exercise.sets} | Status: ${exercise.status}'),
              onTap: () => _showExerciseDetail(exercise),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/packages/rehabilitation/screen/rehabilitation.package.dart';

class AssessmentResultScreen extends StatelessWidget {
  final Map<int, dynamic> responses;
  final int score;

  const AssessmentResultScreen({super.key, required this.responses, required this.score});

  String _generateRecommendation() {
    if (score <= 3) {
      return "You appear to be in good condition. Keep maintaining a healthy lifestyle. Keep up the good work!";
    } else if (score <= 6) {
      return "You might need mild rehabilitation support. Consider starting light exercises to improve your condition.";
    } else {
      return "It is recommended to follow a structured rehabilitation program. A more tailored treatment plan will help improve your condition.";
    }
  }

  String _generateTreatmentPlan() {
    if (responses.containsValue('Yes') && responses.containsKey(3)) {
      // If previous medical conditions are present, provide additional recommendations
      return "Based on your medical history, a more personalized treatment plan will be developed. Please consult with a specialist.";
    }
    return "You can proceed with the general rehabilitation plan, but regular check-ups are recommended.";
  }

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: '',
      subtitle: '',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Your Self-Assessment Results",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),

            // Display responses in a more stylish manner
            ...responses.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.question_answer, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Q${entry.key + 1}: ${entry.value}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Score visualization
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Score: $score",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: score / 12, // Assuming the max score is 12
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This is an overview of your self-assessment score. A higher score indicates a greater need for rehabilitation support.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recommendation Section
            const Text(
              "Recommendation:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _generateRecommendation(),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Treatment Plan Section
            const Text(
              "Customized Treatment Plan:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _generateTreatmentPlan(),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            // Continue Button
            ElevatedButton(
              onPressed: () {
                // Navigate to rehabilitation screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RehabilitativeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Subscribe to Rehabilitation Services"),
            ),
          ],
        ),
      ),
    );
  }
}


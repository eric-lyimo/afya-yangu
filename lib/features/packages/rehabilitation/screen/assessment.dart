import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/packages/rehabilitation/screen/assesment.result.dart';

class SelfAssessmentScreen extends StatefulWidget {
  const SelfAssessmentScreen({super.key});

  @override
  _SelfAssessmentScreenState createState() => _SelfAssessmentScreenState();
}

class _SelfAssessmentScreenState extends State<SelfAssessmentScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Do you experience any pain while performing daily activities?',
      'options': ['No Pain', 'Mild Pain', 'Moderate Pain', 'Severe Pain'],
      'weight': [0, 1, 2, 3],
    },
    {
      'question': 'How often do you feel fatigued during the day?',
      'options': ['Rarely', 'Sometimes', 'Often', 'Always'],
      'weight': [0, 1, 2, 3],
    },
    {
      'question': 'Can you walk unassisted for more than 10 minutes?',
      'options': ['Yes', 'No'],
      'weight': [0, 3],
    },
    {
      'question': 'Do you have any previous medical conditions (e.g., hypertension, diabetes)?',
      'options': ['Yes', 'No'],
      'weight': [1, 0],
      'inputField': true, // This indicates an open-ended question for input
    },
    {
      'question': 'What types of exercises do you prefer for rehabilitation?',
      'options': ['Cardio', 'Strength Training', 'Yoga', 'Other'],
      'weight': [0, 1, 2, 1],
    },
    {
      'question': 'Do you prefer a structured rehabilitation plan or flexible exercise routines?',
      'options': ['Structured', 'Flexible'],
      'weight': [0, 2],
    },
  ];

  int _currentQuestionIndex = 0;
  final Map<int, dynamic> _responses = {}; // Map to store responses
  int _score = 0;
  final TextEditingController _textController = TextEditingController();

void _nextQuestion(dynamic response) {
  setState(() {
    // Find the index of the selected option
    int selectedOptionIndex = _questions[_currentQuestionIndex]['options']?.indexOf(response) ?? -1;

    // Check if the index is valid (not -1)
    if (selectedOptionIndex != -1) {
      // Ensure that the weight list exists before accessing it
      List<int>? weightList = _questions[_currentQuestionIndex]['weight'];
      if (weightList != null && selectedOptionIndex < weightList.length) {
        _score += weightList[selectedOptionIndex];
        _responses[_currentQuestionIndex] = response;
      }
    }

    // Move to the next question or submit the assessment
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _submitAssessment();
    }
  });
}

  void _submitAssessment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssessmentResultScreen(
          responses: _responses,
          score: _score,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return AfyaLayout(
      title: 'Self Assesment',
      subtitle: '',
     body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              "Question ${_currentQuestionIndex + 1}/${_questions.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Handle conditional rendering of input field or options
            question['inputField'] == true
                ? TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: "Please describe your condition",
                    ),
                    onChanged: (value) {
                      // Update the response on text change
                      _responses[_currentQuestionIndex] = value;
                    },
                    onSubmitted: (value) {
                      // When the user submits the input (presses "done" on the keyboard)
                      _nextQuestion(value);
                    },
                  )
                : Column(
                    children: question['options'].map<Widget>((option) {
                      return ListTile(
                        title: Text(option),
                        leading: Radio(
                          value: option,
                          groupValue: _responses[_currentQuestionIndex],
                          onChanged: (value) {
                            _nextQuestion(value!);
                          },
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}



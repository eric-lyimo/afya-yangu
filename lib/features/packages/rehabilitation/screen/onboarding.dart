import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/packages/rehabilitation/screen/assessment.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: "Rehabilitation",
      subtitle:'',
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Welcome to the Rehabilitation Services",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
        
                // Description Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Achieve your recovery goals with guided exercises, progress tracking, and compliance checks. Our services are based on international rehabilitation standards, ensuring a tailored approach to your rehabilitation journey.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
        
                // Key Features Section
                Column(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.fitness_center,
                      title: "Guided Exercises",
                      description:
                          "Access a variety of rehabilitation exercises designed to help you recover effectively and efficiently.",
                    ),
                    _buildFeatureCard(
                      icon: Icons.timeline,
                      title: "Progress Tracking",
                      description:
                          "Track your progress over time and stay motivated with regular updates on your recovery.",
                    ),
                    _buildFeatureCard(
                      icon: Icons.check_circle_outline,
                      title: "Compliance Monitoring",
                      description:
                          "Ensure adherence to your rehabilitation plan with reminders and goal-checking features.",
                    ),
                  ],
                ),
                const SizedBox(height: 40),
        
                // Get Started Button
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelfAssessmentScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ),
      );
  }

  // Custom Feature Card Widget
  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

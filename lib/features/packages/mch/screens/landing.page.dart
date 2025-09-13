import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/subscription.mch.dart';

class MaternalChildHealthLanding extends StatelessWidget {
  const MaternalChildHealthLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: "Maternal Health",
      subtitle: "",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Text(
              "Welcome to Maternal & Child Health",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Empower yourself with tools and resources to support your maternal journey. Here's what we offer:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Feature Highlights
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.heart,
              title: "Pregnancy Tracker",
              description: "Monitor your baby's development weekly.",
            ),
            const SizedBox(height: 15),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.child,
              title: "Baby Arrival Prep",
              description: "Prepare with expert tips and essential resources.",
            ),
            const SizedBox(height: 15),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.book,
              title: "Educational Resources",
              description: "Access curated learning materials for parenting and pregnancy.",
            ),
            const Spacer(),

            // Subscription Section
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MaternalChildHealthSubscription(),
                    ),
                  );
                },
                icon: const Icon(FontAwesomeIcons.arrowRight, color: Colors.white),
                label: const Text(
                  "Subscribe Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Feature Highlight Widget
  Widget _buildFeatureHighlight(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
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

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const AfyaLayout(
      title: 'Privacy Policy',
      subtitle: '',
      body:  PrivacyPolicyContent(),
    );
  }
}

class PrivacyPolicyContent extends StatefulWidget {
  const PrivacyPolicyContent({super.key});

  @override
  _PrivacyPolicyContentState createState() => _PrivacyPolicyContentState();
}

class _PrivacyPolicyContentState extends State<PrivacyPolicyContent> {
  final _searchController = TextEditingController();
  String _searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchTerm = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: "Search policy...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // Scrollable Policy Content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: _highlightSearchTerm(_policyText(), _searchTerm),
                ),
              ),
            ),
          ),
        ),
        // Accept Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the screen or navigate to the next step
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            ),
            child: const Text("Accept"),
          ),
        ),
      ],
    );
  }

  // Function to highlight search terms
  List<TextSpan> _highlightSearchTerm(String text, String term) {
    if (term.isEmpty) return [TextSpan(text: text)];
    final splitText = text.toLowerCase().split(term);
    final highlightedSpans = <TextSpan>[];

    for (int i = 0; i < splitText.length; i++) {
      if (i > 0) {
        highlightedSpans.add(TextSpan(
          text: text.substring(
              text.toLowerCase().indexOf(term), text.toLowerCase().indexOf(term) + term.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ));
      }
      highlightedSpans.add(TextSpan(text: splitText[i]));
    }

    return highlightedSpans;
  }

  // Privacy Policy Text
  String _policyText() {
    return """
At Mount Meru Hospital, we are committed to safeguarding your personal data and respecting your privacy. This Privacy Policy outlines how we collect, use, and protect your information when you use our mobile application.

1. **Data Collection**:
   - We collect personal information such as your name, contact details, and medical history when you register or use the app.
   - Usage data, including app activity and preferences, may also be collected to improve the app experience.

2. **Data Usage**:
   - Your information is used to provide personalized healthcare services and enhance app functionality.
   - We may share your data with authorized healthcare providers only when necessary for treatment or diagnosis.

3. **Data Protection**:
   - We employ industry-standard encryption and security measures to protect your data from unauthorized access.
   - Access to your personal data is restricted to authorized personnel only.

4. **User Rights**:
   - You have the right to access, update, or delete your personal data. Contact us at privacy@mountmeruhospital.com for assistance.
   - You can opt out of data usage for analytics or marketing at any time through the app settings.

5. **Third-party Services**:
   - We may use third-party tools for analytics, which adhere to strict data privacy standards.
   - No personal health information is shared with third-party advertisers.

6. **Children’s Privacy**:
   - Our app is not intended for children under the age of 13 without parental consent.

7. **Policy Updates**:
   - This Privacy Policy may be updated periodically. Notifications will be sent for significant changes.

For any concerns or inquiries about your privacy, contact us at privacy@mountmeruhospital.com.
    """;
  }
}

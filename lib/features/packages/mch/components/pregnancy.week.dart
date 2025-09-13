import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PregnancyWeekModal extends StatefulWidget {
  final Map<String, dynamic> weekDetails;

  const PregnancyWeekModal({super.key, required this.weekDetails});

  @override
  State<PregnancyWeekModal> createState() => _PregnancyWeekModalState();
}

class _PregnancyWeekModalState extends State<PregnancyWeekModal> {

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 243, 245, 249),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child:SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Week ${widget.weekDetails['week']}",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: "Mother's Body",
                  content: widget.weekDetails['maternalHealth'] ?? '',
                  icon: Icons.pregnant_woman,
                  color: Colors.pink,
                ),
                _buildDivider(),
                _buildSection(
                  context,
                  title: "Possible Symptoms",
                  content: widget.weekDetails['symptoms'] ?? '',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                _buildDivider(),
                _buildSection(
                  context,
                  title: "Tips",
                  content: widget.weekDetails['tips'] ?? '',
                  icon: Icons.lightbulb,
                  color: Colors.teal,
                ),
                _buildDivider(),
                _buildSection(
                  context,
                  title: "Dietary Advice",
                  content: widget.weekDetails['dietaryAdvice']?? '',
                  icon: Icons.restaurant,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(230),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: HtmlWidget(
            content,
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}

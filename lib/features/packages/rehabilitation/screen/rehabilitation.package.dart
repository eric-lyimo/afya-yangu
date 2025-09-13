
import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/packages/rehabilitation/screen/consultations.dart';
import 'package:mtmeru_afya_yangu/features/packages/rehabilitation/screen/exercise.dart';

class RehabilitativeScreen extends StatefulWidget {
  const RehabilitativeScreen({super.key});

  @override
  _RehabilitativeScreenState createState() => _RehabilitativeScreenState();
}

class _RehabilitativeScreenState extends State<RehabilitativeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
         flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft
                )  
            ),
          ),
        backgroundColor: Colors.blue,
        title: const Text('Rehabilitative Services', style: TextStyle(fontSize: 24)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center, size: 30), text: 'Exercises & Plans'),
            Tab(icon: Icon(Icons.book, size: 30), text: 'Educational Resources'),
            Tab(icon: Icon(Icons.calendar_today, size: 30), text: 'Consultations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ExercisesTab(),
          EducationalResourcesTab(),
          ConsultationsTab(),
        ],
      ),
    );
  }
}




class EducationalResourcesTab extends StatelessWidget {
  const EducationalResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildResourceCard(context, "Understanding Rehabilitation: Article 1", "Learn about basic rehabilitation techniques."),
          _buildResourceCard(context, "Exercise Techniques: Video 1", "Watch the video to improve your rehabilitation exercises."),
          _buildResourceCard(context, "Pain Management Strategies: Article 2", "How to manage pain during rehabilitation."),
        ],
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, String title, String subtitle) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () => _showContentDetail(context, title),
      ),
    );
  }

  void _showContentDetail(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Content Detail"),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}



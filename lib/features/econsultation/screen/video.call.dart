import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/appointments/controllers/appointment.controller.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/services/econsultation.service.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';

class VideoConsultationDashboard extends StatefulWidget {
  const VideoConsultationDashboard({super.key});

  @override
  State<VideoConsultationDashboard> createState() => _VideoConsultationDashboardState();
}

class _VideoConsultationDashboardState extends State<VideoConsultationDashboard> {
  final AppointmentController appointmentController = AppointmentController();
  final bool audioMuted = true;
  final bool videoMuted = true;
  final bool screenShareOn = false;
  final videoService = VideoConsultationService();

  List<Map<String, dynamic>> consultation = [];

  @override
  void initState() {
    super.initState();
    _loadConsultations();
  }

  void _loadConsultations() async {
    final user = Provider.of<UserState>(context, listen: false).user;
    final result = await appointmentController.fetchConsultations(user!.token);
    setState(() {
      consultation = result.cast<Map<String, dynamic>>();
    });
  }

bool isJoinable(String timeString) {
  try {
    // Parse UTC datetime from API
    DateTime consultationTime = DateTime.parse(timeString).toLocal();
  print(consultationTime);
    // Compare to local time
    return consultationTime.isBefore(DateTime.now());
  } catch (e) {

    return false;
  }
}

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }



  Widget buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required bool joinable,
    required String roomId,
    Color? statusColor,
    VoidCallback? onJoin,
    required String name,
  }) {
    return Card(

      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor ?? Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            // Join Button
            if (joinable)
              ElevatedButton(
                onPressed: () => videoService.join(roomId,name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Join Now",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<UserState>(context).user!;
    return AfyaLayout(
      title: "Video Consultation",
      subtitle: "",
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Text(
                "${getGreeting()}!",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Welcome to your video consultation dashboard.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Upcoming Consultations Section
              const Divider(),
              Text(
                "Upcoming Consultations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 10),
              ...consultation.map(
                (consultation) {
                        
                  final joinable = isJoinable(consultation["time"]);
                  print(joinable);
                  return buildCard(
                    name: user.name,
                    context: context,
                    icon: Icons.calendar_today,
                    title: consultation["doctor"]['name'],
                    subtitle: "Date: ${consultation["time"]}",
                    status: consultation["status"],
                    joinable: joinable,
                    roomId: consultation["link"],
                    statusColor: joinable ? Colors.green : Colors.orange,
                    onJoin: joinable
                        ? () =>videoService.join(consultation["link"], user.name)
                        : null,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Previous Consultations Section
              const Divider(),
              Text(
                "Previous Consultations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

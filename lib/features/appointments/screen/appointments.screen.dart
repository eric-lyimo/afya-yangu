import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/appointments/controllers/appointment.controller.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/clinic.booking.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/doctors.list.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/video.booking.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart'; // or Riverpod/any state mgmt

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final controller = AppointmentController();
  late Future<List<Map<String, dynamic>>> doctorFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserState>(context).user; // Adjust if using Riverpod or custom logic
    doctorFuture = controller.fetchAvailableDoctors(user!.token);
  }

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: "Appointments",
      subtitle: "",
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).primaryColorDark,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(icon: Icon(FontAwesomeIcons.userDoctor), text: "Book a Doctor"),
                  Tab(icon: Icon(FontAwesomeIcons.hospital), text: "Book Clinic"),
                  Tab(icon: Icon(FontAwesomeIcons.video), text: "Video Consultation"),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: doctorFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final doctors = snapshot.data!;
                      return TabBarView(
                        children: <Widget>[
                          AfyaBooking(doctors: doctors),
                          const AfyaClinicBooking(),
                          VideoBooking(doctors: doctors),
                        ],
                      );
                    } else {
                      return const Center(child: Text("No available doctors found"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

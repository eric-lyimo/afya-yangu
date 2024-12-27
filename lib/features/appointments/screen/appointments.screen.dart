import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/clinic.booking.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/doctors.list.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchData() async {
    final url = Uri.parse('http://192.168.21.114/mtmerurrh/api/doctors'); // Replace with your machine's IP

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successful response
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return [];
    }
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
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final doctors = snapshot.data!;
                      return TabBarView(
                        children: <Widget>[
                          AfyaBooking(doctors: doctors),
                          const AfyaClinicBooking(),
                          const Icon(Icons.directions_transit),
                        ],
                      );
                    } else {
                      return const Center(child: Text("No data available"));
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

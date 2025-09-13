import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/appointments/controllers/appointment.controller.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';

class DoctorBookingForm extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final Users user;

  const DoctorBookingForm({super.key, required this.doctor, required this.user});

  @override
  State<DoctorBookingForm> createState() => _DoctorBookingFormState();
}

class _DoctorBookingFormState extends State<DoctorBookingForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final appointmentController = AppointmentController();


  String getRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

booknow(DateTime time, BuildContext context) async {
  final result = await appointmentController.createBooking(
    type: 'virtual',
    status: 'created',
    doctorId: widget.doctor['id'],
    clinicId: 0,
    userId: widget.user.userId,
    token: widget.user.token,
    link: getRandomString(10),
    time: time,
  );

  // Close all bottom sheets if open
  while (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }

  // Show snackbar with result
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result['success']
            ? 'Booking created successfully!'
            : 'Error: ${result['error'] ?? 'Something went wrong'}',
      ),
      backgroundColor: result['success'] ? Colors.green : Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        children: [
          Text(
            'Book Appointment with Dr. ${widget.doctor['name']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text(selectedDate == null
                ? "Pick a date"
                : "${selectedDate!.toLocal()}".split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => selectedDate = date);
            },
          ),
          ListTile(
            title: Text(selectedTime == null
                ? "Pick a time"
                : selectedTime!.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) setState(() => selectedTime = time);
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("Confirm Booking"),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    selectedDate != null &&
                    selectedTime != null) {
                  final dateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  booknow(
                    dateTime,context
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

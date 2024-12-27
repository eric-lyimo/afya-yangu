import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/appointments/components/clinic.step.dart';
import 'package:mtmeru_afya_yangu/features/appointments/components/confirm.step.dart';
import 'package:mtmeru_afya_yangu/features/appointments/components/day.step.dart';
import 'package:mtmeru_afya_yangu/features/appointments/components/form.dart';

class AfyaClinicBooking extends StatefulWidget {
  const AfyaClinicBooking({super.key});

  @override
  _BookingStepperState createState() => _BookingStepperState();
}

class _BookingStepperState extends State<AfyaClinicBooking> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Final step completed, submit form
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully!')),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        steps: [
          Step(
            title: const Text('Clinic'),
            content: const AfyaClinics(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Day'),
            content: const AfyaClinicDays(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Details'),
            content: const AfyaBookingForm(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Confirm'),
            content: const AfyaClinicConfirmation(),
            isActive: _currentStep >= 3,
            state: _currentStep == 3 ? StepState.editing : StepState.indexed,
          ),
        ],
      );
  }
}
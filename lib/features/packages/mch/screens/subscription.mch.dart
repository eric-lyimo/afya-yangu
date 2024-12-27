import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/packages/controller/subscription.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/controller/pregnancy.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/mch.dart';
import 'package:mtmeru_afya_yangu/features/packages/model/subscriptions.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MaternalChildHealthSubscription extends StatelessWidget {
  const MaternalChildHealthSubscription({super.key});

  @override
  Widget build(BuildContext context) {

    
    final pregnancyState = Provider.of<PregnancyState>(context);
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
        var user = context.watch<UserProvider>().user;

    return AfyaLayout(
      title: 'Subscription',
      subtitle: '',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child:  const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Your Pregnancy Journey",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Track your pregnancy by estimating your due date and current pregnancy week based on your Last Menstrual Period (LMP) and cycle length.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // LMP Picker
              const Text(
                "Last Menstrual Period (LMP):",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          pregnancyState.setLMP(pickedDate);
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        pregnancyState.selectedLMP == null
                            ? "Select Date"
                            : dateFormatter.format(pregnancyState.selectedLMP!),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cycle Length Slider
              const Text(
                "Cycle Length (in days):",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: pregnancyState.cycleLength.toDouble(),
                      min: 20,
                      max: 45,
                      divisions: 25,
                      label: "${pregnancyState.cycleLength} days",
                      onChanged: (value) {
                        pregnancyState.setCycleLength(value.toInt());
                      },
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.pink[100],
                    ),
                  ),
                  Text(
                    "${pregnancyState.cycleLength} days",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Results Section
              if (pregnancyState.dueDate.isNotEmpty) ...[
                const Text(
                  "Expected Delivery Date (EDD):",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.event, color: Colors.pinkAccent),
                    const SizedBox(width: 10),
                    Text(
                      pregnancyState.dueDate,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              if (pregnancyState.pregnancyWeek.isNotEmpty) ...[
                const Text(
                  "Current Pregnancy Week:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.pregnant_woman, color: Colors.pinkAccent),
                    const SizedBox(width: 10),
                    Text(
                      pregnancyState.pregnancyWeek,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ],
              const Divider(height: 40, thickness: 1),

              // Start My Journey Button
              Center(
                child: ElevatedButton(
                  onPressed:(){
                      Map<String , dynamic> preg = {'userId': user?.userId,  'edd': pregnancyState.dueDate,  'lmp': pregnancyState.selectedLMP.toString(),  'cycle': pregnancyState.cycleLength.toDouble() };
                        _savePregnancy(context, preg, user!);
                  } ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    shadowColor: Colors.pinkAccent.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Start My Journey",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  _savePregnancy(BuildContext context, Map<String,dynamic> preg, Users user) async{

  int resp = await  PregnancyController().insertPregnancy(preg);

  if (resp > 1) {
      Subscriptions sub = Subscriptions(packageId: 0, date: "12/1/2024", userId: user.userId, validity: "1/12/2024");

      Map<String, dynamic>? subs = await PackagesController().insertSubscription(sub.toMap());
      print(subs);
      Navigator.push(context,MaterialPageRoute(builder: (context) => const MaternalChildHealthScreen()));
  } else {
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed")),
      );
  }
  }
}

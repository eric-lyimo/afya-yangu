import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';

class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AfyaLayout(
      body: 
        Center(child: Text("Health Records Screen")), 
        title: '', 
        subtitle: '',
    );

  }
}
import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AfyaLayout(
      body: 
        Center(child: Text("Settings")), 
        title: '', 
        subtitle: '',
    );

  }
}

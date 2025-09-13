import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/nav.bar.dart';
import 'package:mtmeru_afya_yangu/providers/cart.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mtmeru_afya_yangu/features/appointments/screen/appointments.screen.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/Login.screen.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/onboarding.screen.dart';
import 'package:mtmeru_afya_yangu/features/home/screen/home.screen.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/medication.screen.dart';
import 'package:mtmeru_afya_yangu/features/misc/screen/misc.screen.dart';
import 'package:mtmeru_afya_yangu/features/records/screen/emr.screen.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:mtmeru_afya_yangu/utils/theme/theme.dart';

void main() async {
    HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isRemembered = prefs.getBool('rememberMe') ?? false;

  // Initialize UserProvider and load user from the database
  final userProvider = UserState();
  
  runApp(
    MultiProvider(
      providers: [      
      ChangeNotifierProvider(create: (_) => userProvider),  // Providing UserState
      ChangeNotifierProvider(create: (_) => PregnancyState(userProvider)), 
      ChangeNotifierProvider(create: (_) => CartProvider()),  // Providing CartProvider
      ],
      child: AfyaYangu(isRemembered: isRemembered),
    ),
  );
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AfyaYangu extends StatelessWidget {
  final bool isRemembered;

  const AfyaYangu({
    super.key,
    required this.isRemembered,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserState>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboarding': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Home(),
        '/medication': (context) => const MedicationScreen(),
        '/records': (context) => const HealthRecordsScreen(),
        '/more': (context) => const MoreScreen(),
        '/booking': (context) => const AppointmentsScreen(),
      },
      themeMode: ThemeMode.system,
      theme: afyaYanguTheme(),
      home: Scaffold(
        body:Container(
            color: const Color(0x00fff8e7),
            child: _determineInitialScreen(userProvider, isRemembered),
          ),
        ),
    );
  }

  Widget _determineInitialScreen(UserState userProvider, bool isRemembered) {
    if (userProvider.user != null) {
      // If the user is loaded from the database
      return  AfyaBottomNavBar();
    } else if (isRemembered) {
      // If the user is remembered but not found in the database (edge case)
      return const LoginScreen();
    } else {
      // Default to Welcome Screen for new users
      return const WelcomeScreen();
    }
  }
}

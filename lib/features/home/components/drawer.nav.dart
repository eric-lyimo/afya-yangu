import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/Bills/screen/bills.payments.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/appointments.screen.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/Login.screen.dart';
import 'package:mtmeru_afya_yangu/features/settings/components/basic.information.dart';
import 'package:mtmeru_afya_yangu/features/settings/components/contact.info.dart';
import 'package:mtmeru_afya_yangu/features/settings/components/family.props.dart';
import 'package:mtmeru_afya_yangu/features/home/screen/home.screen.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/medical.conditions.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/medication.screen.dart';
import 'package:mtmeru_afya_yangu/features/policy/screen/privacy.policy.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AfyaDrawer extends StatefulWidget {
  const AfyaDrawer({super.key});

  @override
  State<AfyaDrawer> createState() => _AfyaDrawerState();
}

class _AfyaDrawerState extends State<AfyaDrawer> {
  void _logout(BuildContext context) async {
    try {
      // Clear "Remember Me" flag from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', false);

      // Optionally, clear other shared preferences if needed
      await prefs.remove('username');
      await prefs.remove('password');

      // Clear user data in the provider
      Provider.of<UserProvider>(context, listen: false).logout();

      // Navigate to the login screen, clearing the navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Handle exceptions gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during logout: $e")),
      );
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': FontAwesomeIcons.gauge,
      'text': 'Dashboard',
      'page':  const Home(),
      'subItems': null, // No sub-items
    },
    {
      'icon': FontAwesomeIcons.user,
      'text': 'Profile',
      'subItems': [
        {'text': 'Basic Information', 'page': const BasicInfo(), 'icon': FontAwesomeIcons.idBadge},
        {'text': 'Contact Information', 'page': const ContactInformationPage(), 'icon': FontAwesomeIcons.addressBook},
        {'text': 'Family Profiles', 'page': const FamilyMember(), 'icon': FontAwesomeIcons.peopleRoof},
      ],
    },
    {
      'icon': FontAwesomeIcons.calendarDays,
      'text': 'Appointments',
      'page': const AppointmentsScreen(),
      'subItems': null, // No sub-items
    },
    {
      'icon': FontAwesomeIcons.notesMedical,
      'text': 'Medical History',
      'subItems': [
        {'text': 'Medical Conditions', 'page': const VitalSignsScreen(), 'icon': FontAwesomeIcons.disease},
        {'text': 'Medications', 'page': const MedicationScreen(), 'icon': FontAwesomeIcons.prescriptionBottleMedical},
        {'text': 'Diagnostic Investigations', 'page': const BasicInfo(), 'icon': FontAwesomeIcons.flaskVial},
      ],
    },
    {
      'icon': FontAwesomeIcons.moneyBills,
      'text': 'Bills & Payments',
      'page': const BillsAndPaymentsScreen(),
      'subItems': null, // No sub-items
    },
    {
      'icon': FontAwesomeIcons.gear,
      'text': 'Settings',
      'subItems': [
        {'text': 'Switch Profile', 'page': const BasicInfo(), 'icon': FontAwesomeIcons.repeat},
        {'text': 'Password & Security', 'page': const BasicInfo(), 'icon': FontAwesomeIcons.userShield},
        {'text': 'Preferences', 'page': const BasicInfo(), 'icon': FontAwesomeIcons.asterisk},
      ],
    },
    {
      'icon': FontAwesomeIcons.gavel,
      'text': 'Privacy policy',
      'page': const PrivacyPolicy(),
      'subItems': null, // No sub-items
    },
    {
      'icon': FontAwesomeIcons.rightFromBracket,
      'text': 'Logout',
      'onTap': '_logout', // Special case for logout
      'subItems': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserProvider>().user;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/samia.jpg'),
                    ),
                  ),
                  Text(
                    user?.name ?? 'Guest',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user?.phone ?? 'No phone Available',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          ...menuItems.map((menuItem) {
            if (menuItem['subItems'] != null) {
              // Render ExpansionTile for items with submenus
              return ExpansionTile(
                leading: FaIcon(
                  menuItem['icon'],
                  size: 30,
                ),
                title: Text(
                  menuItem['text'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: menuItem['subItems']!.map<Widget>((subItem) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListTile(
                      leading: FaIcon(
                        subItem['icon'],
                        size: 20,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      title: Text(subItem['text']),
                      onTap: () => _navigateTo(context, subItem['page']),
                    ),
                  );
                }).toList(),
              );
            } else {
              // Special case for Logout
              if (menuItem['text'] == 'Logout') {
                return ListTile(
                  leading: FaIcon(
                    menuItem['icon'],
                    size: 30,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  title: Text(
                    menuItem['text'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _logout(context),
                );
              }

              // Render ListTile for other items
              return ListTile(
                leading: FaIcon(
                  menuItem['icon'],
                  size: 30,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: Text(
                  menuItem['text'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => _navigateTo(context, menuItem['page']),
              );
            }
          }),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (builder) => page));
  }
}

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/policy/screen/privacy.policy.dart';
import 'package:mtmeru_afya_yangu/features/settings/screen/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: 'Settings',
      subtitle: '',
      body: Container(
        color: const Color(0xFF2981b3).withOpacity(0.1),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Personal Profile Section
            _buildPreferenceCard(
              context,
              icon: Icons.person,
              title: 'Personal Profile',
              description: 'View and edit, your personal details, contact, address and manage family members',
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const PersonalProfile(),
                    withNavBar: true, 
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            const SizedBox(height: 16),

            // Preferences Section
            _buildPreferenceCard(
              context,
              icon: Icons.tune,
              title: 'Preferences',
              description: 'Manage your app preferences',
              onTap: () {
                // Navigate to Preferences Screen
              },
            ),
            const SizedBox(height: 16),

            // Privacy Policy Section
            _buildPreferenceCard(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              description: 'Read about our privacy practices',
              onTap: () {
               PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const PrivacyPolicy(),
                    withNavBar: true, 
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            const SizedBox(height: 16),

            // Settings Section
            _buildPreferenceCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              description: 'Customize your app settings',
              onTap: () {
                // Navigate to Settings Screen
              },
            ),
            const SizedBox(height: 16),

            // Logout Button
            Card(
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Handle Logout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color:Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  color:Theme.of(context).primaryColorDark,
                ),
                padding: const EdgeInsets.all(12.0),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

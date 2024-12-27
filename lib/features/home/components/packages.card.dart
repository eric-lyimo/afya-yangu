import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/home/screen/home.screen.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/landing.page.dart';
import 'package:mtmeru_afya_yangu/features/packages/rehabilitation/screen/onboarding.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PackagesHorizontalScrollView extends StatelessWidget {
  const PackagesHorizontalScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        child: Column(         
              children: [
                Scrollbar(
                thickness: 6.0,
                radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(      
                        children: [
                          
                          _packageCard(
                            context,
                            title: 'General Package',
                            image: 'assets/images/general.jpg',
                             page: const Home(),
                          ),
                          _packageCard(
                            context,
                            title: 'Maternal Child Health',
                            image: 'assets/images/mch.jpg',
                            page: const MaternalChildHealthLanding(),
                          ),
                          _packageCard(
                            context,
                            title: 'Rehabilitation Package',
                            image: 'assets/images/rehab.jpg', 
                            page: const OnboardingScreen(),
                          ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
      ),
      );
  }

  void _navigateTo(BuildContext context, Widget page) {
      PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: page,
      //withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  Widget _packageCard(BuildContext context, {
    required String title, 
    required String image,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width*0.4, // Set width of each card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              _navigateTo(context,page);
            },
            borderRadius: BorderRadius.circular(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Package title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          title,
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

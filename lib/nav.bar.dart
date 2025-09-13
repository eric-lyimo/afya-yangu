import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/medication/screen/medications.dart';
import 'package:mtmeru_afya_yangu/features/settings/screen/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:mtmeru_afya_yangu/features/Bills/screen/bills.payments.dart';
import 'package:mtmeru_afya_yangu/features/appointments/screen/appointments.screen.dart';
import 'package:mtmeru_afya_yangu/features/home/screen/home.screen.dart';


class AfyaBottomNavBar extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  AfyaBottomNavBar({super.key});

  List<Widget> _buildScreens() {
    return [
      const Home(),
      const AppointmentsScreen(),
      const Medications(),
      const BillsAndPaymentsScreen(),
      const PreferencesScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(FontAwesomeIcons.calendarDays),
        title: "Appointments",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.medication),
        title: "Medications",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.payment),
        title: "Payments",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(FontAwesomeIcons.ellipsis),
        title: "More",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),

      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      
        hideNavigationBarWhenKeyboardAppears: true,
        padding: const EdgeInsets.only(top: 8),

        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings( 
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: true,
                duration: Duration(milliseconds: 200),
                screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
            ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorDark],
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        colorBehindNavBar: Colors.white,
      ),

      navBarStyle: NavBarStyle.style1, 
    );
  }
}

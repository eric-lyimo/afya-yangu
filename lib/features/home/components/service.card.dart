import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServicesScrollView extends StatelessWidget {
  const ServicesScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Scrollbar(
              thickness: 6.0,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    _serviceCard(
                      context,
                      icon: FontAwesomeIcons.userNurse,
                      title: 'Nurse at Home',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                    _serviceCard(
                      context,
                      icon: FontAwesomeIcons.userDoctor,
                      title: 'Doctor at Home',
                      iconColor: Colors.orange.shade400,
                    ),
                    _serviceCard(
                      context,
                      icon: FontAwesomeIcons.video,
                      title: 'Video Consultation',
                      iconColor: Colors.green.shade400,
                    ),
                    _serviceCard(
                      context,
                      icon: FontAwesomeIcons.pills,
                      title: 'Medication Management',
                      iconColor: Colors.purple.shade400,
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

  Widget _serviceCard(BuildContext context, {
    required IconData icon, 
    required String title, 
    Color backgroundColor = Colors.white,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        width: 120, 
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: InkWell(
            onTap: () {
              // Handle tap action
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [backgroundColor.withOpacity(0.9), backgroundColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 35, 
                    color: iconColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

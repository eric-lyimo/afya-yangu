import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';

import '../components/booking.doctor.dart';

class VideoBooking extends StatelessWidget {
    const VideoBooking({
    super.key,
    required this.doctors,
  });

  final List<Map<String, dynamic>> doctors;


  @override
  Widget build(BuildContext context) {
   final user = Provider.of<UserState>(context).user; 
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, idx) {
            var item = doctors[idx];
            return Padding(
              padding: const EdgeInsets.all(16.0), // Adding space between cards
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => showProfile(item, context, user!),
                ),
                child: Card(
                  elevation: 4, // Subtle shadow to make the card float
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  color: Colors.white, // Clean background
                  shadowColor: Colors.black26, // Softer shadow
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.4), // Subtle border around the image
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(item['avatar']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    item['specialty'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['education'],
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget showProfile(items, BuildContext context, Users user) => SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView( // This allows the content to scroll if it's too large for the screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.4),
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(items['avatar']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                items['name'] ?? 'Unknown Doctor', // Check for null and provide fallback text
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title and Speciality Section with fixed width and wrapping
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.4, // Fixed width for title
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      items['title'] ?? 'Dr.', // Ensure title is present
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      softWrap: true, // Allow text wrapping
                    
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: MediaQuery.of(context).size.width*0.4, // Fixed width for speciality
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      items['specialty'] ?? 'Specialist', // Ensure speciality is present
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      softWrap: true, // Allow text wrapping
                    
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Clinic and Department Information Section
            Text(
              'Clinic: ${items['clinic'] ?? 'Not Available'}',
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Department: ${items['dept'] ?? 'Not Available'}',
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // Working Experience Section
            if (items['experience'] != null && items['experience'].isNotEmpty)
              Text(
                'Experience: ${items['experience']}',
                style:  TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              )
            else
              Text(
                'Experience: Not Provided',
                style:  TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            const SizedBox(height: 16),

            // Profile Description Section with wrapping
            Text(
              items['bio'] ?? 'No profile description available.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
              softWrap: true, // Allow text wrapping
              overflow: TextOverflow.visible, // Truncate if too long
            ),
            const SizedBox(height: 24),

            // Book Now Button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 16,
                      right: 16,
                      top: 24,
                    ),
                    child: DoctorBookingForm(doctor: items,user: user),
                  ),
                );
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
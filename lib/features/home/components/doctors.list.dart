import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/screen/pharmact.store.dart';

class DoctorList extends StatelessWidget {
  const DoctorList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Doctors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PharmacyStoreScreen()),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // List of Doctors in a Scrollable View
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(2.0),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Doctor's Avatar (Rounded Rectangle)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12), // Rounded corners
                                child: Image.asset(
                                  doctor['image'] ?? 'assets/images/avatar.png',
                                  width: 80, // Width of the rectangle
                                  height: 100, // Height of the rectangle
                                  fit: BoxFit.cover, // Ensures the image covers the container
                                ),
                              ),
                              const SizedBox(width: 16),
                               Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doctor['specialty'] ?? 'Specialty not available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Education: ${doctor['education'] ?? 'Not available'}',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Experience: ${doctor['experience'] ?? 'N/A'} years',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 12),
                                    // Availability
                                    Text(
                                      doctor['availability'] ?? 'Availability unknown',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: doctor['availability'] == 'Available'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  }
}

// Sample doctor data
final List<Map<String, String>> doctors = [
  {
    'name': 'Dr. Jane Doe',
    'specialty': 'Cardiologist',
    'education': 'MBBS, MD (Cardiology)',
    'experience': '10',
    'availability': 'Available',
    'image': 'assets/images/samia.jpg',
  },
  {
    'name': 'Dr. John Smith',
    'specialty': 'Orthopedic Surgeon',
    'education': 'MBBS, MS (Orthopedics)',
    'experience': '8',
    'availability': 'Unavailable',
    'image': 'assets/images/samia.jpg',
  },
  {
    'name': 'Dr. Alice Brown',
    'specialty': 'Pediatrician',
    'education': 'MBBS, DCH',
    'experience': '12',
    'availability': 'Available',
    'image': 'assets/images/samia.jpg',
  },
  {
    'name': 'Dr. Robert White',
    'specialty': 'Dermatologist',
    'education': 'MBBS, MD (Dermatology)',
    'experience': '15',
    'availability': 'Unavailable',
    'image': 'assets/images/samia.jpg',
  },
];

import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/screen/pharmact.store.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "Featured Products" and View All button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>  const PharmacyStoreScreen())); 
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
          
          // Horizontal product list with Scrollbar indicator
          SizedBox(
            height: 250,
            child: Scrollbar(
              thumbVisibility: true, // Make the scrollbar always visible
              thickness: 6,  // Adjust the scrollbar thickness
              radius: const Radius.circular(10),  // Rounded scrollbar
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = featuredProducts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 8,  // Increased shadow for a more sophisticated look
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),  // Rounder corners for a smoother look
                      ),
                      child: SizedBox(
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),  // Ensures image corners match card
                              child: Image.asset(
                                product['image']!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover, // Ensures the image covers the available space
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                product['name']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,  // Handles long product names
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '\$${product['price']}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  minimumSize: const Size(double.infinity, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Add to Cart',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> featuredProducts = [
  {'name': 'Vitamin C Tablets', 'image': 'assets/images/sanitizer.jpg', 'price': '12.99'},
  {'name': 'Pain Relief Cream', 'image': 'assets/images/sanitizer.jpg', 'price': '8.49'},
  {'name': 'Cough Syrup', 'image': 'assets/images/sanitizer.jpg', 'price': '6.99'},
  {'name': 'Baby Lotion', 'image': 'assets/images/sanitizer.jpg', 'price': '5.99'},
  {'name': 'Digital Thermometer', 'image': 'assets/images/sanitizer.jpg', 'price': '15.49'},
];

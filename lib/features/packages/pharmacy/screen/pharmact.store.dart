import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/products.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/screen/orders.management.dart';
// import 'package:mtmeru_afya_yangu/features/packages/pharmacy/screen/orders.management.dart';
import 'package:mtmeru_afya_yangu/providers/cart.provider.dart';
import 'package:provider/provider.dart';

class PharmacyStoreScreen extends StatefulWidget {
  const PharmacyStoreScreen({super.key});

  @override
  _PharmacyStoreScreenState createState() => _PharmacyStoreScreenState();
}

class _PharmacyStoreScreenState extends State<PharmacyStoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        title: const Text('Pharmacy Store', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => _showCartBottomSheet(context, cartProvider),
              ),
              if (cartProvider.cartItems.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartProvider.cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: categories.map((category) => Tab(text: category['name'])).toList(),
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeaturedProducts(),
                  _buildBestSelling(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

 void _showCartBottomSheet(BuildContext context, CartProvider provider) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit height
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              // Cart List
              Column(
                children: [
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      final cart = cartProvider.cartItems;
                      return ListView.builder(
                        itemCount: cart.length,
                        shrinkWrap: true, // To allow ListView to take the needed space in the column
                        itemBuilder: (context, index) {
                          final product = cart[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    product.product.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  product.product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price: \$${product.product.price}'),
                                    Text('Quantity: ${product.quantity}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () {
                                        cartProvider.decreaseQuantity(product.product);
                                      },
                                    ),
                                    IconButton(
                                      icon:  Icon(Icons.add_circle, color: Theme.of(context).primaryColor),
                                      onPressed: () {
                                        cartProvider.addToCart(product.product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              // Total and Confirm Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cartProvider.totalPrice()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  OrderManagementScreen(cartItems: provider.cartItems, customerId: '12',)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Purchase',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}




  Widget _buildFeaturedProducts() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Featured Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            product.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${product.price}',
                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => cartProvider.addToCart(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: const Size(double.infinity, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Add to Cart', style: TextStyle(fontSize: 14)),
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
      ],
    );
  }

  Widget _buildBestSelling() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Best Sellers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bestSellers.length,
          itemBuilder: (context, index) {
            final product = bestSellers[index];
            return ListTile(
              leading: Image.asset(
                product.image,
                width: 50,
                height: 50,
              ),
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Theme.of(context).primaryColor),
                onPressed: () => cartProvider.addToCart(product),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Use your existing sample data for categories, featuredProducts, and bestSellers.


// Sample category data
final List<Map<String, String>> categories = [
  {'name': 'Vitamins & Supplements', 'image': 'assets/images/sanitizer.jpg'},
  {'name': 'Pain Relief', 'image': 'assets/images/sanitizer.jpg'},
  {'name': 'Cough & Cold', 'image': 'assets/images/sanitizer.jpg'},
  {'name': 'Skincare', 'image': 'assets/images/sanitizer.jpg'},
  {'name': 'Baby Care', 'image': 'assets/images/sanitizer.jpg'},
  {'name': 'Medical Devices', 'image': 'assets/images/sanitizer.jpg'},
];
// Sample featured product data
final List<Product> featuredProducts = [
  Product(id: '1', name: 'Vitamin C Tablets', description: 'Boost your immunity', price: 12.99, image: 'assets/images/sanitizer.jpg'),
  Product(id: '2', name: 'Pain Relief Cream', description: 'Quick relief from muscle pain', price: 8.49, image: 'assets/images/sanitizer.jpg'),
  Product(id: '3', name: 'Cough Syrup', description: 'For effective cough relief', price: 6.99, image: 'assets/images/sanitizer.jpg'),
  Product(id: '4', name: 'Baby Lotion', description: 'Gentle care for your baby\'s skin', price: 5.99, image: 'assets/images/sanitizer.jpg'),
  Product(id: '5', name: 'Digital Thermometer', description: 'Accurate temperature readings', price: 15.49, image: 'assets/images/sanitizer.jpg'),
];


// Sample best sellers data
final List<Product> bestSellers = [
  Product(id: '1', name: 'Hand Sanitizer', description: 'Keep your hands clean and safe', price: 3.99, image: 'assets/images/sanitizer.jpg'),
  Product(id: '2', name: 'Face Masks', description: 'Protect yourself with high-quality masks', price: 9.99, image: 'assets/images/sanitizer.jpg'),
  Product(id: '3', name: 'Antibiotic Cream', description: 'Heal cuts and bruises quickly', price: 7.49, image: 'assets/images/sanitizer.jpg'),
  Product(id: '4', name: 'Allergy Pills', description: 'Relieve allergy symptoms fast', price: 11.99, image: 'assets/images/sanitizer.jpg'),
  Product(id: '5', name: 'Cold Compress', description: 'For soothing pain relief', price: 6.49, image: 'assets/images/sanitizer.jpg'),
];

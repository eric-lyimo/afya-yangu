import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/cart.items.dart';
//import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/order.model.dart';
import 'package:permission_handler/permission_handler.dart';


class OrderManagementScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final String customerId;

  const OrderManagementScreen({
    super.key,
    required this.cartItems,
    required this.customerId,
  });

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  late String selectedDeliveryOption;
  late String selectedPaymentMethod;
  String? shippingAddress;
  String? currentLocationAddress;
  final TextEditingController addressController = TextEditingController();

  List<String> availableAddresses = [
    '123 Main St, City, Country',
    '456 Elm St, City, Country',
    '789 Oak St, City, Country',
  ];

  double deliveryFee = 5.0; // Default delivery fee
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedDeliveryOption = 'Home Delivery'; // Default delivery option
    selectedPaymentMethod = 'Credit Card'; // Default payment method
    _scrollController = ScrollController(); // Initialize the ScrollController
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the ScrollController
    super.dispose();
  }

  double calculateTotalAmount() {
    double total = widget.cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    return total + deliveryFee;
  }

 // This function checks location permissions and gets the current location
Future<void> _getCurrentLocation() async {
  // Request location permission
  PermissionStatus permission = await Permission.location.request();

  if (permission.isGranted) {
    try {
      // Get the current location (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition();

      // Use reverse geocoding to get a human-readable address from latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0]; // Get the first result

        // Format the address in a readable way
        String formattedAddress = '${place.name}, ${place.locality}, ${place.country}';

        setState(() {
          currentLocationAddress = formattedAddress; // Set the address to the state
        });
      } else {
        setState(() {
          currentLocationAddress = 'No address found for current location';
        });
      }
    } catch (e) {
      setState(() {
        currentLocationAddress = 'Failed to get location: $e';
      });
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location permission is required to fetch the current location.')),
    );
  }
}
  
  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      subtitle: "",
        title: "Order Checkout",
      body: SingleChildScrollView(
          controller: _scrollController, // Also pass it to the scrollable widget
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCartItems(),
              const SizedBox(height: 16),
              _buildDeliveryOptions(),
              const SizedBox(height: 16),
              _buildAddressInput(),
              const SizedBox(height: 16),
              _buildPaymentMethods(),
              const SizedBox(height: 32),
              _buildActionButton(),
            ],
          ),
        ),
      );
  }


Widget _buildCartItems() {
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Divider(),
          ...widget.cartItems.map((item) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.product.image, 
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item.product.name),
              subtitle: Text('Quantity: ${item.quantity}'),
              trailing: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
            );
          }),
          const Divider(),
          Text('Delivery Fee: \$${deliveryFee.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text(
            'Total Amount: \$${calculateTotalAmount().toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildDeliveryOptions() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            RadioListTile(
              title: const Row(
                children: [
                  Icon(Icons.home, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Home Delivery'),
                ],
              ),
              value: 'Home Delivery',
              groupValue: selectedDeliveryOption,
              onChanged: (value) {
                setState(() {
                  selectedDeliveryOption = value!;
                  deliveryFee = 5.0; // Adjust delivery fee for Home Delivery
                });
              },
            ),
            RadioListTile(
              title: const Row(
                children: [
                  Icon(Icons.store, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Pickup'),
                ],
              ),
              value: 'Pickup',
              groupValue: selectedDeliveryOption,
              onChanged: (value) {
                setState(() {
                  selectedDeliveryOption = value!;
                  deliveryFee = 0.0; // No delivery fee for Pickup
                  shippingAddress = null; // No shipping address needed for Pickup
                });
              },
            ),
          ],
        ),
      ),
    );
  }

Widget _buildAddressInput() {
  if (selectedDeliveryOption == 'Home Delivery') {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            // Use Current Location Section
            GestureDetector(
              onTap: _getCurrentLocation,
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Use Current Location',
                    style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Available Addresses Section
            const Divider(),
            Text(
              'Select an Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            // RadioListTile for Available Addresses
            ListView.builder(
              shrinkWrap: true,
              itemCount: availableAddresses.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(availableAddresses[index]),
                  value: availableAddresses[index],
                  groupValue: shippingAddress,
                  onChanged: (String? value) {
                    setState(() {
                      shippingAddress = value;
                    });
                  },
                  activeColor: Colors.blue,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              },
            ),
            const Divider(),
            // RadioListTile for Current Location (if available)
            if (currentLocationAddress != null)
              RadioListTile<String>(
                title: Text(currentLocationAddress!),
                value: currentLocationAddress!, 
                groupValue: shippingAddress,
                onChanged: (String? value) {
                  setState(() {
                    shippingAddress = value;
                  });
                },
                activeColor: Colors.blue,
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
          ],
        ),
      ),
    );
  } else {
    return const SizedBox(); // No address input for Pickup
  }
}




  Widget _buildPaymentMethods() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPaymentMethod,
              items: const [
                DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                DropdownMenuItem(value: 'Mobile Money', child: Text('Mobile Money')),
                DropdownMenuItem(value: 'Cash on Delivery', child: Text('Cash on Delivery')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (selectedDeliveryOption == 'Home Delivery' && (shippingAddress == null || shippingAddress!.isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please provide a valid shipping address.')),
            );
            return;
          }

          // Generate Order Model
          // Order newOrder = Order(
          //   orderId: DateTime.now().millisecondsSinceEpoch.toString(),
          //   items: widget.cartItems,
          //   totalAmount: calculateTotalAmount(),
          //   deliveryFee: deliveryFee,
          //   orderDate: DateTime.now(),
          //   customerId: widget.customerId,
          //   shippingAddress: shippingAddress ?? 'N/A',
          //   paymentMethod: selectedPaymentMethod,
          //   status: OrderStatus.pending,
          // );

          // TODO: Save the order (e.g., via a Provider or API call)

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order Placed Successfully!')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Custom button color
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Place Order'),
      ),
    );
  }
}

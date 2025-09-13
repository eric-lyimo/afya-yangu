import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/cart.items.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/order.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/products.model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final List<Order> _pendingOrders = [];
  final List<Order> _completedOrders = [];

  List<CartItem> get cartItems => _cartItems;
  List<Order> get pendingOrders => _pendingOrders;
  List<Order> get completedOrders => _completedOrders;

  // Calculate total price of items in the cart
  double totalPrice() {
    double price = 0.00;
    for (var item in _cartItems) {
      double productPrices = item.product.price * item.quantity;
      price += productPrices;
    }
    return price;
  }

  // Add an item to the cart
  void addToCart(Product product) {
    bool exists = false;
    for (var item in _cartItems) {
      if (item.product.name == product.name) {
        item.quantity += 1;
        exists = true;
        break;
      }
    }
    if (!exists) {
      CartItem items = CartItem(product: product, quantity: 1);
      _cartItems.add(items);
    }
    notifyListeners();
  }

  // Decrease the quantity of an item in the cart
  void decreaseQuantity(Product product) {
    for (var item in _cartItems) {
      if (item.product.name == product.name) {
        if (item.quantity > 1) {
          item.quantity -= 1;
        } else {
          _cartItems.remove(item);
        }
        break;
      }
    }
    notifyListeners();
  }

  // Place an order
  void placeOrder({
    required String customerId,
    required String shippingAddress,
    required String paymentMethod,
    required double deliveryFee,
  }) {
    if (_cartItems.isEmpty) {
      return;
    }

    final order = Order(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(), 
      items: List<CartItem>.from(_cartItems),
      totalAmount: totalPrice() + deliveryFee,
      deliveryFee: deliveryFee,
      orderDate: DateTime.now(),
      customerId: customerId,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.pending,
    );

    _pendingOrders.add(order); 
    _cartItems.clear(); 
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    for (var order in _pendingOrders) {
      if (order.orderId == orderId) {
        order.status = status;
        if (status == OrderStatus.delivered || status == OrderStatus.canceled) {
          _pendingOrders.remove(order);
          _completedOrders.add(order);
        }
        break;
      }
    }
    notifyListeners();
  }

Order? getOrderById(String orderId) {
  try {
    return _pendingOrders.firstWhere((order) => order.orderId == orderId);
  } catch (e) {
    return null; 
  }
}



  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.canceled);
  }

  void completeOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.delivered);
  }
}

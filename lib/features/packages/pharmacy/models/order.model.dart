import 'dart:convert';

import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/cart.items.dart';

class Order {
  final String orderId;
  final List<CartItem> items;
  final double totalAmount;
  final double deliveryFee;
  final DateTime orderDate;
  final String customerId;
  final String shippingAddress;
  final String paymentMethod;
  late final OrderStatus status;
  final DateTime? deliveryDate;

  Order({
    required this.orderId,
    required this.items,
    required this.deliveryFee,
    required this.totalAmount,
    required this.orderDate,
    required this.customerId,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    this.deliveryDate,
  });

  // Convert Order to a Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'customerId': customerId,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status.toString().split('.').last, // Convert enum to string
      'deliveryDate': deliveryDate?.toIso8601String(),
      'deliveryFee': deliveryFee,
    };
  }

  // Convert Order to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create an Order from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      items: List<CartItem>.from(map['items']?.map((x) => CartItem.fromMap(x))),
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      orderDate: DateTime.parse(map['orderDate']),
      customerId: map['customerId'],
      shippingAddress: map['shippingAddress'],
      paymentMethod: map['paymentMethod'],
      deliveryFee:map['deliveryFee'],
      status: OrderStatus.values.firstWhere((e) => e.toString().split('.').last == map['status']),
      deliveryDate: map['deliveryDate'] != null ? DateTime.parse(map['deliveryDate']) : null,
    );
  }

  // Create an Order from a JSON string
  factory Order.fromJson(String json) {
    return Order.fromMap(jsonDecode(json));
  }
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  canceled,
}

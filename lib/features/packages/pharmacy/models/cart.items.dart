import 'dart:convert';

import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/products.model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Convert CartItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  // Convert CartItem to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create a CartItem from a Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity']?.toInt() ?? 1,
    );
  }

  // Create a CartItem from a JSON string
  factory CartItem.fromJson(String json) {
    return CartItem.fromMap(jsonDecode(json));
  }
}

import 'dart:convert';

import 'package:mtmeru_afya_yangu/features/packages/pharmacy/models/cart.items.dart';

class Cart {
  List<CartItem> items;
  double totalPrice;
  int itemCount;

  Cart({
    this.items = const [],
    this.totalPrice = 0.0,
    this.itemCount = 0,
  });

  // Convert Cart to a Map
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'itemCount': itemCount,
    };
  }

  // Convert Cart to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create a Cart from a Map
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      items: List<CartItem>.from(map['items']?.map((x) => CartItem.fromMap(x))),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      itemCount: map['itemCount']?.toInt() ?? 0,
    );
  }

  // Create a Cart from a JSON string
  factory Cart.fromJson(String json) {
    return Cart.fromMap(jsonDecode(json));
  }
}

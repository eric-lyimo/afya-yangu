import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.isAvailable = true,
  });

  // Convert Product to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'isAvailable': isAvailable,
    };
  }

  // Convert Product to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price']?.toDouble() ?? 0.0,
      image: map['image'],
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  // Create a Product from a JSON string
  factory Product.fromJson(String json) {
    return Product.fromMap(jsonDecode(json));
  }
}

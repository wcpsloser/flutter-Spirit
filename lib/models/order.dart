import 'dart:convert';

import 'package:store_app/models/product.dart';

class Order {
  final int? id;
  final int? userId;
  final Product product;
  int quantity;
  final String status;

  Order({
    this.id,
    this.userId,
    required this.product,
    this.quantity = 1,
    required this.status,
  });

  Order copyWith({
    int? id,
    int? userId,
    Product? product,
    int? quantity,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'product_id': product.id,
      'quantity': quantity,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['user_id'] as int,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}

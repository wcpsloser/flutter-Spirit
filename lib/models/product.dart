import 'dart:convert';

class Product {
  final int? id;
  final String name;
  final String img;
  final String description;
  final double price;
  int stock;

  Product({
    this.id,
    required this.name,
    required this.img,
    required this.description,
    required this.price,
    this.stock = 0,
  });

  Product copyWith({
    int? id,
    String? name,
    String? img,
    String? description,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      img: img ?? this.img,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'img': img,
      'description': description,
      'price': price,
      'stock': stock,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      img: map['img'] as String,
      description: map['description'] as String,
      price: map['price'].runtimeType != double
          ? double.parse(map['price'])
          : map['price'] as double,
      stock: map['stock'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

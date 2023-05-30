import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:store_app/models/order.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/models/user.dart';

class AppDatabase {
  static const String _baseUrl =
      kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

  //? Product helper
  static Future<void> createProduct(Product product) async {
    await http.post(
      Uri.parse('$_baseUrl/product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: product.toJson(),
    );
  }

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/product'));

    // Decode json string to list of dynamic
    final data = jsonDecode(response.body) as List<dynamic>;

    // For each json parsed to convert each item in the list to product model
    final products = data.map((item) => Product.fromMap(item)).toList();

    // Filter products by stock of product is more than 0
    List<Product> productInStock = [];
    for (Product product in products) {
      if (product.stock > 0) {
        productInStock.add(product);
      }
    }

    return productInStock;
  }

  static Future<void> updateProduct(Product product) async {
    await http.put(
      Uri.parse('$_baseUrl/product/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: product.toJson(),
    );
  }

  static Future<void> deleteProduct(int id) async {
    await http.delete(Uri.parse('$_baseUrl/product/$id'));
  }

  //? Order helper
  static Future<void> createOrder(Order order) async {
    await http.post(
      Uri.parse('$_baseUrl/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: order.toJson(),
    );
  }

  static Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl/order'));
    final data = jsonDecode(response.body) as List<dynamic>;

    final products = await getProducts();

    List<Order> orders = [];
    for (dynamic item in data) {
      // Loop for seach Product by ID
      // Then insert data to list of Order
      for (Product product in products) {
        if (product.id == item['product_id']) {
          Map<String, dynamic> map = {
            'id': item['id'],
            'user_id': item['user_id'],
            'product': product.toMap(),
            'quantity': item['quantity'],
            'status': item['status'],
          };

          orders.add(Order.fromMap(map));
        }
      }
    }

    return orders;
  }

  static Future<void> updateOrder(Order order) async {
    await http.put(
      Uri.parse('$_baseUrl/order/${order.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: order.toJson(),
    );
  }

  //? Cart helper
  static Future<List<Order>> getReadOnlyUserCart(int? userId) async {
    // If user ID is null, then return empty list
    if (userId == null) return [];

    final orders = await getOrders();

    // Filter orders by user ID and status which unpaid as carts
    List<Order> carts = [];

    List<String> productname = [];
    for (Order order in orders) {
      if (order.userId == userId && order.status == 'unpaid') {
        carts.add(order);
      }
    }
    List<Order> finalcarts = [];
    for (Order order in carts) {
      if (!productname.contains(order.product.name)) {
        productname.add(order.product.name);
        int x = carts
            .where((element) => element.product.name == order.product.name)
            .length;
        order.quantity = x;
        finalcarts.add(order);
      }
    }
    return finalcarts;
  }

  static Future<List<Order>> getUserCart(int? userId) async {
    // If user ID is null, then return empty list
    if (userId == null) return [];

    final orders = await getOrders();

    // Filter orders by user ID and status which unpaid as carts
    List<Order> carts = [];
    for (Order order in orders) {
      if (order.userId == userId && order.status == 'unpaid') {
        carts.add(order);
      }
    }

    return carts;
  }

  static Future<void> checkout(List<Order> orders) async {
    final products = await getProducts();

    for (Order order in orders) {
      // Update status of order from 'unpaid' to 'paid'
      final orderUpdated = order.copyWith(status: 'paid');
      await updateOrder(orderUpdated);

      // Loop for reduce stock of product
      for (Product product in products) {
        if (product.id == orderUpdated.product.id) {
          // Check if the product is in stock or not
          final isHaveProduct = (product.stock - orderUpdated.quantity) >= 0;
          if (isHaveProduct) {
            // Update product
            final productUpdated = product.copyWith(
              stock: product.stock - orderUpdated.quantity,
            );
            await updateProduct(productUpdated);
          }
        }
      }
    }
  }

  //? User helper
  static Future<void> createUser(User user) async {
    await http.post(
      Uri.parse('$_baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: user.toJson(),
    );
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/user'));
    final data = jsonDecode(response.body) as List<dynamic>;

    final users = data.map((item) => User.fromMap(item)).toList();

    return users;
  }

  static Future<User?> login(String username, String password) async {
    final users = await getUsers();
    for (User user in users) {
      if (user.username == username && user.password == password) {
        return user;
      }
    }

    // Return null if username and password not match any user
    return null;
  }
}

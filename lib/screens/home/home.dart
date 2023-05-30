import 'package:flutter/material.dart';
import 'package:store_app/database/app_database.dart';
import 'package:store_app/models/order.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/screens/cart/cart.dart';

import 'widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({
    required this.user,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Product>>? _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = AppDatabase.getProducts();
  }

  void _reloadProducts() {
    setState(() {
      _productFuture = AppDatabase.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                // Function for check that Cart or Logout Button is pressed
                if (value == 'cart') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        user: widget.user,
                      ),
                    ),
                  ).then((_) => _reloadProducts());
                } else if (value == 'logout') {
                  // Perform logout functionality here
                  // You can add your own logic for logging out the user.
                  Navigator.pop(context);
                } else if (value == 'reload') {
                  // Perform logout functionality here
                  // You can add your own logic for logging out the user.
                  _reloadProducts();
                }
              },
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8.0),

                  // Show Username Text
                  Text(
                    widget.user.fullname,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              itemBuilder: (BuildContext context) => [
                // Cart Button
                const PopupMenuItem<String>(
                  value: 'cart',
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 8.0),
                      Text('Cart'),
                    ],
                  ),
                ),

                // Logout Button
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8.0),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: snapshot.data![index],
                  onAddToCart: () async {
                    final currentOrder = Order(
                      userId: widget.user.id,
                      product: snapshot.data![index],
                      quantity: 1,
                      status: 'unpaid',
                    );
                    final orders = await AppDatabase.getOrders();

                    for (Order order in orders) {
                      final isFoundOrder =
                          currentOrder.userId == order.userId &&
                              order.product.id == currentOrder.product.id;
                      // check current order if it exits if yes + quantity
                      if (isFoundOrder && order.status == 'unpaid') {
                        final temporder = order.copyWith(
                          quantity: order.quantity + 1,
                        );

                        await AppDatabase.updateOrder(temporder);
                        return;
                      }
                    }
                    await AppDatabase.createOrder(currentOrder);
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

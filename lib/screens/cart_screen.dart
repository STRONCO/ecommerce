// ignore_for_file: library_private_types_in_public_api

import 'package:ecommerce/models/cart.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  @override
  void initState() {
    super.initState();
    cartItems = []; // Initialize the list here
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    print('Cart items in build: $cartItems');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Pantalla'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item.productName),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: Text('\$${item.price * item.quantity}'),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:'),
                Text('\$$totalPrice',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Realizar la acción de realizar la compra, enviar la orden, etc.
                // Puedes reiniciar la lista del carrito aquí si es necesario.
                setState(() {
                  cartItems.clear();
                });
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  // Función para agregar un producto al carrito
  void addToCart(CartItem newItem) {
    print('Adding to cart: $newItem');
    setState(() {
      final existingItemIndex =
          cartItems.indexWhere((item) => item.productId == newItem.productId);
      if (existingItemIndex != -1) {
        // If the item already exists in the cart, update the quantity
        cartItems[existingItemIndex].quantity += newItem.quantity;
      } else {
        // If the item doesn't exist, add it to the cart
        cartItems.add(newItem);
      }
      print('Cart items: $cartItems');
    });
  }
}

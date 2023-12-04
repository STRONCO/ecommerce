import 'package:ecommerce/database/cartDatabase.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class CartModel extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.from(_cartItems);

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }
}
class CartItem {
  final int? id;
  final String productId;
  final String productTitle;
  final double price;
  final String image;
  int quantity;

  CartItem({
       this.id,
    required this.productId,
    required this.productTitle,
    required this.price,
    required this.image,
    required this.quantity,
  });

  Future<void> delete() async {
    final Database db = await CartDatabase.database;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  String toString() {
    return 'CartItem {productId: $productId, productTitle: $productTitle, price: $price, image: $image, quantity: $quantity}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'productId': productId,
      'productTitle': productTitle,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      productTitle: map['productTitle'],
      price: map['price'],
      image: map['image'],
      quantity: map['quantity'],
    );
  }
}

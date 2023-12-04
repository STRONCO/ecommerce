import 'package:ecommerce/models/cart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class CartDatabase {
  static late Database _database;

   static Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'cart_database.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE cart_items(
            id INTEGER PRIMARY KEY,
            productId TEXT,
            productTitle TEXT,
            price REAL,
            image TEXT,
            quantity INTEGER
          )
        ''');
      },
      version: 7,
    );
  }
  static Database get database => _database;
static Future<void> insertCartItem(CartItem newItem) async {
  await _database.insert(
    'cart_items',
    newItem.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

 static Future<void> deleteCartItem(int itemId) async {
    await _database.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  static Future<List<CartItem>> getCartItems() async {
    final List<Map<String, dynamic>> maps = await _database.query('cart_items');
    return List.generate(maps.length, (index) {
      return CartItem.fromMap(maps[index]);
    });
  }
}

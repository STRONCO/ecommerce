import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '/models/products.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db; // Note the change to allow null

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'food.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ProductsItems (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        category TEXT,
        image TEXT,
        price REAL,
        ranking INTEGER,
        calories INTEGER,
        additives INTEGER,
        vitamins INTEGER
      )
    ''');
  }
Future<int> insertFoodItem(ProductsItems foodItem) async {
  var dbClient = await db;
  return await dbClient?.insert('ProductsItems', foodItem.toMap()) ?? 0;
}

 Future<List<ProductsItems>> getFoodItems() async {
  var dbClient = await db;
  List<Map<String, dynamic>> list = await dbClient?.query('ProductsItems') ?? [];
  List<ProductsItems> foodItems = [];
  for (var item in list) {
    foodItems.add(ProductsItems(
      id: item['id'],
      title: item['title'],
      description: item['description'],
      category: item['category'],
      image: item['image'],
      price: item['price'],
      ranking: item['ranking'],
      calories: item['calories'],
      additives: item['additives'],
      vitamins: item['vitamins'],
    ));
  }
  return foodItems;
}
}

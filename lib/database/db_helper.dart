import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '/models/categories.dart';

class DBHelper {
  static Future<Database> _openDB() async {
    print('Opening database');
    return openDatabase(join(await getDatabasesPath(), 'categorias.db'),
        onCreate: (db, version) {
      return db.execute('''
           CREATE TABLE categorias (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             imagen TEXT,
             texto TEXT
           )
         ''');
    }, version: 1);
  }

  static Future<void> initializeDatabase() async {
    Database database = await _openDB();
    // Puedes realizar cualquier inicialización adicional aquí.
    await database.close();
  }

  static Future<int> insert(Categories categories) async {
    Database database = await _openDB();
    try {
      int result = await database.insert("categorias", categories.toMap());
      print('Inserted category with ID: $result');
      return result;
    } catch (e) {
      print('Error inserting category: $e');
      return -1; // Retorna un valor negativo en caso de error
    } finally {
      await database.close();
    }
  }
  static Future<List<Categories>> getAllCategories() async {
    Database database = await _openDB();
    try {
      List<Map<String, dynamic>> categoryMaps =
          await database.query("categorias");
      return categoryMaps
          .map((categoryMap) => Categories.fromMap(categoryMap))
          .toList();
    } finally {
      await database.close();
    }
  }

  static Future<void> deleteCategory(int id) async {
    Database database = await _openDB();
    try {
      await database.delete('categorias', where: 'id = ?', whereArgs: [id]);
    } finally {
      await database.close();
    }
  }
}

// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'models/categories.dart';
import 'screens/product_details.dart';
import 'screens/addCategories.dart';
import 'screens/cart_screen.dart';
import 'database/db_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dataProvider.dart';
import 'package:provider/provider.dart';
import 'screens/addProducts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initializeDatabase();

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          DataProvider(), // Ajusta según tu estructura de clases
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Categories> categories = [];

  @override
  void initState() {
    super.initState();
    print('initState called');
    loadData();
  }

  Future<void> loadData() async {
    try {
      List<Categories> loadedCategories = await DBHelper.getAllCategories();
      print('Categories loaded: $loadedCategories');
      setState(() {
        categories = loadedCategories;
      });
      print('Categories updated: $categories');
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Color hexToColor(String colorCode) {
    try {
      if (colorCode.startsWith("#") && colorCode.length == 7) {
        return Color(
            int.parse(colorCode.substring(1, 7), radix: 16) + 0xFF000000);
      } else {
        return _getColorFromName(colorCode);
      }
    } catch (e) {
      print('Error converting color: $e');
      return Colors.transparent;
    }
  }

  Color _getColorFromName(String colorName) {
    Map<String, int> colorMap = {
      'Black': 0xFF000000,
      'Blue': 0xFF0000FF,
      'Red': 0xFFFF0000,
    };

    final colorValue = colorMap[colorName];
    if (colorValue != null) {
      return Color(colorValue);
    } else {
      print('Unknown color name: $colorName');
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rigel APP'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
//Hamburguer -Start
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rigel App Vera Vela',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProducts()),
                );
              },
            ),
            ListTile(
              title: const Text('Add Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCategoriesScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
//Hamburguer -End

      body: Padding(
        padding: const EdgeInsets.only(
          left: 18.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            const Text(
              'Hi, Helen',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "What's today's taste? 😋",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0), // Ajusta según tus preferencias

            FutureBuilder<List<Categories>>(
              future: DBHelper.getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  List<Categories> categories = snapshot.data!;
                  print('Categories: $categories');

                  return Container(
                    height: 100.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        Categories category = categories[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hexToColor(category.colorCategory),
                                ),
                                child: ClipOval(
                                  child: Image.file(
                                    File(category.imagen),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                category.texto,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            Stack(
              children: [
                Align(
                  alignment: Alignment.center, // Ajusta según sea necesario
                  child: SizedBox(
                    width: 350.0,
                    height: 350.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Titulo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Descripción del producto',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 10.0),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              // Lógica de actualización de la calificación
                            },
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Lógica para agregar al carrito
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // Color de fondo blanco
                            ),
                            icon: const Icon(Icons.shopping_cart,
                                color: Colors.black), // Icono en color negro
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                  color: Colors.black), // Texto en color negro
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

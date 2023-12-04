// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dataProvider.dart';
import 'package:provider/provider.dart';
//database
import 'database/db_helper.dart';
import 'database/helperProducts.dart';
import 'database/cartDatabase.dart';
//models
import 'models/categories.dart';
import 'models/products.dart';
import 'models/cart.dart';
//screens
import 'screens/product_details.dart';
import 'screens/addCategories.dart';
import 'screens/cart_screen.dart';
import 'screens/addProducts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initializeDatabase();
  await CartDatabase.initializeDatabase();

  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
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
  late DatabaseHelper dbHelper;
  ProductsItems? selectedProduct;
  Color randomBorderColor = Colors.transparent;
  String selectedCategory = 'Frutas';
  String selectedCategoryImage = '';
  int selectedQuantity = 1;

  void onProductSelected(ProductsItems product) {
    setState(() {
      selectedProduct = product;
      randomBorderColor = getRandomColor();
      print('Selected Product: $selectedProduct');

      selectedCategory = product.category;

      selectedCategoryImage = categories
          .firstWhere((category) => category.texto == selectedCategory)
          .imagen;
    });
  }

  void addToCart(ProductsItems product, int quantity) async {
    String productId = product.id?.toString() ?? 'N/A';

    // Verificar si el ID del producto es nulo o está vacío antes de continuar
    if (productId == 'N/A' || productId.isEmpty) {
      // Manejar el caso en el que el ID del producto no es válido
      print('Invalid product ID');
      return;
    }

    print('Product ID: $productId');
    print('Product Title: ${product.title}');
    print('Product Price: ${product.price}');
    print('Product Image: ${product.image}');

    CartItem newItem = CartItem(
      productId: productId,
      productTitle: product.title ?? 'N/A',
      price: product.price ?? 0.0,
      image: product.image ?? 'default_image.jpg',
      quantity: quantity,
    );

    print('New CartItem: $newItem');

    // Llamar al método para insertar el nuevo item en la base de datos del carrito
    await CartDatabase.insertCartItem(newItem);

    // Navegar a la pantalla del carrito (puedes ajustar esto según tu estructura de navegación)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartScreen()),
    );
  }

  Color getRandomColor() {
    final Random random = Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
    print('Random Color: $color');
    return color;
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
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
                MaterialPageRoute(builder: (context) => CartScreen()),
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
                  MaterialPageRoute(builder: (context) => const AddProducts()),
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
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
//Hamburguer -End

      body: SingleChildScrollView(
        // Añade SingleChildScrollView aquí
        child: Padding(
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
              const SizedBox(height: 10.0),
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
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category.texto;
                                selectedCategoryImage = category.imagen;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
                                      border: Border.all(
                                        color:
                                            selectedCategory == category.texto
                                                ? const Color.fromARGB(
                                                    255, 160, 132, 10)
                                                : Colors.transparent,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.file(
                                        File(category.imagen),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 350.0,
                        height: 350.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getRandomColor(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (selectedProduct != null &&
                                  selectedProduct!.image.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(
                                                  product: selectedProduct),
                                        ),
                                      );
                                    },
                                    child: ClipOval(
                                      child: Image.file(
                                        File(selectedProduct!.image),
                                        width: 120.0,
                                        height: 120.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 15.0),
                              if (selectedProduct != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 80.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedProduct!.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        '\$${selectedProduct!.price}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      RatingBar.builder(
                                        initialRating:
                                            selectedProduct!.ranking.toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(height: 50.0),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          if (selectedProduct != null) {
                                            addToCart(selectedProduct!,
                                                selectedQuantity);
                                          } else {
                                            print('Selected product is null');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(),
                                        icon: const Icon(Icons.shopping_cart,
                                            color: Colors.black),
                                        label: const Text(
                                          'Add to Cart',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0.5),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                      child: FutureBuilder<List<ProductsItems>>(
                        future: dbHelper.getFoodItems(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              List<ProductsItems>? products = snapshot.data;

                              List<ProductsItems>? filteredProducts = products
                                  ?.where((product) =>
                                      product.category == selectedCategory)
                                  .toList();

                              return filteredProducts != null &&
                                      filteredProducts.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: filteredProducts.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            onProductSelected(
                                                filteredProducts[index]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: SizedBox(
                                              width: 70.0,
                                              height: 70.0,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: selectedProduct ==
                                                            null
                                                        ? Colors.grey
                                                        : selectedProduct!.id ==
                                                                filteredProducts[
                                                                        index]
                                                                    .id
                                                            ? Colors.green
                                                            : Colors.grey,
                                                    width: 3.0,
                                                  ),
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                      File(filteredProducts[
                                                                  index]
                                                              .image
                                                              .isNotEmpty
                                                          ? filteredProducts[
                                                                  index]
                                                              .image
                                                          : 'default_image_path'),
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox();
                            } else {
                              return const Text(
                                  'No hay productos disponibles.');
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:ecommerce/models/products.dart';
import 'package:ecommerce/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/database/cartDatabase.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductsItems? product;

  const ProductDetailsScreen({required this.product, Key? key})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.file(
                File(widget.product!.image),
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 25.0),
              Text(
                widget.product?.title ?? 'N/A',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.product?.description ?? 'N/A',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  RatingBar.builder(
                    initialRating: widget.product?.ranking.toDouble() ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 24.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Capacity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCapacityItem(
                              'Calories',
                              widget.product?.calories.toString() ?? 'N/A',
                            ),
                            _buildCapacityItem(
                              'Additives',
                              widget.product?.additives.toString() ?? 'N/A',
                            ),
                            _buildCapacityItem(
                              'Vitamins',
                              widget.product?.vitamins.toString() ?? 'N/A',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Quantity'),
                            const SizedBox(width: 16.0),
                            DropdownButton<int>(
                              value: selectedQuantity,
                              onChanged: (value) {
                                setState(() {
                                  selectedQuantity = value!;
                                });
                              },
                              items: List.generate(10, (index) => index + 1)
                                  .map((quantity) => DropdownMenuItem<int>(
                                        value: quantity,
                                        child: Text('$quantity'),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                        Text(
                          'Price: \$${(widget.product?.price ?? 0.0)}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () async {
            // Crear un nuevo CartItem con la información del producto actual
            String productId = widget.product?.id?.toString() ?? 'N/A';

            // Verificar si el ID del producto es nulo o está vacío antes de continuar
            if (productId == 'N/A' || productId.isEmpty) {
              // Manejar el caso en el que el ID del producto no es válido
              print('Invalid product ID');
              return;
            }

            print('Product ID: $productId');
            print('Product Title: ${widget.product?.title}');
            print('Product Price: ${widget.product?.price}');
            print('Product Image: ${widget.product?.image}');

            CartItem newItem = CartItem(
              productId: productId,
              productTitle: widget.product?.title ?? 'N/A',
              price: widget.product?.price ?? 0.0,
              image: widget.product?.image ?? 'default_image.jpg',
              quantity: selectedQuantity,
            );

            print('New CartItem: $newItem');

            // Llamar al método para insertar el nuevo item en la base de datos del carrito
            await CartDatabase.insertCartItem(newItem);

            // Navegar a la pantalla del carrito (puedes ajustar esto según tu estructura de navegación)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }

  Widget _buildCapacityItem(String label, String value) {
    return Column(
      children: [
        Container(
          width: 75.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

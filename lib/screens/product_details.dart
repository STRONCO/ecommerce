import 'dart:io';
import 'package:ecommerce/models/products.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class ProductDetailsScreen extends StatelessWidget {
  final ProductsItems? product;

  const ProductDetailsScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar la imagen del producto
            Image.file(
              File(product!.image),
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            // Mostrar otros detalles del producto
            Text('Product Name: ${product?.title ?? 'N/A'}'),
            Text('Product Description: ${product?.description ?? 'N/A'}'),
            // Agrega más detalles según sea necesario
          ],
        ),
      ),
    );
  }
}

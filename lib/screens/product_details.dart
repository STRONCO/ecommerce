import 'package:flutter/material.dart';

// ignore: camel_case_types
class Product_details extends StatelessWidget {
  const Product_details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda Pantalla'),
      ),
      body: const Center(
        child: Text('Contenido de la segunda pantalla'),
      ),
    );
  }
}
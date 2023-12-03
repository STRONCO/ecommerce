import 'package:flutter/material.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Pantalla'),
      ),
      body: const Center(
        child: Text('Contenido de la CaRT pantalla'),
      ),
    );
  }
}
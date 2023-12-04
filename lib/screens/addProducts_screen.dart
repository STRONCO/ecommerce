import 'package:flutter/material.dart';
import '/database/helperProducts.dart';

class AddProducts extends StatelessWidget {

final DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen
              TextFormField(
                decoration: InputDecoration(labelText: 'Imagen'),
              ),
              SizedBox(height: 16.0),

              // Categoría
              TextFormField(
                decoration: InputDecoration(labelText: 'Categoría'),
              ),
              SizedBox(height: 16.0),

              // Precio
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),

              // Ranking (utilizando un RatingBar)
              TextFormField(
                decoration: InputDecoration(labelText: 'Ranking'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),

              // Título
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
              ),
              SizedBox(height: 16.0),

              // Descripción
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),

              // Calorías
              TextFormField(
                decoration: InputDecoration(labelText: 'Calorías'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),

              // Aditivos
              TextFormField(
                decoration: InputDecoration(labelText: 'Aditivos'),
              ),
              SizedBox(height: 16.0),

              // Vitaminas
              TextFormField(
                decoration: InputDecoration(labelText: 'Vitaminas'),
              ),
              SizedBox(height: 16.0),

              // Botón para enviar el formulario
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para enviar el formulario
                },
                child: Text('Añadir Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

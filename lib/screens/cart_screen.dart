import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/database/cartDatabase.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> cartItemsFuture;
  double _total = 0.0;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cartItemsFuture = CartDatabase.getCartItems();
    updateTotal(); // Llama a la función al inicio para calcular el total.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: FutureBuilder<List<CartItem>>(
        future: cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<CartItem> cartItems = snapshot.data!;
            double total = calculateTotal(cartItems);

            return cartItems.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            CartItem cartItem = cartItems[index];
                            return CartItemCard(
                              cartItem: cartItem,
                              updateTotal: updateTotal,
                            );
                          },
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '\$$total',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text('Your cart is empty.'),
                  );
          }
        },
      ),
    );
  }

  double calculateTotal(List<CartItem> cartItems) {
    double total = 0.0;
    for (CartItem cartItem in cartItems) {
      total += cartItem.price * cartItem.quantity;
    }
    return total;
  }

  void updateTotal() {
    setState(() {
      // No necesitamos calcular el total aquí, ya que FutureBuilder ya lo hace.
    });
  }
}

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback updateTotal;

  const CartItemCard({
    Key? key,
    required this.cartItem,
    required this.updateTotal,
  }) : super(key: key);

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late GlobalKey<FormFieldState<String>> quantityFieldKey;

  @override
  void initState() {
    super.initState();
    quantityFieldKey = GlobalKey<FormFieldState<String>>();
  }

  Future<void> deleteCartItem() async {
    print('Deleting item: ${widget.cartItem.productTitle}');
    await widget.cartItem.delete();
    print('Item deleted');

    // Llama a la función para actualizar el total después de eliminar un artículo.
    widget.updateTotal();

    // Muestra un SnackBar para notificar al usuario
    ScaffoldMessenger.of(_CartScreenState._scaffoldKey.currentContext!)
        .showSnackBar(
      SnackBar(content: Text('Item deleted from the cart')),
    );
    // Espera un breve momento antes de forzar la reconstrucción del widget
    await Future.delayed(Duration(milliseconds: 500));

    // Actualiza el estado para forzar la reconstrucción del widget.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.file(
              File(widget.cartItem.image),
              width: 50.0,
              height: 50.0,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      widget.cartItem.productTitle,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Original: \$${widget.cartItem.price}'),
                      SizedBox(width: 50.0),
                      Text(
                        'Final: \$${widget.cartItem.price * widget.cartItem.quantity}',
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Quantity: '),
                      SizedBox(
                        width: 20.0,
                        child: TextFormField(
                          key: quantityFieldKey,
                          initialValue: widget.cartItem.quantity.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              widget.cartItem.quantity =
                                  int.tryParse(value) ?? 0;
                            });
                            // Llama a la función para actualizar el total al cambiar la cantidad.
                            widget.updateTotal();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteCartItem,
            ),
          ],
        ),
      ),
    );
  }
}

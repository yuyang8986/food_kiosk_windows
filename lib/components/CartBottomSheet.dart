import 'package:flutter/material.dart';
import 'package:mcdo_ui/cart.dart'; // Ensure correct path to the Cart model
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartBottomSheet extends StatefulWidget {
  final List<Cart> itemCart;

  const CartBottomSheet({Key? key, required this.itemCart}) : super(key: key);

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  void _incrementQuantity(int index) {
    setState(() {
      widget.itemCart[index].qtt++;
    });
  }

  void _decrementQuantity(int index) {
    if (widget.itemCart[index].qtt > 0) {
      setState(() {
        widget.itemCart[index].qtt--;
      });
    }
  }

  Future<void> saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> cartJson =
          widget.itemCart.map((cart) => jsonEncode(cart.toJson())).toList();
      await prefs.setStringList('cartItems', cartJson);
      print("Cart saved successfully");
      Navigator.pop(context, true);
    } catch (e) {
      print("Failed to save cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.itemCart.length,
              itemBuilder: (BuildContext context, int index) {
                Cart cartItem = widget.itemCart[index];
                var parts = cartItem.configKey.split('|');
                var addOns =
                    parts.length > 1 ? parts[1].split(':') : <String>[];

                return Card(
                  child: ListTile(
                    leading: Image.asset(cartItem.img, width: 50, height: 50),
                    title: Text(cartItem.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sugar Level: ${cartItem.sugarLevel}"),
                            if (addOns.isNotEmpty)
                              ...addOns.map((addOn) => Text(addOn)).toList(),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Text(" ${cartItem.qtt} "),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                        "AUD ${cartItem.getTotalPrice().toStringAsFixed(2)}"),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: saveCart,
            child: Text('Confirm'),
          )
        ],
      ),
    );
  }
}

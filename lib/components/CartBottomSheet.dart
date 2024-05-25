import 'package:flutter/material.dart';
import 'package:mcdo_ui/cart.dart'; // Ensure correct path to the Cart model

class CartBottomSheet extends StatelessWidget {
  final List<Cart> itemCart;

  const CartBottomSheet({Key? key, required this.itemCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: itemCart.length,
        itemBuilder: (BuildContext context, int index) {
          Cart cartItem = itemCart[index];
          var parts = cartItem.configKey.split('|');
          var addOns = parts.length > 1 ? parts[1].split(':') : <String>[];

          return Card(
            child: ListTile(
              leading: Image.asset(cartItem.img, width: 50, height: 50),
              title: Text(cartItem.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Quantity: ${cartItem.qtt}"),
                  Text("Sugar Level: ${cartItem.sugarLevel}"),
                  if (addOns.isNotEmpty)
                    ...addOns.map((addOn) => Text(addOn)).toList(),
                ],
              ),
              trailing:
                  Text("AUD ${cartItem.getTotalPrice().toStringAsFixed(2)}"),
            ),
          );
        },
      ),
    );
  }
}

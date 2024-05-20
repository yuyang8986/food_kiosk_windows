import 'package:flutter/material.dart';
import 'package:mcdo_ui/cart.dart';

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
          return Card(
            child: ListTile(
              leading: Image.asset(cartItem.img, width: 50, height: 50), // Ensure images are in assets
              title: Text(cartItem.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Quantity: ${cartItem.qtt}"),
                  Text("Sugar Level: ${cartItem.sugarLevel}"),
                  ...cartItem.addOns.entries.map((entry) => Text("${entry.key}: ${entry.value.toStringAsFixed(2)}")),
                ],
              ),
              trailing: Text("KES ${cartItem.getTotalPrice().toStringAsFixed(2)}"),
            ),
          );
        },
      ),
    );
  }
}

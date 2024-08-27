import 'package:flutter/material.dart';
import 'package:mcdo_ui/item.dart';
import 'package:mcdo_ui/models/item.dart';
import 'package:mcdo_ui/models/orderItem.dart';

class TotalBar extends StatelessWidget {
  final double totalPrice;
  final Function(OrderItem) onAddToCart;
  final OrderItem orderItem;

  const TotalBar({
    Key? key,
    required this.totalPrice,
    required this.onAddToCart,
    required this.orderItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total AUD $totalPrice",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onAddToCart(orderItem); // Pass the entire OrderItem with the correct quantity
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              "+ Add",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

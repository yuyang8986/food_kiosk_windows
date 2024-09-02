import 'package:flutter/material.dart';

class CartBar extends StatelessWidget {
  final double total;
  final VoidCallback onViewCartPressed;
  final bool isEnabled;

  CartBar({
    required this.isEnabled,
    required this.total,
    required this.onViewCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                ),
                TextSpan(
                  text: " AUD $total",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: ElevatedButton(
              onPressed: onViewCartPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isEnabled ? Colors.white : Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                "VIEW CART",
                style: TextStyle(color: Colors.black.withOpacity(.9), fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

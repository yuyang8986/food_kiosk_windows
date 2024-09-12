import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mcdo_ui/components/CartBar.dart';
import 'package:mcdo_ui/models/item.dart';
import 'package:mcdo_ui/models/order.dart';

class RightBar extends StatelessWidget {
  final List<Item> filteredItems;
  final Order order;
  final VoidCallback onViewCartPressed;
  final Function(int) onAddToCartPressed;

  const RightBar({
    Key? key,
    required this.filteredItems,
    required this.order,
    required this.onViewCartPressed,
    required this.onAddToCartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Green Top Bar with Order Type
        // Container(
        //   height: 60.0,
        //   color: Colors.green,
        //   child: Center(
        //     child: Text(
        //       'Order Type: ${order.orderType}',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
        Expanded(
          flex: 6,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 2,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, position) {
              return listItem(position);
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
            ),
            child: Center(
              child: CartBar(
                isEnabled: order.orderItems.isNotEmpty,
                total: order.orderPrice,
                onViewCartPressed: onViewCartPressed,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget listItem(int position) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0), // Add some padding to prevent overflow
              child: Image.memory(
                filteredItems[position].itemImage as Uint8List,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10), // Reduced height to avoid overflow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                filteredItems[position].itemName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis, // Add ellipsis to handle overflow
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Reduced height to avoid overflow
          ElevatedButton(
            onPressed: () {
              onAddToCartPressed(position);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 199, 0, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

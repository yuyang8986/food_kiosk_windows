import 'dart:typed_data';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/chooser.dart'; // This is where the Navigation class is defined
import 'package:mcdo_ui/models/order.dart'; // Ensure correct path to the Order model
import 'package:mcdo_ui/models/orderItem.dart';
import 'package:mcdo_ui/printer_info.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartBottomSheet extends StatefulWidget {
  final Order order;
  final String type;
  final Function handlePaymentCompleted;
  final PrinterInfo printerInfo;

  const CartBottomSheet({
    Key? key,
    required this.printerInfo,
    required this.order,
    required this.type,
    required this.handlePaymentCompleted,
  }) : super(key: key);

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  void _incrementQuantity(int index) {
    setState(() {
      widget.order.orderItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (widget.order.orderItems[index].quantity > 1) {
        widget.order.orderItems[index].quantity--;
      } else {
        // Remove the item if quantity is 1 and it is decremented
        widget.order.orderItems.removeAt(index);
      }
    });
  }

  double getTotalPrice(List<OrderItem> items) {
    return items.fold(
      0.0,
      (sum, orderItem) => sum + orderItem.getTotalPrice(),
    );
  }

  Future<void> saveOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> orderJson = widget.order.orderItems
          .map((orderItem) => jsonEncode(orderItem.toJson()))
          .toList();
      await prefs.setStringList('orderItems', orderJson);
      print("Order saved successfully");
      Navigator.pop(context, true);
    } catch (e) {
      print("Failed to save order: $e");
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
              itemCount: widget.order.orderItems.length,
              itemBuilder: (BuildContext context, int index) {
                OrderItem orderItem = widget.order.orderItems[index];

                return Card(
                  child: ListTile(
                    leading: Image.memory(orderItem.item.itemImage as Uint8List,
                        width: 50, height: 50),
                    title: Text(orderItem.item.itemName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(orderItem.item.itemName),
                        if (orderItem.selectedItemAddonOptions.isNotEmpty)
                          ...orderItem.selectedItemAddonOptions.map((addon) {
                            return Text(
                              "${addon.optionName}: +AUD ${addon.price.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 14),
                            );
                          }).toList(),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                _decrementQuantity(index);
                              },
                            ),
                            Text(
                              " ${orderItem.quantity} ",
                              style: TextStyle(fontSize: 15),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      "AUD ${orderItem.getTotalPrice().toStringAsFixed(2)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity, // Ensures the buttons take up full width
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (widget.order.orderItems.isEmpty ||
                        widget.order.orderItems.length == 0 ||
                        getTotalPrice(widget.order.orderItems) == 0) {
                      // Show alert dialog if no items are in the order
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text(
                                'At least one item is needed to place an order.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return; // Stop further execution
                    }

                    // Continue to navigation if there are order items
                    Navigation.initPaths(
                      widget.order,
                      widget.type,
                      widget.printerInfo,
                    ); // Ensure this method is updated to handle OrderItem

                    final result = await Navigation.router.navigateTo(
                      context,
                      'payment',
                      transition: TransitionType.fadeIn,
                    );

                    if (result == true) {
                      widget.handlePaymentCompleted();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    textStyle: TextStyle(fontSize: 24, color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 26, 124, 13),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    textStyle: TextStyle(fontSize: 20, color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 88, 48, 45), // Optional: Add red color for cancel
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

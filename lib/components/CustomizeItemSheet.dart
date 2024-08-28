import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/components/TotalBar.dart';
import 'package:mcdo_ui/models/item-addon-option.dart';
import 'package:mcdo_ui/models/orderItem.dart';

class CustomizeItemSheet extends StatefulWidget {
  final OrderItem orderItem;
  final int position;
  final Function(OrderItem) onAddToCart;

  const CustomizeItemSheet({
    Key? key,
    required this.orderItem,
    required this.position,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _CustomizeItemSheetState createState() => _CustomizeItemSheetState();
}

class _CustomizeItemSheetState extends State<CustomizeItemSheet> {

  @override
  Widget build(BuildContext context) {
    // Define a placeholder for when no matching item is found
    ItemAddonOption placeholderItemAddonOption = ItemAddonOption(
      optionId: -1, // Use an ID that does not conflict with actual addon IDs
      optionName: 'Select Option', // Default label
      optionDescription: 'No description',
      price: 0.0, // Set default price to 0
      itemAddonId: -1,
    );

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.memory(
            widget.orderItem.item.itemImage as Uint8List,
            fit: BoxFit.contain,
            height: 80,
          ),
          SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(widget.orderItem.item.itemName,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 50),
          Text("Customize",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ListTile(
            title: Text("Quantity"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() => widget.orderItem.quantity =
                      max(1, widget.orderItem.quantity - 1)),
                ),
                Text(widget.orderItem.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() => widget.orderItem.quantity++),
                ),
              ],
            ),
          ),
          if (widget.orderItem.item.itemAddons.isNotEmpty)
            SingleChildScrollView(
              child: Column(
                children: widget.orderItem.item.itemAddons.map((ia) {
                  if (ia.itemAddonOptions.isEmpty) {
                    return ListTile(
                      title: Text(ia.itemAddonName),
                      subtitle: Text('No options available'),
                    );
                  }

                  // Find the selected option
                  ItemAddonOption? selectedOption = widget.orderItem.selectedItemAddonOptions.firstWhere(
                    (ItemAddonOption iao) => iao.itemAddonId == ia.itemAddonId,
                    orElse: () => ia.itemAddonOptions.first, // Default to the first option in the list
                  );

                  return ListTile(
                    title: Text(ia.itemAddonName),
                    trailing: DropdownButton<ItemAddonOption>(
                      value: selectedOption,
                      items: ia.itemAddonOptions.map((ItemAddonOption iao) {
                        return DropdownMenuItem<ItemAddonOption>(
                          value: iao, // Ensure this value is unique
                          child: Text(iao.optionName),
                        );
                      }).toList(),
                      onChanged: (ItemAddonOption? newValue) {
                        if (newValue != null) {
                          setState(() {
                            // Remove the old selected option for this addon
                            widget.orderItem.selectedItemAddonOptions
                                .removeWhere((ItemAddonOption iao) => iao.itemAddonId == ia.itemAddonId);
                            
                            // Add the new selected option
                            widget.orderItem.selectedItemAddonOptions.add(newValue);
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          TotalBar(
            totalPrice: widget.orderItem.getTotalPrice(),
            onAddToCart: (OrderItem orderItem) {
            // Debugging print statement to check selected options
            print('Selected options for ${orderItem.item.itemName}: ${orderItem.selectedItemAddonOptions}');
            
            widget.onAddToCart(orderItem);  // This should pass the correct options and quantities
            Navigator.pop(context);  // Close the sheet
          },
            orderItem: widget.orderItem,  // Pass the entire OrderItem object to the cart
          ),

        ],
      ),
    );
  }
}

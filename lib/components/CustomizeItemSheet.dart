import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mcdo_ui/components/TotalBar.dart';
import 'package:mcdo_ui/item.dart';
import 'package:mcdo_ui/models/item-addon-option.dart';
import 'package:mcdo_ui/models/item-addon.dart';
import 'package:mcdo_ui/models/item.dart';
import 'package:mcdo_ui/models/orderItem.dart';

class CustomizeItemSheet extends StatefulWidget {
  final OrderItem orderItem;
  final int position;
  final Function(Item) onAddToCart;

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
                  return ListTile(
                    title: Text(ia.itemAddonName),
                    trailing: DropdownButton<ItemAddonOption>(
                      value: widget.orderItem.selectedItemAddonOptions.isEmpty
                          ? null
                          : widget.orderItem.selectedItemAddonOptions
                              .firstWhere(
                              (ItemAddonOption iao) =>
                                  iao.itemAddonId == ia.itemAddonId,
                            ), // handle case where no match is found
                      items: ia.itemAddonOptions.map((ItemAddonOption iao) {
                        return DropdownMenuItem<ItemAddonOption>(
                          value: iao,
                          child: Text(iao.optionName),
                        );
                      }).toList(),
                      onChanged: (ItemAddonOption? newValue) {
                        setState(() {
                          if (newValue != null) {
                            widget.orderItem.selectedItemAddonOptions
                                .removeWhere((ItemAddonOption iao) =>
                                    iao.itemAddonId == ia.itemAddonId);
                            widget.orderItem.selectedItemAddonOptions
                                .add(newValue);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          TotalBar(
            totalPrice: widget.orderItem.getTotalPrice(),
            onAddToCart: widget.onAddToCart,
            item: widget.orderItem.item,
          ),
        ],
      ),
    );
  }
}

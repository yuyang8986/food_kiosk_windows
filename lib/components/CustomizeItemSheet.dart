import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mcdo_ui/components/TotalBar.dart';
import 'package:mcdo_ui/item.dart';

class CustomizeItemSheet extends StatefulWidget {
  final Item item;
  final int position;

  const CustomizeItemSheet({
    Key? key,
    required this.item,
    required this.position,
  }) : super(key: key);

  @override
  _CustomizeItemSheetState createState() => _CustomizeItemSheetState();
}

class _CustomizeItemSheetState extends State<CustomizeItemSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 1300,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            widget.item.getImg(),
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(widget.item.getName(),
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
                  onPressed: () => setState(() =>
                      widget.item.quantity = max(1, widget.item.quantity - 1)),
                ),
                Text(widget.item.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() => widget.item.quantity++),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Sugar"),
            trailing: DropdownButton<int>(
              value: widget.item.sugarLevel,
              items: ["Less", "Medium", "Strong"].asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (newValue) =>
                  setState(() => widget.item.sugarLevel = newValue!),
            ),
          ),
          ...{"Cookie": 11.0, "Marshmallow": 11.0, "Chocolate": 11.0}
              .entries
              .map((addOn) {
            return CheckboxListTile(
              title: Text(addOn.key),
              subtitle: Text("AUD ${addOn.value}"),
              value: widget.item.addOns.containsKey(addOn.key),
              onChanged: (bool? value) {
                setState(() {
                  widget.item.addOns[addOn.key] = value!;
                });
              },
            );
          }).toList(),
          TotalBar(totalPrice: widget.item.getTotalPrice()),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}

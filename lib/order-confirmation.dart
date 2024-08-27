import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/main.dart';

class OrderConfirmation extends StatelessWidget {
  final String orderNumber;

  OrderConfirmation({required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 124, 58, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 90),
          Center(
            child: Image.asset(
              'assets/logo.png',
              height: 120.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Order Confirmation",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
          SizedBox(height: 15),
          Divider(
            color: Colors.black26,
            indent: 10,
            endIndent: 10,
            height: 5,
          ),
          SizedBox(height: 15),
          Text(
            "Order No: $orderNumber",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
          SizedBox(height: 15),
          Text(
            "Order placed successfully, please go to the counter and pay.",
            style: TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: Text("Close",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          SizedBox(height: 70),
        ],
      ),
    );
  }
}

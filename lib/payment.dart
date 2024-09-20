import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/chooser.dart';
import 'package:mcdo_ui/components/label_constraint_box.dart';
import 'package:mcdo_ui/components/receipt_constraint_box.dart';
import 'package:mcdo_ui/helpers/httphelper.dart';
import 'package:mcdo_ui/helpers/printerHelper.dart';
import 'package:mcdo_ui/models/order.dart';
import 'package:mcdo_ui/order-confirmation.dart';
import 'package:mcdo_ui/printer_info.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

class Payment extends StatefulWidget {
  final Order order;
  final String type; // Eat in or Take out
  final PrinterInfo printerInfo;
  // final Function onOrderItemsChanged;
  Payment({required this.printerInfo, required this.order, required this.type
      // required this.onOrderItemsChanged
      });

  @override
  _MyPaymentState createState() => _MyPaymentState();
}

class _MyPaymentState extends State<Payment> {
  late Order order;
  late String type;

  @override
  void initState() {
    super.initState();
    order = Navigation.currentOrder!;
    type = Navigation.orderType!;
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(43, 124, 58, 1),
    body: Stack(
      children: <Widget>[
        Positioned(
          top: 40.0,
          child: Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("My",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      )),
                  Text("Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      )),
                  SizedBox(height: 7),
                  Text(widget.type,
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.black26,
              indent: 10,
              endIndent: 10,
              height: 5,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: order.orderItems.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black26,
                  indent: 10,
                  endIndent: 10,
                ),
                itemBuilder: (context, position) {
                  return listItem(position);
                },
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  ButtonTheme(
                    minWidth: 150.0,
                    height: 80.0,
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("Place Order",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        textStyle: TextStyle(
                            fontSize: 24, color: Colors.white),
                        backgroundColor:
                            Color.fromARGB(255, 16, 42, 90),
                      ),
                      onPressed: () {
                        // Check if any item has a quantity of 0
                        bool hasZeroQuantity =
                            order.orderItems.isEmpty ||
                                order.orderItems.any(
                                    (item) => item.quantity == 0);

                        if (hasZeroQuantity) {
                          // Show alert dialog if any item has a quantity of 0
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid Order'),
                                content: Text(
                                    'There are items in the order with zero quantity. Please adjust the quantity or remove them before placing the order.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // If no item has a quantity of 0, proceed with placing the order
                          var helper = HttpClientHelper();
                          var orderNumber;
                          helper.createOrder(order).then((value) {
                            orderNumber = value;

                            // Generate receipt for preview
                            PictureGeneratorProvider
                                .instance
                                .addPicGeneratorTask(
                              PicGenerateTask<PrinterInfo>(
                                tempWidget: ReceiptConstrainedBox(
                                  ReceiptStyleWidget(
                                    order: order,
                                    orderNumber: orderNumber.toString(),
                                  ),
                                  pageWidth: 550,
                                ),
                                printTypeEnum:
                                    PrintTypeEnum.receipt,
                                params: widget.printerInfo,
                              ),
                            );

                            // Navigate to OrderConfirmation screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderConfirmation(
                                        orderNumber:
                                            orderNumber.toString()),
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // Back Button Below Place Order Button
                  ButtonTheme(
                    minWidth: 180.0,
                    height: 60.0,
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("Go Back",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        textStyle: TextStyle(
                            fontSize: 18, color: Colors.white),
                        backgroundColor: const Color.fromARGB(255, 48, 43, 43),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ],
    ),
  );
}

  Widget listItem(int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 15),
        Image.memory(
          height: 50,
          width: 120,
          order.orderItems[position].item.itemImage as Uint8List,
        ),
        SizedBox(width: 20),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(order.orderItems[position].item.itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              if (order
                  .orderItems[position].selectedItemAddonOptions.isNotEmpty)
                ...order.orderItems[position].selectedItemAddonOptions.map(
                  (addon) {
                    return Text(
                      "${addon.optionName}: +\$${addon.price.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ).toList(),
              SizedBox(height: 5),
              Text(
                "\$${order.orderItems[position].getTotalPrice().toStringAsFixed(2)}",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: Text("-", style: TextStyle(fontSize: 20)),
              onPressed: () {
                setState(() {
                  order.orderItems[position].remove(1);
                  if (order.orderItems[position].quantity <= 0) {
                    order.orderItems.removeAt(position);
                  }
                  reCalculateOrderPrice();
                  // widget.onOrderItemsChanged(order.orderItems);
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            SizedBox(width: 10),
            Text(
              order.orderItems[position].quantity.toString(),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text("+", style: TextStyle(fontSize: 20)),
              onPressed: () {
                setState(() {
                  order.orderItems[position].add();
                  reCalculateOrderPrice();

                  // widget.onOrderItemsChanged(order.orderItems);
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
          ],
        ),
        SizedBox(width: 10)
      ],
    );
  }

  void reCalculateOrderPrice() {
    // setState(() {
    order.orderPrice =
        order.orderItems.fold(0, (sum, item) => sum + item.getTotalPrice());
    // });
  }
}

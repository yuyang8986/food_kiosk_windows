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

  Payment({required this.printerInfo, required this.order, required this.type});

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
                child: ButtonTheme(
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
                                    fontSize: 30,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      textStyle: TextStyle(fontSize: 24, color: Colors.white),
                      backgroundColor: Color.fromARGB(255, 16, 42, 90),
                    ),
                    onPressed: () {
                      var helper = HttpClientHelper();
                      var orderNumber;
                      helper.createOrder(order).then((value) {
                        // PrinterHelper.currentOrderToPrinter = order
                        orderNumber = value;
                        // 预览小票
                        PictureGeneratorProvider.instance.addPicGeneratorTask(
                          PicGenerateTask<PrinterInfo>(
                            tempWidget: ReceiptConstrainedBox(
                              ReceiptStyleWidget(
                                order: order,
                                orderNumber: orderNumber.toString(),
                              ),
                              pageWidth: 550,
                            ),
                            printTypeEnum: PrintTypeEnum.receipt,
                            params: widget.printerInfo,
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmation(
                                orderNumber: orderNumber.toString()),
                          ),
                        );
                      });

                      // var printHelper = PrinterHelper();
                      // await PrinterHelper.connect(PrinterHelper.printerIP);
                      // await printHelper.printReceipt(
                      //     PrinterHelper.printerIP, order.orderItems, order.orderPrice);

                      // Future.sync(() => {
                      //    PictureGeneratorProvider.instance.addPicGeneratorTask(
                      //   PicGenerateTask<PrinterInfo>(
                      //     tempWidget: const ReceiptConstrainedBox(
                      //       ReceiptStyleWidget(),
                      //       pageWidth: 550,
                      //     ),
                      //     printTypeEnum: PrintTypeEnum.receipt,
                      //     params: PrinterHelper.usbPrinter,
                      //   ),
                      // )
                      // });

                      // PrinterHelper.performCommand();
                    },
                    // style: ElevatedButton.styleFrom(
                    //   padding: EdgeInsets.symmetric(vertical: 15),
                    //   textStyle: TextStyle(fontSize: 24),
                    //   backgroundColor: Colors.purple,
                    // ),
                  ),
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
}

import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mcdo_ui/components/CartBar.dart';
import 'package:mcdo_ui/components/CartBottomSheet.dart';
import 'package:mcdo_ui/components/CustomizeItemSheet.dart';
import 'package:mcdo_ui/helpers/httphelper.dart';
import 'package:mcdo_ui/models/item-category.dart';
import 'package:mcdo_ui/models/item.dart';
import 'package:mcdo_ui/models/order.dart';
import 'package:mcdo_ui/models/orderItem.dart';
import 'package:mcdo_ui/payment.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluro/fluro.dart';
import 'dart:convert';

class Navigation {
  static final router = FluroRouter();
  static bool _routesDefined = false;

  static void initPaths(order, type) {
    if (!_routesDefined) {
      var chooserHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          return Chooser();
        },
      );

      var paymentHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
          return Payment(order: order, type: type);
        },
      );

      void defineRoutes(FluroRouter router) {
        router.define("/", handler: chooserHandler);
        router.define("payment", handler: paymentHandler);
      }

      defineRoutes(router);
      _routesDefined = true;
    }
  }
}

class Chooser extends StatefulWidget {
  final type; // Eat in or Take out

  Chooser({this.type});

  @override
  _MyChooserState createState() => _MyChooserState();
}

class _MyChooserState extends State<Chooser> {
  late List<ItemCategory> categories = [];
  List<Item> filteredItems = [];
  Order order = Order(
      // orderDateTime: DateTime.now(),
      orderPrice: 0.0,
      orderItems: [],
      orderType: '',
      orderDescription: '',
      orderName: ''
      // orderStatus: "Pending",
      // orderNumber: 0
      );
  String category = "All";
  late Future<List<ItemCategory>> futureMenu;

  @override
  void initState() {
    super.initState();
    order.orderType = widget.type;
    futureMenu = HttpClientHelper().fetchMenu();
  }

  void calculateTotal() {
    setState(() {
      order.orderPrice = order.orderItems.fold(
          0.0,
          (sum, orderItem) =>
              sum + orderItem.item.itemPrice * orderItem.quantity);
    });
  }

  Future<void> handlePaymentCompleted() async {
    recalculateTotal();
    setState(() {});
  }

  void recalculateTotal() {
    setState(() {
      order.orderPrice = order.orderItems.fold(
          0.0,
          (sum, orderItem) =>
              sum + orderItem.item.itemPrice * orderItem.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      // Container(
                      //   margin: const EdgeInsets.only(left: 20.0),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       // Text("Hey,",
                      //       //     style: TextStyle(
                      //       //         fontWeight: FontWeight.bold, fontSize: 25)),
                      //       Text("What would like to order",
                      //           style: TextStyle(fontSize: 25)),
                      //       SizedBox(height: 10),
                      //     ],
                      //   ),
                      // ),
                      FutureBuilder<List<ItemCategory>>(
                        future: futureMenu,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            categories = snapshot.data!;
                            return Expanded(
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.all(10),
                                children:
                                    List.generate(categories.length, (index) {
                                  return SizedBox(
                                    width: 250,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Center(
                                        child: SizedBox(
                                          height: 100,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Container(
                                              constraints:
                                                  BoxConstraints(minWidth: 170),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 50,
                                                        maxHeight: 50),
                                                    child: Image.memory(
                                                      categories[index]
                                                              .categoryImage
                                                          as Uint8List,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      categories[index]
                                                          .itemCategoryName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                category = categories[index]
                                                    .itemCategoryName;
                                                filteredItems =
                                                    categories[index].items;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              flex: 1,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.green),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(246, 246, 246, 1)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(category,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19)),
                                            SizedBox(height: 7),
                                            Text(widget.type,
                                                style: TextStyle(fontSize: 14))
                                          ])),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                      child: ListView.builder(
                                    itemCount: filteredItems.length,
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: listItem(position),
                                      );
                                    },
                                  ))
                                ]),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(246, 246, 246, 1)),
                              child: Center(
                                  child: Column(children: <Widget>[
                                Divider(
                                  color: Colors.black26,
                                  indent: 10,
                                ),
                                SizedBox(height: 5),
                                Spacer(),
                                Spacer(),
                                CartBar(
                                    isEnabled: order.orderItems.isNotEmpty,
                                    total: order.orderPrice,
                                    onViewCartPressed: order.orderItems.isEmpty
                                        ? () {}
                                        : showCart),
                              ]))),
                          flex: 1,
                        ),
                      ]),
                ),
                flex: 5,
              ),
            ],
          ),
          Positioned(
              top: 1.0,
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ]),
              )),
        ],
      ),
    );
  }

  showCart() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CartBottomSheet(
          orderItems: order.orderItems,
          type: widget.type,
          handlePaymentCompleted: handlePaymentCompleted,
        );
      },
    ).then((value) {
      if (value == true) {
        setState(() {
          calculateTotal();
        });
      }
    });
  }

  Widget listItem(int position) {
    int nextPosition =
        position + 1 < filteredItems.length ? position + 1 : position;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.memory(
                  height: 110,
                  filteredItems[position].itemImage as Uint8List,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(filteredItems[position].itemName,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                actionButton(context, position)
              ]),
        ),
        // if (position != nextPosition)
        //   Expanded(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Image.memory(
        //           filteredItems[nextPosition].itemImage as Uint8List,
        //           fit: BoxFit.contain,
        //           height: 100,
        //         ),
        //         FittedBox(
        //           fit: BoxFit.fitWidth,
        //           child: Text(
        //             filteredItems[nextPosition].itemName,
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //         actionButton(context, nextPosition),
        //       ],
        //     ),
        //   ),
      ],
    );
  }

  Widget actionButton(BuildContext context, int position) {
    return ButtonTheme(
      minWidth: 20.0,
      height: 25.0,
      buttonColor: Color.fromRGBO(230, 203, 51, 1),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all(Color.fromRGBO(255, 199, 0, 1)),
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'Add',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => CustomizeItemSheet(
              orderItem: OrderItem(
                // orderItemId: 0,
                // orderId: 0,
                // itemId: filteredItems[position].itemId,
                item: filteredItems[position],
                order: order,
                quantity: 1,
              ),
              position: position,
              onAddToCart: (item) {
                setState(() {
                  OrderItem orderItem = OrderItem(
                    // orderItemId: 0,
                    // orderId: 0,
                    // itemId: item.itemId,
                    item: item,
                    order: order,
                    quantity: 1,
                  );
                  order.orderItems.add(orderItem);
                  calculateTotal();
                });
              },
            ),
          );
        },
      ),
    );
  }
}

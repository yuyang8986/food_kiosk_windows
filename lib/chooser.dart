// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:mcdo_ui/components/CartBar.dart';
// import 'package:mcdo_ui/components/CartBottomSheet.dart';
// import 'package:mcdo_ui/components/CustomizeItemSheet.dart';
// import 'package:mcdo_ui/helpers/httphelper.dart';
// import 'package:mcdo_ui/models/item-category.dart';
// import 'package:mcdo_ui/models/item.dart';
// import 'package:mcdo_ui/models/order.dart';
// import 'package:mcdo_ui/models/orderItem.dart';
// import 'package:mcdo_ui/payment.dart';
// import 'package:fluro/fluro.dart';

// class Navigation {
//   static final router = FluroRouter();
//   static bool _routesDefined = false;

//   static void initPaths(order, type) {
//     if (!_routesDefined) {
//       var chooserHandler = Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//           return Chooser(type: type);
//         },
//       );

//       var paymentHandler = Handler(
//         handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//           return Payment(order: order, type: type);
//         },
//       );

//       void defineRoutes(FluroRouter router) {
//         router.define("/", handler: chooserHandler);
//         router.define("payment", handler: paymentHandler);
//       }

//       defineRoutes(router);
//       _routesDefined = true;
//     }
//   }
// }


// class Chooser extends StatefulWidget {
//   final type; // Eat in or Take out

//   Chooser({this.type});

//   @override
//   _MyChooserState createState() => _MyChooserState();
// }

// class _MyChooserState extends State<Chooser> {
//   late List<ItemCategory> categories = [];
//   List<Item> filteredItems = [];
//   Order order = Order(
//     orderPrice: 0.0,
//     orderItems: [],
//     orderType: '',
//     orderDescription: '',
//     orderName: '',
//   );
//   String category = "All";
//   late Future<List<ItemCategory>> futureMenu;

//   @override
//   void initState() {
//     super.initState();
//     order.orderType = widget.type;
//     futureMenu = HttpClientHelper().fetchMenu();
//   }

//   void calculateTotal() {
//     setState(() {
//       order.orderPrice = order.orderItems.fold(
//         0.0,
//         (sum, orderItem) => sum + orderItem.getTotalPrice(),
//       );
//     });
//   }

//   Future<void> handlePaymentCompleted() async {
//     recalculateTotal();
//     setState(() {});
//   }

//   void recalculateTotal() {
//     setState(() {
//       order.orderPrice = order.orderItems.fold(
//         0.0,
//         (sum, orderItem) => sum + orderItem.getTotalPrice(),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(height: 100),
//                       FutureBuilder<List<ItemCategory>>(
//                         future: futureMenu,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                               child: Text('Error: ${snapshot.error}'),
//                             );
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.isEmpty) {
//                             return Center(child: Text('No data available'));
//                           } else {
//                             categories = snapshot.data!;
//                             return Expanded(
//                               child: ListView(
//                                 scrollDirection: Axis.vertical,
//                                 padding: const EdgeInsets.all(10),
//                                 children: List.generate(
//                                   categories.length,
//                                   (index) {
//                                     return SizedBox(
//                                       width: 250,
//                                       child: Container(
//                                         margin: EdgeInsets.only(top: 10),
//                                         child: Center(
//                                           child: SizedBox(
//                                             height: 100,
//                                             child: ElevatedButton(
//                                               style: ButtonStyle(
//                                                 shape: MaterialStateProperty
//                                                     .all<RoundedRectangleBorder>(
//                                                   RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             12.0),
//                                                   ),
//                                                 ),
//                                                 backgroundColor:
//                                                     MaterialStateProperty.all(
//                                                         Colors.white),
//                                               ),
//                                               child: Container(
//                                                 constraints:
//                                                     BoxConstraints(minWidth: 170),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Container(
//                                                       constraints: BoxConstraints(
//                                                           maxWidth: 50,
//                                                           maxHeight: 50),
//                                                       child: Image.memory(
//                                                         categories[index]
//                                                                 .categoryImage
//                                                             as Uint8List,
//                                                         fit: BoxFit.contain,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 20,
//                                                     ),
//                                                     Flexible(
//                                                       child: Text(
//                                                         categories[index]
//                                                             .itemCategoryName,
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   category = categories[index]
//                                                       .itemCategoryName;
//                                                   filteredItems =
//                                                       categories[index].items;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 5,
//                 child: Container(
//                   decoration: const BoxDecoration(color: Colors.green),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Expanded(
//                         flex: 6,
//                         child: FutureBuilder(
//                           future: futureMenu,
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             } else if (snapshot.hasError) {
//                               return Center(
//                                 child: Text('Error: ${snapshot.error}'),
//                               );
//                             } else if (!snapshot.hasData ||
//                                 snapshot.data!.isEmpty) {
//                               return Center(child: Text('No data available'));
//                             } else {
//                               if (category == "All") {
//                                 filteredItems = snapshot.data!
//                                     .expand((e) => e.items)
//                                     .toList();
//                               }
//                               return ListView.builder(
//                                 itemCount: filteredItems.length,
//                                 itemBuilder: (context, position) {
//                                   return Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 10),
//                                     child: listItem(position),
//                                   );
//                                 },
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Color.fromRGBO(246, 246, 246, 1),
//                           ),
//                           child: Center(
//                             child: Column(
//                               children: <Widget>[
//                                 Divider(
//                                   color: Colors.black26,
//                                   indent: 10,
//                                 ),
//                                 SizedBox(height: 5),
//                                 Spacer(),
//                                 Spacer(),
//                                 CartBar(
//                                   isEnabled: order.orderItems.isNotEmpty,
//                                   total: order.orderPrice,
//                                   onViewCartPressed: order.orderItems.isEmpty
//                                       ? () {}
//                                       : showCart,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             top: 1.0,
//             child: Container(
//               padding: EdgeInsets.only(left: 15.0, right: 15.0),
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Image.asset(
//                     'assets/logo.png',
//                     height: 100.0,
//                     fit: BoxFit.cover,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   showCart() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return CartBottomSheet(
//           order: order,
//           type: widget.type,
//           handlePaymentCompleted: handlePaymentCompleted,
//         );
//       },
//     ).then((value) {
//       if (value == true) {
//         setState(() {
//           calculateTotal();
//         });
//       }
//     });
//   }

//   Widget listItem(int position) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image.memory(
//                 height: 130,
//                 width: 130,
//                 filteredItems[position].itemImage as Uint8List,
//                 fit: BoxFit.contain,
//               ),
//               SizedBox(height: 20),
//               FittedBox(
//                 fit: BoxFit.fitWidth,
//                 child: Text(
//                   filteredItems[position].itemName,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 20),
//               actionButton(context, position),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget actionButton(BuildContext context, int position) {
//     return ElevatedButton(
//       style: ButtonStyle(
//         shape: MaterialStateProperty.all(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//         ),
//         backgroundColor: MaterialStateProperty.all(
//           Color.fromRGBO(255, 199, 0, 1),
//         ),
//       ),
//       child: FittedBox(
//         fit: BoxFit.fitWidth,
//         child: Text(
//           'Add',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       onPressed: () {
//         showModalBottomSheet(
//           isScrollControlled: true,
//           context: context,
//           builder: (context) => CustomizeItemSheet(
//             orderItem: OrderItem(
//               item: filteredItems[position],
//               order: order,
//               quantity: 1,
//             ),
//             position: position,
//             onAddToCart: (OrderItem orderItem) {
//               setState(() {
//                 // Check if the item is already in the cart
//                 int existingIndex = order.orderItems.indexWhere(
//                   (oi) => oi.item.itemId == orderItem.item.itemId,
//                 );

//                 if (existingIndex >= 0) {
//                   // Update the quantity if the item already exists in the cart
//                   order.orderItems[existingIndex].quantity += orderItem.quantity;
//                 } else {
//                   // Add the item to the cart
//                   order.orderItems.add(orderItem);
//                 }

//                 calculateTotal(); // Recalculate the total after adding/updating items
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/components/CartBar.dart';
import 'package:mcdo_ui/components/CartBottomSheet.dart';
import 'package:mcdo_ui/components/CustomizeItemSheet.dart';
import 'package:mcdo_ui/helpers/httphelper.dart';
import 'package:mcdo_ui/models/item-category.dart';
import 'package:mcdo_ui/models/item.dart';
import 'package:mcdo_ui/models/order.dart';
import 'package:mcdo_ui/models/orderItem.dart';
import 'package:mcdo_ui/payment.dart';
import 'package:fluro/fluro.dart';

class Navigation {
  static final router = FluroRouter();
  static bool _routesDefined = false;

  static void initPaths(order, type) {
    if (!_routesDefined) {
      var chooserHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          return Chooser(type: type);
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
    orderPrice: 0.0,
    orderItems: [],
    orderType: '',
    orderDescription: '',
    orderName: '',
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
        (sum, orderItem) => sum + orderItem.getTotalPrice(),
      );
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
        (sum, orderItem) => sum + orderItem.getTotalPrice(),
      );
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
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      FutureBuilder<List<ItemCategory>>(
                        future: futureMenu,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            categories = snapshot.data!;
                            return Expanded(
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.all(10),
                                children: List.generate(
                                  categories.length,
                                  (index) {
                                    return SizedBox(
                                      width: 250,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Center(
                                          child: SizedBox(
                                            height: 100,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty
                                                    .all<RoundedRectangleBorder>(
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
                                                          fontSize: 18, // Increased font size
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
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
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.green),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: FutureBuilder(
                          future: futureMenu,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text('No data available'));
                            } else {
                              if (category == "All") {
                                filteredItems = snapshot.data!
                                    .expand((e) => e.items)
                                    .toList();
                              }
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Show items in pairs
                                  mainAxisSpacing: 1.0,
                                  crossAxisSpacing: 1.0,
                                  childAspectRatio: 2, // Adjust aspect ratio
                                ),
                                itemCount: filteredItems.length,
                                itemBuilder: (context, position) {
                                  return listItem(position);
                                },
                              );
                            }
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
                            child: Column(
                              children: <Widget>[
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
                                      : showCart,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showCart() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CartBottomSheet(
          order: order,
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.memory(
            height: 150, // Increased image size
            width: 150, // Increased image size
            filteredItems[position].itemImage as Uint8List,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              filteredItems[position].itemName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, // Increased font size
              ),
            ),
          ),
          SizedBox(height: 20),
          actionButton(context, position),
        ],
      ),
    );
  }

  Widget actionButton(BuildContext context, int position) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Color.fromRGBO(255, 199, 0, 1),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          'Add',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => CustomizeItemSheet(
            orderItem: OrderItem(
              item: filteredItems[position],
              order: order,
              quantity: 1,
            ),
            position: position,
            onAddToCart: (OrderItem orderItem) {
              setState(() {
                // Check if the item is already in the cart
                int existingIndex = order.orderItems.indexWhere(
                  (oi) => oi.item.itemId == orderItem.item.itemId,
                );

                if (existingIndex >= 0) {
                  // Update the quantity if the item already exists in the cart
                  order.orderItems[existingIndex].quantity += orderItem.quantity;
                } else {
                  // Add the item to the cart
                  order.orderItems.add(orderItem);
                }

                calculateTotal(); // Recalculate the total after adding/updating items
              });
            },
          ),
        );
      },
    );
  }
}

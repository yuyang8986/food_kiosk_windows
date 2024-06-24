import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mcdo_ui/components/CartBar.dart';
import 'package:mcdo_ui/components/CartBottomSheet.dart';
import 'package:mcdo_ui/components/CustomizeItemSheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item.dart';
import 'cart.dart';
import 'package:fluro/fluro.dart';
import 'payment.dart';
import 'dart:convert';

class Chooser extends StatefulWidget {
  final type; // Eat in or Take out

  Chooser({this.type});

  @override
  _MyChooserState createState() => _MyChooserState();
}

class _MyChooserState extends State<Chooser> {
  List<Category> categories = [];
  List<Item> itemMenu = [];
  List<Item> filteredItems = [];
  List<Cart> itemCart = [];
  String category = "All";
  void initState() {
    super.initState();
    //loadCart();
    Category c1 = new Category("Combo Meal", "assets/combo.png");
    Category c2 = new Category("Burgers", "assets/burgers.png");
    Category c3 = new Category("Happy Meal", "assets/meal.png");
    Category c4 = new Category("Dummy", "assets/in.png");
    categories.add(c1);
    categories.add(c2);
    categories.add(c3);
    categories.add(c4);
    categories.add(c4);
    categories.add(c4);
    categories.add(c4);

    Item i1 = new Item("Meal", "assets/combo.png", "Combo Meal");
    Item i2 = new Item("Happy Meal", "assets/meal.png", "Happy Meal");
    Item i3 = new Item("Big Mac", "assets/burgers.png", "Burgers");
    Item i4 = new Item("Dummy", "assets/in.png", "Dummy");
    itemMenu.add(i1);
    itemMenu.add(i2);
    itemMenu.add(i3);
    itemMenu.add(i4);

    filteredItems = itemMenu;
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    // Encode each cart item to a JSON string
    List<String> cartJson =
        itemCart.map((cart) => jsonEncode(cart.toJson())).toList();
    await prefs.setStringList('cartItems', cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJson = prefs.getStringList('cartItems') ?? [];
    setState(() {
      // Decode each JSON string back to a Cart object
      itemCart =
          cartJson.map((string) => Cart.fromJson(jsonDecode(string))).toList();
    });
  }

  void calculateTotal() {
    total = itemCart.fold(0, (sum, cart) => sum + cart.getTotalPrice());
    setState(() {});
  }

  Future<void> handlePaymentCompleted() async {
    await loadCart();
    recalculateTotal();
    setState(() {});
  }

  void recalculateTotal() {
    setState(() {
      total =
          itemCart.fold(0, (sum, cartItem) => sum + cartItem.getTotalPrice());
    });
  }

  double total = 0.00;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100),
                  Container(
                    // Top text
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Hey,",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        Text("what's up ?", style: TextStyle(fontSize: 25)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(10),
                        children: List.generate(categories.length, (index) {
                          return SizedBox(
                            width: 250, // Set width to match the parent's width
                            // height: 150, // Set a fixed height for each item
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: SizedBox(
                                  // width: 120,
                                  height: 100,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: Container(
                                      constraints:
                                          BoxConstraints(minWidth: 170),
                                      // margin: EdgeInsets.only(bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // Spacer(),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 50, maxHeight: 50),
                                            child: Image.asset(
                                              categories[index].img,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          // Spacer(),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            // Use Flexible to allow the text to wrap if needed
                                            child: Text(
                                              categories[index].name,
                                              textAlign: TextAlign
                                                  .center, // Center the text horizontally
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          // Spacer(),
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        category = categories[index].name;
                                        filteredItems = itemMenu
                                            .where((element) =>
                                                element.category == category)
                                            .toList();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      flex: 1),
                  // Container(
                  //   // Bottom Text
                  //   margin: const EdgeInsets.only(left: 20.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       SizedBox(height: 10),
                  //       Text("Popular",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold, fontSize: 25)),
                  //       SizedBox(height: 10),
                  //     ],
                  //   ),
                  // ),
                  // Expanded(
                  //   child: GridView.count(
                  //       crossAxisCount: 2,
                  //       scrollDirection: Axis.horizontal,
                  //       children: List.generate(9, (index) {
                  //         return Center(
                  //             child: ButtonTheme(
                  //                 child: TextButton(
                  //           // color: Colors.white,
                  //           child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: <Widget>[
                  //                 Spacer(),
                  //                 Image.asset(
                  //                   'assets/logo.png',
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 FittedBox(
                  //                     fit: BoxFit.fitWidth,
                  //                     child: Text("Name")),
                  //                 Spacer(),
                  //                 FittedBox(
                  //                     fit: BoxFit.fitWidth,
                  //                     child: Text(
                  //                       "\$2.79",
                  //                       style: TextStyle(
                  //                           color: Color.fromRGBO(
                  //                               230, 203, 51, 1)),
                  //                     )),
                  //                 Spacer(),
                  //               ]),
                  //           onPressed: () {},
                  //           // shape: RoundedRectangleBorder(
                  //           //     borderRadius:
                  //           //         new BorderRadius.circular(
                  //           //             20.0)
                  //           //             )
                  //         )));
                  //       })),
                  //   flex: 1,
                  // )
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
                                        // Text("Order",
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 19)),
                                        SizedBox(height: 7),
                                        Text(widget.type,
                                            style: TextStyle(fontSize: 14))
                                      ])),
                              SizedBox(
                                height: 10,
                              ),
                              // Divider(
                              //   color: Colors.black26,
                              //   indent: 10,
                              //   endIndent: 10,
                              //   height: 5,
                              // ),
                              Expanded(
                                  child: ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (context, position) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                            // Text("Total", style: TextStyle(fontSize: 14)),
                            // SizedBox(height: 5),
                            Spacer(),
                            // ButtonTheme(
                            //     minWidth: 50.0,
                            //     height: 50.0,
                            //     child: ElevatedButton(
                            //       // color: Color.fromRGBO(230, 203, 51, 1),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: <Widget>[
                            //               FittedBox(
                            //                   fit: BoxFit.fitWidth,
                            //                   child: Text("Pay",
                            //                       style: TextStyle(
                            //                           fontWeight:
                            //                               FontWeight.bold,
                            //                           fontSize: 40)))
                            //             ]),
                            //       ),
                            //       onPressed: () async {
                            //         Navigation.initPaths(itemCart, widget.type);
                            //         final result = await Navigation.router
                            //             .navigateTo(context, 'payment',
                            //                 transition: TransitionType.fadeIn);
                            //         if (result == true) {
                            //           handlePaymentCompleted();
                            //         }
                            //       },
                            //       // shape: RoundedRectangleBorder(
                            //       //     borderRadius:
                            //       //         new BorderRadius.circular(30.0)
                            //       //         )
                            //     )),
                            Spacer(),
                            CartBar(
                                isEnabled: itemCart.length > 0,
                                total: total,
                                onViewCartPressed:
                                    itemCart.length == 0 ? () {} : showCart),
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
          top: 40.0,
          child: Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   child: Image.asset(
                  //     'assets/US.png',
                  //     height: 25,
                  //     fit: BoxFit.cover,
                  //   ),
                  // )
                ]),
          )),
    ]));
  }

  showCart() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CartBottomSheet(
          itemCart: itemCart,
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
                Image.asset(
                  filteredItems[position].img,
                  fit: BoxFit.contain,
                ),
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(filteredItems[position].name,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                // Text("\$" + itemCart[position].getTotalPrice().toString()),
                actionButton(context, position)
              ]),
        ),
        if (position != nextPosition)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  filteredItems[nextPosition].img,
                  fit: BoxFit.contain,
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    filteredItems[nextPosition].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                actionButton(context, nextPosition),
              ],
            ),
          ),
      ],
    );
  }

  Widget actionButton(BuildContext context, int position) {
    return ButtonTheme(
      minWidth: 20.0,
      height: 25.0,
      buttonColor: Color.fromRGBO(230, 203, 51, 1),
      child: ElevatedButton(
        child: Text("+"),
        // onPressed: () {
        //   showMaterialModalBottomSheet(
        //       context: context,
        //       builder: (context) {
        //         return Container(
        //             height: 600,
        //             color: Colors.white,
        //             child: Center(
        //               child: Column(
        //                 mainAxisAlignment:
        //                     MainAxisAlignment.spaceAround,
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: <Widget>[
        //                   Image.asset(
        //                     filteredItems[position].img,
        //                     fit: BoxFit.contain,
        //                   ),
        //                   SizedBox(
        //                     height: 20,
        //                   ),
        //                   FittedBox(
        //                       fit: BoxFit.fitWidth,
        //                       child: Text(
        //                           filteredItems[position].name,
        //                           style: TextStyle(
        //                               fontWeight:
        //                                   FontWeight.bold))),
        //                   SizedBox(
        //                     height: 50,
        //                   ),
        //                   const Text('Customize'),
        //                    SizedBox(
        //                     height: 20,
        //                   ),
        //                   Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold),),

        //                   ElevatedButton(
        //                     child:
        //                         const Text('Close'),
        //                     onPressed: () {
        //                       Navigator.pop(context);
        //                     },
        //                   ),
        //                 ],
        //               ),
        //             ));
        //       });
        //   // setState(() {
        //   //   itemCart[position].add();
        //   // });
        // }
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return CustomizeItemSheet(
                item: filteredItems[position],
                position: position,
                onAddToCart: (Item addedItem) {
                  setState(() {
                    // Handle the item addition logic
                    handleItemAddition(addedItem, position);
                  });
                },
              );
            },
          );
        },
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    );
  }

  void handleItemAddition(Item addedItem, int position) {
    // Generate the configuration key for the added item
    String configKey = addedItem.generateConfigurationKey();

    // Check if the item with this exact configuration already exists in the cart
    var existingItemIndex =
        itemCart.indexWhere((cartItem) => cartItem.configKey == configKey);

    if (existingItemIndex != -1) {
      // If the item exists, increment its quantity
      itemCart[existingItemIndex].qtt += addedItem.quantity;
    } else {
      // If the item does not exist, add it as a new entry
      itemCart.add(new Cart(
          addedItem.name,
          addedItem.img,
          addedItem.getTotalPrice(),
          addedItem.quantity,
          addedItem.sugarLevel,
          addedItem.addOns,
          configKey));
    }
    saveCart();
    recalculateTotal();
  }

  // Widget getTotal() {
  //   int i = 0;
  //   double total = 0.0;
  //   while (i < itemCart.length) {
  //     total = total + itemCart[i].getTotalPrice();
  //     i++;
  //   }
  //   return Text("\$" + total.toString(),
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25));
  // }
  Widget getTotal() {
    return Text("\$${total.toStringAsFixed(2)}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25));
  }
}

class Navigation {
  static final router = FluroRouter();
  static bool _routesDefined = false;

  static void initPaths(itemCart, type) {
    if (!_routesDefined) {
      var chooserHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          return Chooser();
        },
      );

      var paymentHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
          return Payment(cart: itemCart, type: type);
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

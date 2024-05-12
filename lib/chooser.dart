import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'item.dart';
import 'cart.dart';
import 'package:fluro/fluro.dart';
import 'payment.dart';

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
                            width: 120, // Set width to match the parent's width
                            // height: 150, // Set a fixed height for each item
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: SizedBox(
                                  width: 120,
                                  height: 150,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: Container(
                                      // margin: EdgeInsets.only(bottom: 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          // Spacer(),
                                          Image.asset(
                                            categories[index].img,
                                            fit: BoxFit.contain,
                                          ),
                                          // Spacer(),
                                          SizedBox(height: 10),
                                          Flexible(
                                            // Use Flexible to allow the text to wrap if needed
                                            child: Text(
                                              categories[index].name,
                                              textAlign: TextAlign
                                                  .center, // Center the text horizontally
                                              style: TextStyle(
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
            flex: 1,
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
                              Divider(
                                color: Colors.black26,
                                indent: 10,
                                endIndent: 10,
                                height: 5,
                              ),
                              Expanded(
                                  child: ListView.separated(
                                itemCount: filteredItems.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.black26,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                itemBuilder: (context, position) {
                                  return listItem(position);
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
                            Text("Total", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 5),
                            getTotal(),
                            Spacer(),
                            ButtonTheme(
                                minWidth: 50.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  // color: Color.fromRGBO(230, 203, 51, 1),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text("Done",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)))
                                      ]),
                                  onPressed: () {
                                    Navigation.initPaths(itemCart, widget.type);
                                    Navigation.router.navigateTo(
                                        context, 'payment',
                                        transition: TransitionType.fadeIn);
                                  },
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //         new BorderRadius.circular(30.0)
                                  //         )
                                )),
                            Spacer(),
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
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/US.png',
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  )
                ]),
          )),
    ]));
  }

  Widget listItem(int position) {
    return Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ButtonTheme(
              //     minWidth: 20.0,
              //     height: 25.0,
              //     buttonColor: Color.fromRGBO(246, 246, 246, 1),
              //     child: ElevatedButton(
              //         child: Text("-"),
              //         onPressed: () {
              //           setState(() {
              //             itemCart[position].remove();
              //             if (itemCart[position].qtt <= 0) {
              //               itemCart.removeAt(position);
              //             }
              //           });
              //         }),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: new BorderRadius.circular(12.0))),
              // Text(
              //   itemCart[position].qtt.toString(),
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              ButtonTheme(
                  minWidth: 20.0,
                  height: 25.0,
                  buttonColor: Color.fromRGBO(230, 203, 51, 1),
                  child: ElevatedButton(
                      child: Text("+"),
                      onPressed: () {
                        showMaterialModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                  height: 600,
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          filteredItems[position].img,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                                filteredItems[position].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        const Text('Customize'),
                                         SizedBox(
                                          height: 20,
                                        ),
                                        Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold),),
                                        
                                        ElevatedButton(
                                          child:
                                              const Text('Close'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                        // setState(() {
                        //   itemCart[position].add();
                        // });
                      }),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0))),
            ],
          )
        ]);
  }

  Widget getTotal() {
    int i = 0;
    double total = 0.0;
    while (i < itemCart.length) {
      total = total + itemCart[i].getTotalPrice();
      i++;
    }
    return Text("\$" + total.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25));
  }
}

class Navigation {
  static final router = FluroRouter();

  static void initPaths(itemCart, type) {
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
  }
}

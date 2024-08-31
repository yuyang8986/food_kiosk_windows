import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/components/CartBottomSheet.dart';
import 'package:mcdo_ui/components/CustomizeItemSheet.dart';
import 'package:mcdo_ui/components/left_bar.dart';
import 'package:mcdo_ui/components/right_bar.dart';
import 'package:mcdo_ui/helpers/httphelper.dart';
import 'package:mcdo_ui/models/item-category.dart';
import 'package:mcdo_ui/models/item.dart';
import 'package:mcdo_ui/models/order.dart';
import 'package:mcdo_ui/models/orderItem.dart';
import 'package:mcdo_ui/payment.dart';


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
  final String type; // Eat in or Take out

  Chooser({required this.type});

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

  void handlePaymentCompleted() {
    recalculateTotal();
  }

  void recalculateTotal() {
    setState(() {
      order.orderPrice = order.orderItems.fold(
        0.0,
        (sum, orderItem) => sum + orderItem.getTotalPrice(),
      );
    });
  }

  void handleCategorySelected(ItemCategory selectedCategory) {
    setState(() {
      category = selectedCategory.itemCategoryName;
      filteredItems = selectedCategory.items;
    });
  }

  showCustomizeSheet(int position) {
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
          int existingIndex = order.orderItems.indexWhere(
            (oi) => oi.item.itemId == orderItem.item.itemId,
          );

          if (existingIndex >= 0) {
            // Update the existing item in the cart
            order.orderItems[existingIndex].quantity += orderItem.quantity;
          } else {
            // Add the new item to the cart
            order.orderItems.add(orderItem);
          }

          calculateTotal();
        });
      },
    ),
  );
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0), // Add 100px top padding
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: FutureBuilder<List<ItemCategory>>(
                  future: futureMenu,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      categories = snapshot.data!;
                      return LeftBar(
                        categories: categories,
                        onCategorySelected: handleCategorySelected,
                      );
                    }
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: RightBar(
                  filteredItems: filteredItems,
                  order: order,
                  onViewCartPressed: () => showCart(),
                  onAddToCartPressed: showCustomizeSheet,
                ),
              ),
            ],
          ),
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


  void showCart() {
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
}

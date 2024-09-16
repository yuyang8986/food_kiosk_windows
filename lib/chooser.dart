import 'dart:ui';
import 'package:flutter/src/widgets/image.dart' as fui;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
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
import 'package:mcdo_ui/printer_info.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

class Navigation {
  static final router = FluroRouter();
  static bool _routesDefined = false;
  static Order? currentOrder; // Track the current order
  static String? orderType;

  static void initPaths(order, type, printerInfo) {
    if (currentOrder != order) {
      _routesDefined = false;
      currentOrder = order; // Update current order
    }

    var chooserHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return Chooser(
          type: type,
          printerInfo: printerInfo,
        );
      },
    );

    var paymentHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return Payment(
          order: order,
          type: type,
          printerInfo: printerInfo,
        );
      },
    );

    currentOrder = order;
    orderType = type;

    try {
      router.define("/", handler: chooserHandler);
    } catch (e) {
      print("Route '/' is already defined: $e");
    }

    try {
      router.define("payment", handler: paymentHandler);
    } catch (e) {
      print("Route 'payment' is already defined: $e");
    }

    _routesDefined = true;
  }
}

class Chooser extends StatefulWidget {
  final String type; // Eat in or Take out
  final PrinterInfo printerInfo;

  Chooser({required this.printerInfo, required this.type});

  @override
  _MyChooserState createState() => _MyChooserState();
}

class _MyChooserState extends State<Chooser> {
  late List<ItemCategory> categories = [];
  List<Item> filteredItems = [];
  late Order order;
  String category = "All";
  late Future<List<ItemCategory>> futureMenu;

  @override
  void initState() {
    super.initState();
    order = Order(
      orderPrice: 0.0,
      orderItems: [],
      orderType: '',
      orderDescription: '',
      orderName: '',
    );
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
              order.orderItems[existingIndex].quantity += orderItem.quantity;
            } else {
              order.orderItems.add(orderItem);
            }

            calculateTotal();
          });
        },
      ),
    );
  }

  Future<void> _onPictureGenerated(PicGenerateResult data) async {
    final printTask = data.taskItem;
    final printerInfo = printTask.params;
    final printTypeEnum = printTask.printTypeEnum;

    final imageBytes =
        await data.convertUint8List(imageByteFormat: ImageByteFormat.rawRgba);
    final argbWidth = data.imageWidth;
    final argbHeight = data.imageHeight;
    if (imageBytes == null) {
      return;
    }
    var printData = await PrinterCommandTool.generatePrintCmd(
      imgData: imageBytes,
      printType: printTypeEnum,
      argbWidthPx: argbWidth,
      argbHeightPx: argbHeight,
    );
    if (printerInfo.isUsbPrinter) {
      final conn = UsbConn(printerInfo.usbDevice!);
      conn.writeMultiBytes(printData, 1024 * 3);
    } else if (printerInfo.isNetPrinter) {
      final conn = NetConn(printerInfo.ip!);
      conn.writeMultiBytes(printData);
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
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
                    onViewCartPressed: () => showCart(widget.printerInfo),
                    onAddToCartPressed: showCustomizeSheet,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous page
                    },
                  ),
                  SizedBox(width: 10.0), // Gap between Back button and Logo
                  fui.Image.asset(
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

    return PrintImageGenerateWidget(
      contentBuilder: (context) {
        return scaffold;
      },
      onPictureGenerated: _onPictureGenerated,
    );
  }

  void showCart(printerInfo) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CartBottomSheet(
          printerInfo: printerInfo,
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

// import 'dart:ui' as dui;

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

  // if (!_routesDefined) {
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
      // Try defining the routes, catch exceptions for already-defined routes
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
  // }
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

  Future<void> _onPictureGenerated(PicGenerateResult data) async {
    final printTask = data.taskItem;

    //指定的打印机
    final printerInfo = printTask.params;
    //打印票据类型（标签、小票）
    final printTypeEnum = printTask.printTypeEnum;

    final imageBytes =
        await data.convertUint8List(imageByteFormat: ImageByteFormat.rawRgba);
    //也可以使用 ImageByteFormat.png
    final argbWidth = data.imageWidth;
    final argbHeight = data.imageHeight;
    if (imageBytes == null) {
      return;
    }
    //只要 imageBytes 不是使用 ImageByteFormat.rawRgba 格式转换的 unit8List
    //argbWidthPx、argbHeightPx 不要传值，默认为空就行
    var printData = await PrinterCommandTool.generatePrintCmd(
      imgData: imageBytes,
      printType: printTypeEnum,
      argbWidthPx: argbWidth,
      argbHeightPx: argbHeight,
    );
    if (printerInfo.isUsbPrinter) {
      // usb 打印
      final conn = UsbConn(printerInfo.usbDevice!);
      conn.writeMultiBytes(printData, 1024 * 3);
    } else if (printerInfo.isNetPrinter) {
      // 网络 打印
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
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
      onPictureGenerated: _onPictureGenerated, //下面说明
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcdo_ui/components/receipt_constraint_box.dart';
import 'package:mcdo_ui/helpers/printerHelper.dart';
import 'package:mcdo_ui/models/order.dart';
import 'package:mcdo_ui/printer_info.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

///标签固定大小限制的容器 (生成尺寸 45 * 70 的标签)
// class LabelConstrainedBox extends StatelessWidget with ATempWidget {
//   final Widget child;

//   // 传入标签的限制宽度、高度(单位像素)
//   final int pageWidth, pageHeight;

//   const LabelConstrainedBox(
//     this.child, {
//     Key? key,
//     required this.pageWidth,
//     required this.pageHeight,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       // width: pageWidth.w,
//       // height: pageHeight.w,
//       child: ColorFiltered(
//         colorFilter: const ColorFilter.mode(
//           Colors.black,
//           BlendMode.srcIn,
//         ),
//         child: child,
//       ),
//     );
//   }

//   @override
//   int get pixelPagerWidth => pageWidth;

//   @override
//   int get pixelPagerHeight => pageHeight;

//   @override
//   double get pixelRatio => 1 / 1;
// }


// // 标签样式 demo， （用于生成图片 - 打印）
// class LabelStyleWidget extends StatelessWidget {
//   const LabelStyleWidget({Key? key}) : super(key: key);

//   Widget _title() {
//     return Text(
//       '588',
//       style: TextStyle(fontSize: 62, fontWeight: FontWeight.w700, height: 1),
//     );
//   }

//   Widget _subTitle() {
//     return Row(
//       verticalDirection: VerticalDirection.up,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '[外卖]',
//           style:
//               TextStyle(fontSize: 30, fontWeight: FontWeight.w700, height: 1),
//         ),
//         const Spacer(),
//         Text(
//           '30分钟内饮用口感更佳',
//           style:
//               TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1),
//         ),
//       ],
//     );
//   }

//   Widget _productName() {
//     return Text(
//       '霸气手摇草莓',
//       style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
//     );
//   }

//   Widget _productDes() {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return Container(
//         constraints: BoxConstraints(
//           maxHeight: constraints.maxHeight,
//         ),
//         child:
//           Text("assssaaaaaaaaaaaaaaaaaaaaaaaaaa")
        
//       );
//     });
//   }

//   Widget _tip() {
//     return Text(
//       '"嘿嘿嘿~\n①杯好茶①起喝',
//       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
//     );
//   }

//   Widget _storeInfo() {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Text(
//           '08-30 13:35',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         Text('杭州店',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//             )),
//         Text('电话：123-1234-1234',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//             )),
//       ],
//     );
//   }

//   // Widget _barCodeWidget() {
//   //   return BarcodeWidget(
//   //     barcode: Barcode.qrCode(
//   //       errorCorrectLevel: BarcodeQRCorrectionLevel.low,
//   //     ),
//   //     data: 'https://pub.flutter-io.cn/packages/barcode_widget',
//   //     width: 80,
//   //     height: 80,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 28,
//         top: 35,
//         right: 75,
//         bottom: 80,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _title(),
//           _subTitle(),
//           const SizedBox(height: 16),
//           Divider(
//             color: const Color(0xff242524),
//             height: 10,
//             thickness: 3,
//           ),
//           const SizedBox(height: 8),
//           _productName(),
//           Expanded(
//             child: _productDes(),
//           ),
//           _tip(),
//           const SizedBox(height: 8),
//            Padding(
//             padding: const EdgeInsets.only(right: 98),
//             child: Divider(
//               color: const Color(0xff242524),
//               height: 10,
//               thickness: 3,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // SizedBox(
//           //   height: 88,
//           //   child: Row(
//           //     crossAxisAlignment: CrossAxisAlignment.end,
//           //     children: [
//           //       Expanded(child: _storeInfo()),
//           //       _barCodeWidget(),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// //预览小票
// class ReceiptTempWidget extends BaseGenerateWidget {
//   final PrinterInfo printerInfo;
//   final int receiptWidth;

//   const ReceiptTempWidget(
//     this.printerInfo, {
//     Key? key,
//     required this.receiptWidth,
//   }) : super(key: key);

//   @override
//   void doPrint() {
//     // 生成打印图层任务，指定任务类型为小票
//     PictureGeneratorProvider.instance.addPicGeneratorTask(
//       PicGenerateTask<PrinterInfo>(
//         tempWidget: child() as ATempWidget,
//         printTypeEnum: PrintTypeEnum.receipt,
//         params: printerInfo,
//       ),
//     );
//   }

//   @override
//   Widget child() {
//     return  ReceiptConstrainedBox(
//       const ReceiptStyleWidget(),
//       pageWidth: receiptWidth,
//     );
//   }
// }

// // 预览标签
// class LabelTempWidget extends BaseGenerateWidget {
//   final PrinterInfo printerInfo;
//   final int labelWidth, labelHeight;

//   const LabelTempWidget(
//     this.printerInfo, {
//     Key? key,
//     required this.labelWidth,
//     required this.labelHeight,
//   }) : super(key: key);

//   @override
//   void doPrint() {
//     // 生成打印图层任务，指定任务类型为标签
//     PictureGeneratorProvider.instance.addPicGeneratorTask(
//       PicGenerateTask<PrinterInfo>(
//         tempWidget: child() as ATempWidget,
//         printTypeEnum: PrintTypeEnum.label,
//         params: printerInfo,
//       ),
//     );
//   }

//   @override
//   Widget child() {
//     return LabelConstrainedBox(
//       const LabelStyleWidget(),
//       pageWidth: labelWidth,
//       pageHeight: labelHeight,
//     );
//   }
// }

// abstract class BaseGenerateWidget extends StatefulWidget {
//   Widget child();

//   void doPrint();

//   const BaseGenerateWidget({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _BaseGenerateWidgetState();
// }

// class _BaseGenerateWidgetState extends State<BaseGenerateWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('票据样式'),
//       ),
//       backgroundColor: Colors.black12,
//       body: Center(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       widget.doPrint();
//                     },
//                     child: const Text(
//                       "点击生成打印任务",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               widget.child(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// 小票样式 demo， （用于生成图片 - 打印）
class ReceiptStyleWidget extends StatefulWidget {
  final Order order;
  final String orderNumber;
  const ReceiptStyleWidget({
    Key? key, required this.order, required this.orderNumber
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TempReceiptWidgetState();
}

class _TempReceiptWidgetState extends State<ReceiptStyleWidget> {
  @override
  Widget build(BuildContext context) {
    return _homeBody();
  }

 Widget _homeBody() {
  var order = widget.order;

  // Sample data (replace with actual data if available)
  String orderType = order.orderType;
  String server = 'Administrator';
  String orderNumber = widget.orderNumber;
  String dateTime = DateTime.now().toLocal().toIso8601String();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Order Type, Order Number, Server Info
      Text(
        orderType,
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          // textAlign: TextAlign.center,
        ),
      ),
      SizedBox(height: 5),
      Text(
        'Order #: $orderNumber',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
          // textAlign: TextAlign.center,
        ),
      ),
      Text(
        'Server: $server',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
          // textAlign: TextAlign.center,
        ),
      ),
      Divider(thickness: 2),
      
      // Items and Addon Options
      Text(
        'Items:',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 5),

      // Display each item in the order with addons
      ...order.orderItems.map((orderItem) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item.itemName}', 
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Addon options for the item
          ...orderItem.selectedItemAddonOptions.map((addonOption) => Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              '  ${addonOption.optionName}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
              ),
            ),
          )).toList(),
        ],
      )).toList(),

      Divider(thickness: 2),

      // Date and Time
      Text(
        'Date: $dateTime',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
        ),
      ),
      SizedBox(height: 10),

      // Total Price
      Text(
        'Total Price: \$${order.orderPrice.toStringAsFixed(2)}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

}
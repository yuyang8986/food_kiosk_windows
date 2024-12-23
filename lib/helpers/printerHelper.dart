import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart' as escp;
import 'package:esc_pos_utils/src/capability_profile.dart';
import 'package:esc_pos_utils/src/enums.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils.dart' as escu;
import 'package:esc_pos_utils/esc_pos_utils.dart' as escu;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
import 'package:mcdo_ui/components/label_constraint_box.dart';
import 'package:mcdo_ui/components/receipt_constraint_box.dart';
import 'package:mcdo_ui/models/order.dart';

// import 'package:flutter_blue_plugin/flutter_blue_plugin.dart';
// import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:mcdo_ui/models/orderItem.dart';
import 'package:mcdo_ui/printer_info.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
// import 'package:printing/printing.dart';
// import 'package:usb_thermal_printer_web/usb_thermal_printer_web.dart';
// import 'package:flutter_blue/flutter_blue.dart';

class PrinterHelper {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  static escp.NetworkPrinter? printer = null;
  static bool connected = false;
  static String printerIP = '';

  static PrinterInfo? usbPrinter = null;
  static Order? currentOrderToPrinter;

  static getusbDeviceslist() async {
    List results = [];
    // results = await FlutterUsbPrinter.getUSBDeviceList();
// 返回 Future<List<UsbDeviceInfo>>
    results = await FlutterPrinterFinder.queryUsbPrinter();
    print(" length: ${results.length}");
  }

//  performCommand(
//   ) {
//     // 预览小票
//     PictureGeneratorProvider.instance.addPicGeneratorTask(
//           PicGenerateTask<PrinterInfo>(
//             tempWidget: const ReceiptConstrainedBox(
//               ReceiptStyleWidget(),
//               pageWidth: 550,
//             ),
//             printTypeEnum: PrintTypeEnum.receipt,
//             params: usbPrinter,
//           ),
//         );
//   }

  // static FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  // Future<bool> connectUSB(int vendorId, int productId) async {
  //   bool? returned = false;
  //   try {
  //     returned = await flutterUsbPrinter.connect(vendorId, productId);
  //   } on PlatformException {
  //     //response = 'Failed to get platform version.';
  //   }
  //   if (returned!) {
  //     Map<String, dynamic> printerInfo = {
  //       "vendorId": vendorId,
  //       "productId": productId,
  //     };
  //     // await LocalDb().storeUsbPrinter(printerInfo);
  //   }
  //   return returned;
  // }

  static void setPrinterIP(ip) {
    printerIP = ip;
  }

  static Future<bool> connect(printerIp) async {
    if (!connected) {
      final profile = await CapabilityProfile.load();
      printer = escp.NetworkPrinter(PaperSize.mm80, profile);

      final escp.PosPrintResult res =
          await printer!.connect(printerIp, port: 9100);

      if (res == escp.PosPrintResult.success) {
        connected = true;
      }

      return res == escp.PosPrintResult.success;
    }
    return true;
  }

//   printByUSB() async {
//     try {
//       var data = Uint8List.fromList(
//           utf8.encode(" Hello world Testing ESC POS printer..."));
//       await flutterUsbPrinter.write(data);
//       // await FlutterUsbPrinter.printRawData("text");
//       // await FlutterUsbPrinter.printText("Testing ESC POS printer...");
//     } on PlatformException {
//       //response = 'Failed to get platform version.';
//     }
// }

  Future<void> printReceipt(
      String printerIp, List<OrderItem> items, double total) async {
    try {
      // if (printer == null) {
      // await connect(printerIp);
      // }
      // if (printer != null) {
      // final receiptData = await _generateReceipt(items, 100);
      //await printer.rawBytes(receiptData);
      await testReceipt(items, total);
      // printer!.disconnect();
      // } else {
      // print('Could not connect to printer: ');
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<void> testReceipt(List<OrderItem> items, double total) {
    // Sample data
    String orderType = 'Take Out';
    String orderNumber = '00019269';
    String server = 'Administrator';
    String dateTime = '2024/7/26 7:58:28';

    printer!.feed(2);

    // Print receipt header
    printer!.text(orderType,
        styles: escu.PosStyles(align: PosAlign.center, bold: true));
    printer!.text('Order #: $orderNumber',
        styles: escu.PosStyles(align: PosAlign.center));
    printer!.text('Server: $server',
        styles: escu.PosStyles(align: PosAlign.center));
    printer!.text('----------------------------',
        styles: escu.PosStyles(align: PosAlign.center));

    // Print items
    for (var orderItem in items) {
      printer!.text(
        '${orderItem.quantity} ${orderItem.item.itemName}', // assuming `itemName` is a property of `Item`
        styles: escu.PosStyles(align: PosAlign.left, bold: true),
      );

      for (var addonOption in orderItem.selectedItemAddonOptions) {
        printer!.text(
          '  ${addonOption.optionName}', // assuming `name` is a property of `ItemAddonOption`
          styles: escu.PosStyles(align: PosAlign.left),
        );
      }
    }

    printer!.feed(2);

    // Print date and time
    printer!.text('----------------------------',
        styles: escu.PosStyles(align: PosAlign.center));
    printer!
        .text('Date: $dateTime', styles: escu.PosStyles(align: PosAlign.left));

    printer!.hr();

    // Feed and cut the paper
    printer!.feed(2);
    printer!.cut();
    printer!.feed(2);

    return Future.value();
  }

  // Connect to a USB printer
  // Future<void> connectToUsbPrinter() async {
  //   try {
  //     int vendorId = int.parse('04B8', radix: 16);
  //     int productId = int.parse('0E32', radix: 16);
  //     await printer.pairDevice(vendorId: vendorId, productId: productId);
  //     print('Connected to USB printer');
  //   } catch (e) {
  //     print('Error connecting to USB printer: $e');
  //   }
  // }

  // Scan for available Bluetooth printers
  // Future<List<BluetoothDevice>> scanForPrinters() async {
  //   List<BluetoothDevice> devices = [];

  //   try {
  //     flutterBlue.startScan(timeout: Duration(seconds: 10));

  //     flutterBlue.scanResults.listen((results) {
  //       for (ScanResult r in results) {
  //         if (!devices.contains(r.device)) {
  //           devices.add(r.device);
  //         }
  //       }
  //     });

  //     await Future.delayed(Duration(seconds: 10));
  //     // flutterBlue.stopScan();
  //   } catch (e) {
  //     print('Error scanning for printers: $e');
  //   }

  //   return devices;
  // }

  // Connect to a Bluetooth printer
  // Future<BluetoothDevice> connectToPrinter(String deviceId) async {
  //   BluetoothDevice? device;

  //   try {
  //     device = await flutterBlue.connectedDevices.then(
  //         (devices) => devices.firstWhere((d) => d.id.toString() == deviceId));

  //     if (device == null) {
  //       List<BluetoothDevice> devices = await flutterBlue.scanResults
  //           .map((results) => results.map((result) => result.device).toList())
  //           .firstWhere(
  //               (devices) => devices.any((d) => d.id.toString() == deviceId),
  //               orElse: () => []);

  //       device = devices.firstWhere((d) => d.id.toString() == deviceId);
  //     }

  //     await device.connect();
  //     await Future.delayed(Duration(seconds: 2));
  //   } catch (e) {
  //     print('Error connecting to printer: $e');
  //     rethrow;
  //   }

  //   return device!;
  // }

  //Print receipt for food order
  // Future<void> printReceipt2(
  //     String deviceId, List<Map<String, dynamic>> items, double total) async {
  //   BluetoothDevice device;

  //   try {
  //     final profile = await CapabilityProfile.load();
  //     final printer = escp.NetworkPrinter(PaperSize.mm80, profile);

  //     final escp.PosPrintResult res =
  //         await printer.connect("192.168.1.30", port: 9100);

  //     if (res == escp.PosPrintResult.success) {
  //       // final receiptData = _generateReceipt(items);
  //       // await printer.(receiptData);
  //       //printer.disconnect();
  //     } else {
  //       print('Could not connect to printer: $res');
  //     }

  //     //final profile = await CapabilityProfile.load();
  //     //final generator = Generator(PaperSize.mm80, profile);
  //     //final receiptData = await _generateReceipt(generator, items, total);

  //     // List<BluetoothService> services = await device.discoverServices();
  //     // BluetoothService? service = services.firstWhere((s) => s.uuid.toString() == "your-service-uuid");

  //     // if (service != null) {
  //     //   BluetoothCharacteristic? characteristic = service.characteristics
  //     //       .firstWhere((c) => c.uuid.toString() == "your-characteristic-uuid");

  //     //   if (characteristic != null) {
  //     //     await characteristic.write(receiptData, withoutResponse: false);
  //     //   }
  //     // }

  //     //final printer = NetworkPrinter(PaperSize.mm80, profile);

  //     //final PosPrintResult res = await printer.connect(printerIp, port: 9100);
  //   } catch (e) {
  //     print('Error printing receipt: $e');
  //   } finally {
  //     // device.disconnect();
  //   }
  // }

  //Generate receipt content
  // Future<List<int>> _generateReceipt2(Generator generator,
  //     List<Map<String, dynamic>> items, double total) async {
  //   final List<int> bytes = [];

  //   bytes.addAll(generator.text(
  //     'Restaurant Name',
  //     styles: PosStyles(
  //       align: PosAlign.center,
  //       height: PosTextSize.size2,
  //       width: PosTextSize.size2,
  //     ),
  //   ));
  //   bytes.addAll(generator.text(
  //     'Address Line 1',
  //     styles: PosStyles(align: PosAlign.center),
  //   ));
  //   bytes.addAll(generator.text(
  //     'Address Line 2',
  //     styles: PosStyles(align: PosAlign.center),
  //   ));
  //   bytes.addAll(generator.text(
  //     'Tel: 123-456-7890',
  //     styles: PosStyles(align: PosAlign.center),
  //   ));
  //   bytes.addAll(generator.hr());

  //   for (var item in items) {
  //     bytes.addAll(generator.row([
  //       PosColumn(
  //         text: item['name'],
  //         width: 6,
  //       ),
  //       PosColumn(
  //         text: '${item['quantity']} x ${item['price']}',
  //         width: 3,
  //         styles: PosStyles(align: PosAlign.right),
  //       ),
  //       PosColumn(
  //         text: '${item['total']}',
  //         width: 3,
  //         styles: PosStyles(align: PosAlign.right),
  //       ),
  //     ]));
  //   }

  //   bytes.addAll(generator.hr());
  //   bytes.addAll(generator.row([
  //     PosColumn(
  //       text: 'TOTAL',
  //       width: 6,
  //       styles: PosStyles(
  //         align: PosAlign.right,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //     ),
  //     PosColumn(
  //       text: '$total',
  //       width: 6,
  //       styles: PosStyles(
  //         align: PosAlign.right,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //     ),
  //   ]));
  //   bytes.addAll(generator.hr(ch: '=', linesAfter: 1));
  //   bytes.addAll(generator.text(
  //     'Thank you!',
  //     styles: PosStyles(align: PosAlign.center, bold: true),
  //   ));

  //   bytes.addAll(generator.feed(2));
  //   bytes.addAll(generator.cut());
  //   return bytes;
  // }

  // Generate receipt content
  Future<List<int>> _generateReceipt(
      List<Map<String, dynamic>> items, double total) async {
    final profile = await escu.CapabilityProfile.load();
    final generator = escu.Generator(escu.PaperSize.mm80, profile);
    final List<int> bytes = [];

    bytes.addAll(generator.text('Restaurant Name',
        styles: escu.PosStyles(
            align: escu.PosAlign.center,
            height: escu.PosTextSize.size2,
            width: escu.PosTextSize.size2)));
    bytes.addAll(generator.text('Address Line 1',
        styles: escu.PosStyles(align: escu.PosAlign.center)));
    bytes.addAll(generator.text('Address Line 2',
        styles: escu.PosStyles(align: escu.PosAlign.center)));
    bytes.addAll(generator.text('Tel: 123-456-7890',
        styles: escu.PosStyles(align: escu.PosAlign.center)));
    bytes.addAll(generator.hr());

    for (var item in items) {
      bytes.addAll(generator.row([
        escu.PosColumn(
          text: item['name'],
          width: 6,
        ),
        escu.PosColumn(
          text: '${item['quantity']} x ${item['price']}',
          width: 3,
          styles: escu.PosStyles(align: escu.PosAlign.right),
        ),
        escu.PosColumn(
          text: '${item['total']}',
          width: 3,
          styles: escu.PosStyles(align: escu.PosAlign.right),
        ),
      ]));
    }

    bytes.addAll(generator.hr());
    bytes.addAll(generator.row([
      escu.PosColumn(
        text: 'TOTAL',
        width: 6,
        styles: escu.PosStyles(
            align: escu.PosAlign.right,
            height: escu.PosTextSize.size2,
            width: escu.PosTextSize.size2),
      ),
      escu.PosColumn(
        text: '$total',
        width: 6,
        styles: escu.PosStyles(
            align: escu.PosAlign.right,
            height: escu.PosTextSize.size2,
            width: escu.PosTextSize.size2),
      ),
    ]));
    bytes.addAll(generator.hr(ch: '=', linesAfter: 1));
    bytes.addAll(generator.text('Thank you!',
        styles: escu.PosStyles(align: escu.PosAlign.center, bold: true)));

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }
}

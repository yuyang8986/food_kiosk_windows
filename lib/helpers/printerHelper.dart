import 'dart:async';
import 'dart:typed_data';

// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/src/capability_profile.dart';
import 'package:esc_pos_utils/src/enums.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart' as escu;
import 'package:flutter_blue_plugin/flutter_blue_plugin.dart';
// import 'package:printing/printing.dart';
import 'package:usb_thermal_printer_web/usb_thermal_printer_web.dart';
// import 'package:flutter_blue/flutter_blue.dart';

class PrinterHelper {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  WebThermalPrinter _printer = WebThermalPrinter();

  Future<void> printReceipt(
      String printerIp, List<Map<String, dynamic>> items, double total) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      // final receiptData = await _generateReceipt(items, 100);
      //await printer.rawBytes(receiptData);
      await testReceipt(printer);
      // printer.disconnect();
    } else {
      print('Could not connect to printer: $res');
    }
  }

Future<void> testReceipt(NetworkPrinter printer) {
  // printer.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  // printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
  //     styles: escu.PosStyles(codeTable: 'CP1252'));
  // printer.text('Special 2: blåbærgrød',
  //     styles: PosStyles(codeTable: 'CP1252'));

  // printer.text('Bold text', styles: PosStyles(bold: true));
  // printer.text('Reverse text', styles: PosStyles(reverse: true));
  // printer.text('Underlined text',
  //     styles: PosStyles(underline: true), linesAfter: 1);
  // printer.text('Align left', styles: PosStyles(align: PosAlign.left));
  // printer.text('Align center', styles: PosStyles(align: PosAlign.center));
  // printer.text('Align right',
  //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');
    printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');
  printer.text('Text size 200%');

  printer.feed(2);
  // printer.cut();
  return Future.value();
}

  // Connect to a USB printer
  Future<void> connectToUsbPrinter() async {
    try {
      int vendorId = int.parse('04B8', radix: 16);
      int productId = int.parse('0E32', radix: 16);
      await _printer.pairDevice(vendorId: vendorId, productId: productId);
      print('Connected to USB printer');
    } catch (e) {
      print('Error connecting to USB printer: $e');
    }
  }

  // Scan for available Bluetooth printers
  Future<List<BluetoothDevice>> scanForPrinters() async {
    List<BluetoothDevice> devices = [];

    try {
      flutterBlue.startScan(timeout: Duration(seconds: 10));

      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (!devices.contains(r.device)) {
            devices.add(r.device);
          }
        }
      });

      await Future.delayed(Duration(seconds: 10));
      flutterBlue.stopScan();
    } catch (e) {
      print('Error scanning for printers: $e');
    }

    return devices;
  }

  // Connect to a Bluetooth printer
  Future<BluetoothDevice> connectToPrinter(String deviceId) async {
    BluetoothDevice? device;

    try {
      device = await flutterBlue.connectedDevices.then(
          (devices) => devices.firstWhere((d) => d.id.toString() == deviceId));

      if (device == null) {
        List<BluetoothDevice> devices = await flutterBlue.scanResults
            .map((results) => results.map((result) => result.device).toList())
            .firstWhere(
                (devices) => devices.any((d) => d.id.toString() == deviceId),
                orElse: () => []);

        device = devices.firstWhere((d) => d.id.toString() == deviceId);
      }

      await device.connect();
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      print('Error connecting to printer: $e');
      rethrow;
    }

    return device!;
  }

  //Print receipt for food order
  // Future<void> printReceipt2(
  //     String deviceId, List<Map<String, dynamic>> items, double total) async {
  //   BluetoothDevice device;

  //   try {
  //     final profile = await CapabilityProfile.load();
  //     final printer = NetworkPrinter(PaperSize.mm80, profile);

  //     final PosPrintResult res = await printer.connect("192.168.1.30", port: 9100);

  //     if (res == PosPrintResult.success) {
  //       final receiptData = _generateReceipt(items);
  //       // await printer.printRaw(receiptData);
  //       printer.disconnect();
  //     } else {
  //       print('Could not connect to printer: $res');
  //     }

  //     final profile = await CapabilityProfile.load();
  //     final generator = Generator(PaperSize.mm80, profile);
  //     final receiptData = await _generateReceipt(generator, items, total);

  //     // List<BluetoothService> services = await device.discoverServices();
  //     // BluetoothService? service = services.firstWhere((s) => s.uuid.toString() == "your-service-uuid");

  //     // if (service != null) {
  //     //   BluetoothCharacteristic? characteristic = service.characteristics
  //     //       .firstWhere((c) => c.uuid.toString() == "your-characteristic-uuid");

  //     //   if (characteristic != null) {
  //     //     await characteristic.write(receiptData, withoutResponse: false);
  //     //   }
  //     // }

  //     final printer = NetworkPrinter(PaperSize.mm80, profile);

  //     final PosPrintResult res = await printer.connect(printerIp, port: 9100);
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
  Future<List<int>> _generateReceipt(List<Map<String, dynamic>> items, double total)async {
    final profile = await escu.CapabilityProfile.load();
    final generator = escu.Generator(escu.PaperSize.mm80, profile);
    final List<int> bytes = [];

    bytes.addAll(generator.text('Restaurant Name',
        styles: escu.PosStyles(align: escu.PosAlign.center, height: escu.PosTextSize.size2, width: escu.PosTextSize.size2)));
    bytes.addAll(generator.text('Address Line 1', styles: escu.PosStyles(align: escu.PosAlign.center)));
    bytes.addAll(generator.text('Address Line 2', styles: escu.PosStyles(align: escu.PosAlign.center)));
    bytes.addAll(generator.text('Tel: 123-456-7890', styles: escu.PosStyles(align: escu.PosAlign.center)));
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
        styles: escu.PosStyles(align: escu.PosAlign.right, height: escu.PosTextSize.size2, width: escu.PosTextSize.size2),
      ),
      escu.PosColumn(
        text: '$total',
        width: 6,
        styles: escu.PosStyles(align: escu.PosAlign.right, height: escu.PosTextSize.size2, width: escu.PosTextSize.size2),
      ),
    ]));
    bytes.addAll(generator.hr(ch: '=', linesAfter: 1));
    bytes.addAll(generator.text('Thank you!', styles: escu.PosStyles(align: escu.PosAlign.center, bold: true)));

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

}

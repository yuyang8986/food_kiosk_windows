import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
// import 'package:flutter_blue_plugin/flutter_blue_plugin.dart';
// import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:mcdo_ui/helpers/printerHelper.dart';
import 'package:mcdo_ui/printerConnectionpage.dart';
import 'package:mcdo_ui/printer_info.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:window_manager/window_manager.dart';
import 'chooser.dart';
// import 'animationTest.dart';
import 'package:android_usb_printer/android_usb_printer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
  // Must add this line.
  // await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  // windowManager.waitUntilReadyToShow().then((_) async {
  //   // Hide window title bar
  //   // await windowManager.setTitleBarStyle('hidden');
  //   await windowManager.setFullScreen(true);
  //   await windowManager.center();
  //   await windowManager.show();
  //   await windowManager.setSkipTaskbar(false);
  // });

  // final supported = FlutterWebBluetooth.instance.isBluetoothApiSupported;
  // print("web printer" + supported.toString());
  // A stream that says if a bluetooth adapter is available to the browser.
  // final available = FlutterWebBluetooth.instance.isAvailable;
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(), // Set RootPage as the home
    );
  }
}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(30.0)),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Text(
            "TOUCH TO START",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PrinterHelper _printerHelper = PrinterHelper();
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  List _devices = [];
  String? _selectedDeviceId;

  var selectedPrinterInfo;

  // Future<void> _scanForPrinters() async {
  //   var devices = await _printerHelper.scanForPrinters();
  //   setState(() {
  //     _devices = devices;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _showSettingsDialog() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Settings"),
           content:
           // PrintImageGenerateWidget(
          //   contentBuilder: (context) {
          //     return 
              Text("Scan USB printers")
            // },
            // onPictureGenerated: _onPictureGenerated, //下面说明
          ,
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Scan"),
              onPressed: () async {
                var printerInfo = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrinterListPage(SearchType.usb),
                  ),
                );

                selectedPrinterInfo = printerInfo;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 60.0,
            child: Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   child: Image.asset(
                  //     'assets/US.png',
                  //     height: 28,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Spacer(flex: 5),
                    ButtonTheme(
                      minWidth: 130.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(30.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Dine In",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onPressed: () async {
                          // First, check if selectedPrinterInfo is null or empty
                          if (selectedPrinterInfo == null) {
                            // Try to fetch the printer info from local storage
                            PrinterInfo? storedPrinterInfo =
                                await getPrinterInfoFromStorage();

                            if (storedPrinterInfo != null) {
                              // If found in local storage, assign it to selectedPrinterInfo
                              selectedPrinterInfo = storedPrinterInfo;
                            }
                          }

                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Chooser(
                                    type: "Dine In",
                                    printerInfo: selectedPrinterInfo,
                                  )));
                        },
                      ),
                    ),
                    Spacer(),
                    ButtonTheme(
                      minWidth: 180.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(30.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Take Away",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Chooser(
                                    type: "Take Away",
                                    printerInfo: selectedPrinterInfo,
                                  )));
                        },
                      ),
                    ),
                    Spacer(flex: 5),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: _showSettingsDialog,
              child: Icon(Icons.settings),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

//Function to save PrinterInfo object to local storage
  Future<void> savePrinterInfoToStorage(PrinterInfo printerInfo) async {
    final prefs = await SharedPreferences.getInstance();

    // Prepare data to store in SharedPreferences
    Map<String, dynamic> printerInfoMap = {
      'ip': printerInfo.ip,
      'usbDevice': printerInfo.usbDevice != null
          ? {
              'productName': printerInfo.usbDevice!.productName,
              'vId': printerInfo.usbDevice!.vId,
              'pId': printerInfo.usbDevice!.pId,
              'sId': printerInfo.usbDevice!.sId,
            }
          : null,
    };

    // Convert the map to a JSON string and store it
    String printerInfoJson = jsonEncode(printerInfoMap);
    await prefs.setString('selectedPrinterInfo', printerInfoJson);
  }

// Function to get PrinterInfo object from local storage
  Future<PrinterInfo?> getPrinterInfoFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? printerInfoJson = prefs.getString('selectedPrinterInfo');

    if (printerInfoJson != null && printerInfoJson.isNotEmpty) {
      Map<String, dynamic> printerInfoMap = jsonDecode(printerInfoJson);

      // Recreate PrinterInfo object
      if (printerInfoMap['ip'] != null) {
        return PrinterInfo.fromIp(printerInfoMap['ip']);
      } else if (printerInfoMap['usbDevice'] != null) {
        return PrinterInfo.fromUsbDevice(UsbDeviceInfo(
          productName: printerInfoMap['usbDevice']['productName'],
          vId: printerInfoMap['usbDevice']['vId'],
          pId: printerInfoMap['usbDevice']['pId'],
          sId: printerInfoMap['usbDevice']['sId'],
        ));
      }
    }
    return null;
  }
}

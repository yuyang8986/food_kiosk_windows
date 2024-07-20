import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue_plugin/flutter_blue_plugin.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:mcdo_ui/helpers/printerHelper.dart';
// import 'package:quick_blue/quick_blue.dart';
import 'package:window_manager/window_manager.dart';
import 'chooser.dart';
import 'package:flutter/services.dart';
import 'animationTest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
  // Must add this line.
  await windowManager.ensureInitialized();

// Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async {
// Hide window title bar
// await windowManager.setTitleBarStyle('hidden');
    await windowManager.setFullScreen(true);
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });

  // QuickBlue.setValueHandler((deviceId, characteristicId, value) { });
  // QuickBlue.setConnectionHandler((deviceId, state) { });
  // QuickBlue.setServiceHandler((deviceId, serviceId) { });

  final supported = FlutterWebBluetooth.instance.isBluetoothApiSupported;
  print("web printer" + supported.toString());
  // A stream that says if a bluetooth adapter is available to the browser.
  final available = FlutterWebBluetooth.instance.isAvailable;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PrinterHelper _printerHelper = PrinterHelper();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List _devices = [];
  String? _selectedDeviceId;
  // StreamSubscription<BlueScanResult>? _subscription;

  Future<void> _scanForPrinters() async {
    var devices = await _printerHelper.scanForPrinters();
    setState(() {
      _devices = devices;
    });
  }

  void _printReceipt() {
    if (_selectedDeviceId != null) {
      List<Map<String, dynamic>> items = [
        {'name': 'Burger', 'quantity': 2, 'price': 5.0, 'total': 10.0},
        {'name': 'Fries', 'quantity': 1, 'price': 3.0, 'total': 3.0},
      ];
      double total = 13.0;

      _printerHelper.printReceipt(_selectedDeviceId!, items, total);
    }
  }

  // var _scanResults = <BlueScanResult>[];

  @override
  void dispose() {
    super.dispose();
    // _subscription?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //     QuickBlue.setValueHandler((deviceId, characteristicId, value) { });
    // QuickBlue.setConnectionHandler((deviceId, state) { });
    // QuickBlue.setServiceHandler((deviceId, serviceId) { });
    //   _subscription = QuickBlue.scanResultStream.listen((result) {
    //     if (!_scanResults.any((r) => r.deviceId == result.deviceId)) {
    //       setState(() => _scanResults.add(result));
    //     }
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(239, 236, 222, 1),
        body: Stack(children: [
          Positioned(
              top: 60.0,
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                width: MediaQuery.of(context).size.width,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   child: Image.asset(
                  //     'assets/US.png',
                  //     height: 28,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ]),
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  height: 140.0,
                  fit: BoxFit.cover,
                ),
                //      FutureBuilder(
                //   future: QuickBlue.isBluetoothAvailable(),
                //   builder: (context, snapshot) {
                //     var available = snapshot.data?.toString() ?? '...';
                //     return Text('Bluetooth init: $available');
                //   },
                // ),
                // Text("Where will you be eating today ?",
                //     textAlign: TextAlign.center,
                //     style:
                //         TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ElevatedButton(
                  // color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("connect printer",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                  onPressed: () async {
                    // await _scanForPrinters();
                    // _printerHelper.connectToPrinter("A6:D7:3C:A3:C8:DF");
                    // _printerHelper.connectToUsbPrinter();
                    // _printerHelper.findPrinters();
                    List<Map<String, dynamic>> items = [
                      {
                        'name': 'Burger',
                        'quantity': 2,
                        'price': 5.0,
                        'total': 10.0
                      },
                      {
                        'name': 'Fries',
                        'quantity': 1,
                        'price': 3.0,
                        'total': 3.0
                      },
                    ];
                    double total = 13.0;
                    _printerHelper.printReceipt("192.168.1.30", items, total);
                  },
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: new BorderRadius.circular(20.0)
                  //     )
                ),

                DropdownButton<String>(
                  hint: Text('Select Printer'),
                  value: _selectedDeviceId,
                  onChanged: (String? deviceId) {
                    setState(() {
                      _selectedDeviceId = deviceId;
                    });
                  },
                  items: _devices.map((device) {
                    return DropdownMenuItem<String>(
                      value: device.deviceId,
                      child: Text(device.name ?? 'Unknown Device'),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _printReceipt,
                  child: Text('Print Receipt'),
                ),
                Row(children: <Widget>[
                  Spacer(flex: 5),
                  ButtonTheme(
                      minWidth: 130.0,
                      height: 165.0,
                      child: ElevatedButton(
                        // color: Colors.white,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/dinein.png',
                                height: 80.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10.0),
                              // Text("Dine In",
                              //     style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Chooser(type: "Dine In")));
                        },
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(20.0)
                        //     )
                      )),
                  Spacer(),
                  ButtonTheme(
                      minWidth: 180.0,
                      height: 285.0,
                      child: ElevatedButton(
                        // color: Colors.white,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/takeaway.jpg',
                                height: 80.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10.0),
                              // Text("Take Away",
                              //     style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Chooser(type: "Take Away")));
                        },
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Anim()));},
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(20.0))
                      )),
                  Spacer(flex: 5),
                ]),
              ],
            ),
          ),
        ]));
  }
}

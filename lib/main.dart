import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plugin/flutter_blue_plugin.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:mcdo_ui/helpers/printerHelper.dart';
import 'package:window_manager/window_manager.dart';
import 'chooser.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
      home: RootPage(),  // Set RootPage as the home
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
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List _devices = [];
  String? _selectedDeviceId;

  Future<void> _scanForPrinters() async {
    var devices = await _printerHelper.scanForPrinters();
    setState(() {
      _devices = devices;
    });
  }

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
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter your text"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                print("Entered text: ${_controller.text}");
                PrinterHelper.setPrinterIP(_controller.text);
                Navigator.of(context).pop();
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
      backgroundColor: Color.fromRGBO(239, 236, 222, 1),
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
                Image.asset(
                  'assets/logo.png',
                  height: 140.0,
                  fit: BoxFit.cover,
                ),
                Row(
                  children: <Widget>[
                    Spacer(flex: 5),
                    ButtonTheme(
                      minWidth: 130.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(30.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Dine In",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Chooser(type: "Dine In")));
                        },
                      ),
                    ),
                    Spacer(),
                    ButtonTheme(
                      minWidth: 180.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(30.0)),
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
                              builder: (context) => Chooser(type: "Take Away")));
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
}

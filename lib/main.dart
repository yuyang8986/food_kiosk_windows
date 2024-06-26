import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:window_manager/window_manager.dart';
import 'chooser.dart';
import 'package:flutter/services.dart';
import 'animationTest.dart';

void main() async{
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
                // Text("Where will you be eating today ?",
                //     textAlign: TextAlign.center,
                //     style:
                //         TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
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

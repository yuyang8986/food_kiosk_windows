import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
// import 'package:flutter_blue_plugin/flutter_blue_plugin.dart';
// import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:mcdo_ui/helpers/printerHelper.dart';
import 'package:mcdo_ui/printerConnectionpage.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
import 'package:window_manager/window_manager.dart';
import 'chooser.dart';
import 'package:flutter/services.dart';
// import 'animationTest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  // Must add this line.
  await windowManager.ensureInitialized();

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
          content: PrintImageGenerateWidget(
            contentBuilder: (context) {
              return Text("Hellllllllllllllllllllllllllllllllllo");
            },
            onPictureGenerated: _onPictureGenerated, //下面说明
          ),
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
                // print("Entered text: ${_controller.text}");
                // PrinterHelper.setPrinterIP(_controller.text);
                // Navigator.of(context).pop();

                // PrinterHelper.getusbDeviceslist();
                // var printData = await PrinterCommandTool.generatePrintCmd(
                //   imgData: imageBytes,
                //   printType: PrintTypeEnum.label,
                // );

                // doPrint();
                 Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrinterListPage(SearchType.usb),
                  ),
                );
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
                // Image.asset(
                //   'assets/logo.png',
                //   height: 140.0,
                //   fit: BoxFit.cover,
                // ),
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
                              builder: (context) =>
                                  Chooser(type: "Take Away")));
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

  ///例如：将 ReceiptStyleWidget 转打印图层
  void doPrint(printerInfo) {
    // 生成打印图层任务，指定任务类型为小票
    PictureGeneratorProvider.instance.addPicGeneratorTask(
      PicGenerateTask(
        tempWidget: ReceiptTemp('小票内容') as ATempWidget,
        printTypeEnum: PrintTypeEnum.receipt,
        params: printerInfo,
      ),
    );
  }

// //打印图层生成成功
//   Future<void> _onPictureGenerated(PicGenerateResult data) async {
//     //widget生成的图像结果
//     final imageBytes = data.image;
//     //打印任务信息
//     final printTask = data.taskItem;
//     //打印票据类型（标签、小票）
//     final printTypeEnum = printTask.printTypeEnum;
//     final dataByte = await imageBytes!.toByteData();
//     // 转 TSC 字节，imageBytes 类型为 Uint8List
//     var printData = await PrinterCommandTool.generatePrintCmd(
//       imgData: dataByte as Uint8List,
//       printType: PrintTypeEnum.label,
//     );
//   }
// }

//打印图层生成成功
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

//   void doPrint() {
//   // 生成打印图层任务，指定任务类型为小票
//   PictureGeneratorProvider.instance.addPicGeneratorTask(
//     PicGenerateTask(
//       tempWidget: ReceiptConstrainedBox(ReceiptStyleWidget()) as ATempWidget, //ReceiptConstrainedBox 封装了小票宽高的限制条件
//       printTypeEnum: PrintTypeEnum.receipt,
//       params: printerInfo, //params是一个透传值，可以是任意类型，example中 params 携带的是打印机数据，在 _onPictureGenerated 中跟随生成的打印图层可被获取到
//     ),
//   );
// }
}

// ///生成打印的模板 Widget 需要继承这个类
// mixin ATempWidget {
//   //生成图片的缩放倍数
//   double get pixelRatio => 1;

//   //需要生成的票据像素宽度
//   int get pixelPagerWidth;

//   //需要生成的票据像素高度
//   int get pixelPagerHeight => -1;
// }

///例如：将 ReceiptStyleWidget 转打印图层

// 使用widget编写需要的小票样式，以下是样例
class ReceiptStyleWidget extends StatefulWidget {
  const ReceiptStyleWidget({
    Key? key,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '测试打印小票',
          style: TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ///生成打印的模板 Widget 需要继承这个类
// mixin ATempWidget {
//   //生成图片的缩放倍数
//   double get pixelRatio => 1;

//   //需要生成的票据像素宽度
//   int get pixelPagerWidth;

//   //需要生成的票据像素高度
//   int get pixelPagerHeight => -1;
// }

// 小票样式 demo
class ReceiptTemp extends StatelessWidget with ATempWidget {
  final String data;

  const ReceiptTemp(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Text(data),
    );
  }

  @override
  int get pixelPagerWidth => 550;

  // 小票不限制高度，pixelPagerHeight = -1 就行，无需重写
}

import 'package:mcdo_ui/models/orderItem.dart';

class Order {
  // int orderId;
  String orderName;
  String orderDescription;
  double orderPrice;
  String orderType;
  // String orderDateTime;
  List<OrderItem> orderItems;

  Order({
    // required this.orderId,
    required this.orderName,
    required this.orderDescription,
    required this.orderPrice,
    required this.orderType,
    // required this.orderDateTime,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        // orderId: json['orderId'],
        orderName: json['orderName'],
        orderDescription: json['orderDescription'],
        orderPrice: json['orderPrice'],
        orderType: json['orderType'],
        // orderDateTime: json['orderDateTime'],
        orderItems: []);
  }

  Map<String, dynamic> toJson() {
    return {
      // 'orderId': orderId,
      // 'orderName': orderName,
      // 'orderDescription': orderDescription,
      // 'orderPrice': orderPrice,
      'orderType': orderType,
      // 'orderDateTime': orderDateTime,
      'orderItems': orderItems.map((oi) => oi.toJson()).toList(),
    };
  }
}


/// usb 设备信息
class UsbDeviceInfo {
  final String productName;
  final int vId;
  final int pId;
  final String sId;
  final int position;

  UsbDeviceInfo({
    required this.productName,
    required this.vId,
    required this.pId,
    required this.sId,
    this.position = 0,
  });

  factory UsbDeviceInfo.fromMap(Map<String, dynamic> map) {
    return UsbDeviceInfo(
      productName: map["productName"],
      vId: map["vId"],
      pId: map["pId"],
      sId: map["sId"],
      position: map.containsKey('position') ? map['position'] : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "productName": productName,
      "vId": vId,
      "pId": pId,
      "sId": sId,
      "position": position,
    };
  }

  String get id => "$vId-$pId-$sId";
}


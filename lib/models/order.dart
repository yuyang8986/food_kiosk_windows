class Order {
  int orderId;
  String orderName;
  String orderDescription;
  double orderPrice;
  String orderType;
  String orderDateTime;

  Order({
    required this.orderId,
    required this.orderName,
    required this.orderDescription,
    required this.orderPrice,
    required this.orderType,
    required this.orderDateTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      orderName: json['orderName'],
      orderDescription: json['orderDescription'],
      orderPrice: json['orderPrice'],
      orderType: json['orderType'],
      orderDateTime: json['orderDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'orderDescription': orderDescription,
      'orderPrice': orderPrice,
      'orderType': orderType,
      'orderDateTime': orderDateTime,
    };
  }
}

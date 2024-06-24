import 'item.dart';
import 'order.dart';

class OrderItem {
  int orderItemId;
  int orderId;
  int itemId;
  Item item;
  Order order;

  OrderItem({
    required this.orderItemId,
    required this.orderId,
    required this.itemId,
    required this.item,
    required this.order,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['orderItemId'],
      orderId: json['orderId'],
      itemId: json['itemId'],
      item: Item.fromJson(json['item']),
      order: Order.fromJson(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'orderId': orderId,
      'itemId': itemId,
      'item': item.toJson(),
      'order': order.toJson(),
    };
  }
}

import 'package:mcdo_ui/models/item-addon-option.dart';

import 'item.dart';
import 'order.dart';

class OrderItem {
  // int orderItemId;
  // int orderId;
  // int itemId;
  Item item;
  Order order;
  int quantity;
  List<ItemAddonOption> selectedItemAddonOptions = [];

  OrderItem({
    // required this.orderItemId,
    // required this.orderId,
    // required this.itemId,
    required this.item,
    required this.order,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      // orderItemId: json['orderItemId'],
      // orderId: json['orderId'],
      // itemId: json['itemId'],
      item: Item.fromJson(json['item']),
      order: Order.fromJson(json['order']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'orderItemId': orderItemId,
      // 'orderId': orderId,
      'itemId': item.itemId,
      // 'item': item.toJson(),
      // 'order': order.toJson(),
      'quantity': quantity,
      'itemPrice': item.itemPrice,
      'itemAddonOptions':
          selectedItemAddonOptions.map((iao) => iao.optionId).toList(),
    };
  }

  double getTotalPrice() {
    double totalPricePerItem = item.itemPrice;
    for (var option in selectedItemAddonOptions) {
      if (option.price > 0) {
        totalPricePerItem += option.price;
      }
    }
    return totalPricePerItem * quantity;
  }

  void remove(int quantityToRemove) {
    quantity -= quantityToRemove;
    if (quantity < 0) {
      quantity = 0;
    }
  }

  void add() {
    quantity += 1;
  }
}

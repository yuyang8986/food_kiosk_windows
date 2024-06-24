import 'package:mcdo_ui/models/item-addon.dart';

class Item {
  int itemId;
  String itemName;
  String itemDescription;
  double itemPrice;
  String itemType;
  int itemCategoryId;
  List<int> itemImage;
  List<ItemAddon> itemAddons;

  Item({
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemType,
    required this.itemCategoryId,
    required this.itemImage,
    required this.itemAddons,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      itemPrice: json['itemPrice'],
      itemType: json['itemType'],
      itemCategoryId: json['itemCategoryId'],
      itemImage: List<int>.from(json['itemImage']),
      itemAddons: (json['itemAddons'] as List)
          .map((ia) => ItemAddon.fromJson(ia))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemType': itemType,
      'itemCategoryId': itemCategoryId,
      'itemImage': itemImage,
      'itemAddons': itemAddons.map((ia) => ia.toJson()).toList(),
    };
  }
}

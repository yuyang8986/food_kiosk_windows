import 'package:mcdo_ui/models/item.dart';

class ItemCategory {
  int itemCategoryId;
  String itemCategoryName;
  String itemCategoryDescription;
  List<int> categoryImage;
  List<Item> items;

  ItemCategory({
    required this.itemCategoryId,
    required this.itemCategoryName,
    required this.itemCategoryDescription,
    required this.categoryImage,
    required this.items,
  });

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      itemCategoryId: json['itemCategoryId'],
      itemCategoryName: json['itemCategoryName'],
      itemCategoryDescription: json['itemCategoryDescription'],
      categoryImage: List<int>.from(json['categoryImage']),
      items: (json['items'] as List).map((i) => Item.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemCategoryId': itemCategoryId,
      'itemCategoryName': itemCategoryName,
      'itemCategoryDescription': itemCategoryDescription,
      'categoryImage': categoryImage,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

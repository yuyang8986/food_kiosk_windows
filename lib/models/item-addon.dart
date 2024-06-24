import 'package:mcdo_ui/models/item-addon-option.dart';

class ItemAddon {
  int itemAddonId;
  String itemAddonName;
  String itemAddonDescription;
  int itemId;
  List<ItemAddonOption> itemAddonOptions;

  ItemAddon({
    required this.itemAddonId,
    required this.itemAddonName,
    required this.itemAddonDescription,
    required this.itemId,
    required this.itemAddonOptions,
  });

  factory ItemAddon.fromJson(Map<String, dynamic> json) {
    return ItemAddon(
      itemAddonId: json['itemAddonId'],
      itemAddonName: json['itemAddonName'],
      itemAddonDescription: json['itemAddonDescription'],
      itemId: json['itemId'],
      itemAddonOptions: (json['itemAddonOptions'] as List)
          .map((iao) => ItemAddonOption.fromJson(iao))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemAddonId': itemAddonId,
      'itemAddonName': itemAddonName,
      'itemAddonDescription': itemAddonDescription,
      'itemId': itemId,
      'itemAddonOptions': itemAddonOptions.map((iao) => iao.toJson()).toList(),
    };
  }
}

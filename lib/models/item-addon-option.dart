class ItemAddonOption {
  int optionId;
  String optionName;
  String optionDescription;
  double price;
  int itemAddonId;

  ItemAddonOption({
    required this.optionId,
    required this.optionName,
    required this.optionDescription,
    required this.price,
    required this.itemAddonId,
  });

  // Add a static placeholder option
  static final ItemAddonOption placeholder = ItemAddonOption(
    optionId: -1, // Using a negative ID for the placeholder
    optionName: 'Please choose',
    optionDescription: '',
    price: 0.0,
    itemAddonId: -1,
  );

  factory ItemAddonOption.fromJson(Map<String, dynamic> json) {
    return ItemAddonOption(
      optionId: json['optionId'],
      optionName: json['optionName'],
      optionDescription: json['optionDescription'],
      price: json['price'],
      itemAddonId: json['itemAddonId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': optionId,
      'optionName': optionName,
      'optionDescription': optionDescription,
      'price': price,
      'itemAddonId': itemAddonId,
    };
  }

  @override
  String toString() {
    return 'ItemAddonOption(optionId: $optionId, optionName: $optionName, price: $price)';
  }

 bool isPlaceholder() {

    return this.optionId == -1;

  }
}

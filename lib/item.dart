class Item {
  String name;
  String img;
  String category;
  int quantity;
  String sugarLevel;
  Map<String, bool> addOns;
  Map<String, double> addOnPrices;

  Item(this.name, this.img, this.category, {
    this.quantity = 1,
    this.sugarLevel = "Medium", 
    Map<String, bool>? addOns,
    Map<String, double>? addOnPrices
  }) : this.addOns = addOns ?? {
      'Cookie': false,
      'Marshmallow': false,
      'Chocolate': false
    },
    this.addOnPrices = addOnPrices ?? {
      'Cookie': 11.0, 
      'Marshmallow': 11.0,
      'Chocolate': 11.0
    };

   String generateConfigurationKey() {
    List<String> sortedAddOns = addOns.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key) 
        .toList()..sort();    
    return '$name|${sortedAddOns.join(":")}';
  }

  String getName() => name;

  String getImg() => img;

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) quantity--;
  }

  void setSugarLevel(String level) {
    sugarLevel = level;
  }

  void toggleAddOn(String addOn) {
    if (addOns.containsKey(addOn)) {
      addOns[addOn] = !addOns[addOn]!;
    } else {
      addOns[addOn] = true;
    }
  }

  double getTotalPrice() {
    double totalPrice = 100.0;
    addOns.forEach((addOn, included) {
      if (included) {
        totalPrice += addOnPrices[addOn]!; 
        print('Adding $addOn: ${addOnPrices[addOn]}');
      }
    });
    return totalPrice * quantity;
  }
}


class Category {
  String name; //ID Unique de l'image
  String img;

  getName() {
    return name;
  }

  getImg() {
    return img;
  }

  Category(this.name, this.img);
}

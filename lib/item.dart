class Item {
  String name;
  String img;
  String category;
  int quantity;
  int sugarLevel;
  Map<String, bool> addOns; 
  Map<String, double> addOnPrices;

  Item(this.name, this.img, this.category, {
      this.quantity = 1,
      this.sugarLevel = 1,
      Map<String, bool>? addOns,
      Map<String, double>? addOnPrices
  }) : this.addOns = addOns ?? {},
       this.addOnPrices = addOnPrices ?? {
         'Cookie': 11.0,
         'Marshmallow': 11.0,
         'Chocolate': 11.0
       };

  String getName() => name;

  String getImg() => img;

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) quantity--;
  }

  void setSugarLevel(int level) {
    sugarLevel = level;
  }

  void toggleAddOn(String addOn) {
    if (addOns.containsKey(addOn)) {
      addOns[addOn] = !addOns[addOn]!;
    }
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    totalPrice += 100.0;

    addOns.forEach((addOn, included) {
      if (included) {
        totalPrice += addOnPrices[addOn]!;
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

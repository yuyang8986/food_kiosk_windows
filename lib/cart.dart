class Cart {
  String name; //ID Unique de l'image
  String img;
  double price;
  int qtt;
  String sugarLevel;
  Map<String, double> addOns;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
      'price': price,
      'qtt': qtt,
      'sugarLevel': sugarLevel,
      'addOns': addOns,
    };
  }

  static Cart fromJson(Map<String, dynamic> json) {
    return Cart(
      json['name'],
      json['img'],
      json['price'].toDouble(),
      json['qtt'],
      json['sugarLevel'],
      Map<String, double>.from(json['addOns'])
    );
  }

  getTotalPrice() {
    // return price*qtt;
    return price;
  }

  // double getTotalPrice() {
  //   double addOnsTotal = addOns.values.fold(0, (sum, price) => sum + price);
  //   return price + addOnsTotal;
  // }

  add() {
    qtt=qtt+1;
  }

  remove() {
    qtt=qtt-1;
  }


  Cart(this.name, this.img, this.price, this.qtt, this.sugarLevel, this.addOns);
}
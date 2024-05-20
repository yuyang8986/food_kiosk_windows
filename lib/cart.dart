class Cart {
  String name; //ID Unique de l'image
  String img;
  double price;
  int qtt;
  String sugarLevel;
  Map<String, bool> addOns;
  String configKey;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
      'price': price,
      'qtt': qtt,
      'sugarLevel': sugarLevel,
      'addOns': addOns,
      'configKey': configKey,
    };
  }

  static Cart fromJson(Map<String, dynamic> json) {
    return Cart(
      json['name'],
      json['img'],
      json['price'].toDouble(),
      json['qtt'],
      json['sugarLevel'],
      Map<String, bool>.from(json['addOns']),
      json['configKey']?? '',
    );
  }

  getTotalPrice() {
    return price*qtt;
  }

  add() {
    qtt=qtt+1;
  }

  remove() {
    qtt=qtt-1;
  }


  Cart(this.name, this.img, this.price, this.qtt, this.sugarLevel, this.addOns, this.configKey);
}
class Item {
  String name; //ID Unique de l'image
  String img;
  String category;

  getName() {
    return name;
  }

  getImg() {
    return img;
  }

  Item(this.name, this.img, this.category);
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

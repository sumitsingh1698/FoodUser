class Pricing {
  int id;
  String size;
  int totalQuantity;
  double price;

  Pricing({this.id, this.size, this.totalQuantity, this.price});

  Pricing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    totalQuantity = json['total_quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['total_quantity'] = this.totalQuantity;
    data['price'] = this.price;
    return data;
  }
}

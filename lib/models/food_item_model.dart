class CartUploadModel {
  double total;
  List<Cartitems> cartitems;

  CartUploadModel({this.total, this.cartitems});

  CartUploadModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['cartitems'] != null) {
      cartitems = new List<Cartitems>();
      json['cartitems'].forEach((v) {
        cartitems.add(new Cartitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.cartitems != null) {
      data['cartitems'] = this.cartitems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cartitems {
  int fooditem;
  int count;
  double price;
  int restuarantId;

  Cartitems({this.fooditem, this.count, this.price, this.restuarantId});

  Cartitems.fromJson(Map<String, dynamic> json) {
    fooditem = json['fooditem'];
    count = json['count'];
    price = json['price'];
    restuarantId = json['restuarantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fooditem'] = this.fooditem;
    data['count'] = this.count;
    data['price'] = this.price;
    data['restuarantId'] = this.restuarantId;
    return data;
  }
}

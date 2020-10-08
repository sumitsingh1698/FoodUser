import 'package:Belly/models/restaurant_detail_model.dart';

class ItemDetailResponse {
  List<Fooditem> fooditem;
  List<Cartitem> cartitem;

  ItemDetailResponse({this.fooditem, this.cartitem});

  ItemDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['fooditem'] != null) {
      fooditem = new List<Fooditem>();
      json['fooditem'].forEach((v) {
        fooditem.add(new Fooditem.fromJson(v));
      });
    }
    if (json['cartitem'] != null) {
      cartitem = new List<Cartitem>();
      json['cartitem'].forEach((v) {
        cartitem.add(new Cartitem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fooditem != null) {
      data['fooditem'] = this.fooditem.map((v) => v.toJson()).toList();
    }
    if (this.cartitem != null) {
      data['cartitem'] = this.cartitem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fooditem {
  int id;
  String name;
  String shortDescription;
  String image;
  int totalQuantity;
  String type;
  String slug;
  String availStatus;
  int restaurant;
  List<Pricing> pricing;

  Fooditem(
      {this.id,
      this.name,
      this.shortDescription,
      this.image,
      this.totalQuantity,
      this.type,
      this.slug,
      this.availStatus,
      this.restaurant,
      this.pricing});

  Fooditem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    image = json['image'];
    totalQuantity = json['total_quantity'];
    type = json['type'];
    slug = json['slug'];
    availStatus = json['avail_status'];
    restaurant = json['restaurant'];
    if (json['pricing'] != null) {
      pricing = new List<Pricing>();
      json['pricing'].forEach((v) {
        pricing.add(new Pricing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    data['total_quantity'] = this.totalQuantity;
    data['type'] = this.type;
    data['slug'] = this.slug;
    data['avail_status'] = this.availStatus;
    data['restaurant'] = this.restaurant;
    if (this.pricing != null) {
      data['pricing'] = this.pricing.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cartitem {
  int id;
  Fooditem fooditem;
  int count;
  int cart;

  Cartitem({this.id, this.fooditem, this.count, this.cart});

  Cartitem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fooditem = json['fooditem'] != null
        ? new Fooditem.fromJson(json['fooditem'])
        : null;
    count = json['count'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.fooditem != null) {
      data['fooditem'] = this.fooditem.toJson();
    }
    data['count'] = this.count;
    data['cart'] = this.cart;
    return data;
  }
}

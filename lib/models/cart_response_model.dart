class CartResponseModel {
  int user;
  double total;
  List<Cartitems> cartitems;
  String tax;
  String minCharge;
  String maxCharge;
  String minCart;
  double restaurantDiscount;

  CartResponseModel(
      {this.user,
      this.total,
      this.cartitems,
      this.tax,
      this.maxCharge,
      this.minCart,
      this.minCharge,
      this.restaurantDiscount});

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    total = json['total'];
    if (json['cartitems'] != null) {
      cartitems = new List<Cartitems>();
      json['cartitems'].forEach((v) {
        cartitems.add(new Cartitems.fromJson(v));
      });
    }
    tax = json['tax'];
    minCharge = json['min_additional_charges'];
    maxCharge = json['max_additional_charges'];
    minCart = json['min_cart'];
    restaurantDiscount = double.parse(json['restaurant_discount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['total'] = this.total;
    if (this.cartitems != null) {
      data['cartitems'] = this.cartitems.map((v) => v.toJson()).toList();
    }
    data['tax'] = this.tax;
    return data;
  }
}

class Cartitems {
  int id;
  Fooditem fooditem;
  int count;
  int cart;

  Cartitems({this.id, this.fooditem, this.count, this.cart});

  Cartitems.fromJson(Map<String, dynamic> json) {
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

class Fooditem {
  int id;
  Restaurant restaurant;
  String name;
  String shortDescription;
  String image;
  double price;
  int totalQuantity;
  String type;
  String slug;
  String availStatus;
  String size;
  int tempCount = 0;

  Fooditem(
      {this.id,
      this.restaurant,
      this.name,
      this.shortDescription,
      this.image,
      this.price,
      this.totalQuantity,
      this.type,
      this.slug,
      this.availStatus,
      this.size});

  Fooditem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    name = json['name'];
    shortDescription = json['short_description'];
    image = json['image'];
    price = json['price'];
    totalQuantity = json['total_quantity'];
    type = json['type'];
    slug = json['slug'];
    availStatus = json['avail_status'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    data['price'] = this.price;
    data['total_quantity'] = this.totalQuantity;
    data['type'] = this.type;
    data['slug'] = this.slug;
    data['avail_status'] = this.availStatus;
    data['size'] = this.size;
    return data;
  }
}

class Restaurant {
  String name;
  String campus;
  int id;

  Restaurant({this.name, this.campus, this.id});

  Restaurant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    campus = json['campus'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['campus'] = this.campus;
    data['id'] = this.id;
    return data;
  }
}

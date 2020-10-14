class RestaurantDetailResponse {
  List<Restaurant> restaurant;
  List<Single> single;
  List<Set> set;
  List<Cart> cart;
  RestaurantDetailResponse({this.restaurant, this.single, this.set, this.cart});

  RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['restaurant'] != null) {
      restaurant = new List<Restaurant>();
      json['restaurant'].forEach((v) {
        restaurant.add(new Restaurant.fromJson(v));
      });
    }
    if (json['single'] != null) {
      single = new List<Single>();
      json['single'].forEach((v) {
        single.add(new Single.fromJson(v));
      });
    }
    if (json['set'] != null) {
      set = new List<Set>();
      json['set'].forEach((v) {
        set.add(new Set.fromJson(v));
      });
    }
    if (json['cart'] != null) {
      cart = new List<Cart>();
      json['cart'].forEach((v) {
        cart.add(new Cart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.map((v) => v.toJson()).toList();
    }
    if (this.single != null) {
      data['single'] = this.single.map((v) => v.toJson()).toList();
    }
    if (this.set != null) {
      data['set'] = this.set.map((v) => v.toJson()).toList();
    }
    if (this.cart != null) {
      data['cart'] = this.cart.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  String name;
  String emailAddress;
  String phone;
  RestaurantLocation restaurantLocation;
  String logo;
  String buildingAddress;
  String availableStatus;
  Campus campus;
  int id;
  String foodType;
  double rating;
  double pricemin;
  double pricemax;
  String preperationtime;
  double discount;
  String fssai;

  Restaurant(
      {this.name,
      this.emailAddress,
      this.phone,
      this.restaurantLocation,
      this.logo,
      this.buildingAddress,
      this.availableStatus,
      this.campus,
      this.id,
      this.foodType,
      this.rating,
      this.preperationtime,
      this.pricemax,
      this.pricemin,
      this.discount,
      this.fssai});

  Restaurant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    emailAddress = json['email_address'];
    phone = json['phone'];
    restaurantLocation = json['restaurant_location'] != null
        ? new RestaurantLocation.fromJson(json['restaurant_location'])
        : null;
    logo = json['logo'];
    buildingAddress = json['building_address'];
    availableStatus = json['available_status'];
    campus =
        json['campus'] != null ? new Campus.fromJson(json['campus']) : null;
    id = json['id'];
    foodType = json['food_type'];
    rating = json['avg_rating'];
    preperationtime = json['preparation_time'];
    pricemin = json['price_min'];
    pricemax = json['price_max'];
    discount = json['discounted_percentage'];
    fssai = json['fssai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email_address'] = this.emailAddress;
    data['phone'] = this.phone;
    if (this.restaurantLocation != null) {
      data['restaurant_location'] = this.restaurantLocation.toJson();
    }
    data['logo'] = this.logo;
    data['building_address'] = this.buildingAddress;
    data['available_status'] = this.availableStatus;
    if (this.campus != null) {
      data['campus'] = this.campus.toJson();
    }
    data['id'] = this.id;
    data['food_type'] = this.foodType;
    data['price_max'] = this.pricemax;
    data['price_min'] = this.pricemin;
    data['preparation_time'] = this.preperationtime;
    data['avg_rating'] = this.rating;
    data['discounted_percentage'] = this.rating;
    data['fssai'] = this.fssai;
    return data;
  }
}

class RestaurantLocation {
  String long;
  String lat;

  RestaurantLocation({this.long, this.lat});

  RestaurantLocation.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long'] = this.long;
    data['lat'] = this.lat;
    return data;
  }
}

class Campus {
  int id;
  String name;
  String slug;
  int university;

  Campus({this.id, this.name, this.slug, this.university});

  Campus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    university = json['university'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['university'] = this.university;
    return data;
  }
}

class Single {
  int id;
  int restaurant;
  String name;
  String shortDescription;
  String image;
  String diet;
  List<Pricing> pricing;
  int totalQuantity;
  String type;
  String slug;
  String availStatus;
  String category;

  Single(
      {this.id,
      this.restaurant,
      this.name,
      this.shortDescription,
      this.image,
      this.diet,
      this.pricing,
      this.totalQuantity,
      this.type,
      this.slug,
      this.availStatus,
      this.category});

  Single.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'];
    name = json['name'];
    shortDescription = json['short_description'];
    image = json['image'];
    diet = json['diet'];
    if (json['pricing'] != null) {
      pricing = new List<Pricing>();
      json['pricing'].forEach((v) {
        pricing.add(new Pricing.fromJson(v));
      });
    }
    totalQuantity = json['total_quantity'];
    type = json['type'];
    slug = json['slug'];
    availStatus = json['avail_status'];
    category = json['food_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant'] = this.restaurant;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    data['diet'] = this.diet;
    if (this.pricing != null) {
      data['pricing'] = this.pricing.map((v) => v.toJson()).toList();
    }
    data['total_quantity'] = this.totalQuantity;
    data['type'] = this.type;
    data['slug'] = this.slug;
    data['avail_status'] = this.availStatus;
    data['food_category'] = this.category;
    return data;
  }
}

class Pricing {
  int id;
  String size;
  int totalQuantity;
  double price;

  Pricing({this.id, this.size, this.totalQuantity, this.price});

  Pricing.fromJson(dynamic json) {
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

// class Single {
//   int id;
//   String name;
//   String shortDescription;
//   String image;
//   double price;
//   int totalQuantity;
//   String type;
//   String slug;
//   String availStatus;
//   String size;
//   int restaurant;
//   String category;
//   String diet;
//   Single(
//       {this.id,
//       this.name,
//       this.shortDescription,
//       this.image,
//       this.price,
//       this.totalQuantity,
//       this.type,
//       this.slug,
//       this.availStatus,
//       this.size,
//       this.restaurant,
//       this.category,
//       this.diet});

//   Single.fromJson(Map<String, dynamic> json) {
//     diet = json['diet'];
//     id = json['id'];
//     name = json['name'];
//     shortDescription = json['short_description'];
//     image = json['image'];
//     price = json['price'];
//     totalQuantity = json['total_quantity'];
//     type = json['type'];
//     slug = json['slug'];
//     availStatus = json['avail_status'];
//     size = json['size'];
//     restaurant = json['restaurant'];
//     category = json['food_category'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['short_description'] = this.shortDescription;
//     data['image'] = this.image;
//     data['price'] = this.price;
//     data['total_quantity'] = this.totalQuantity;
//     data['type'] = this.type;
//     data['slug'] = this.slug;
//     data['avail_status'] = this.availStatus;
//     data['size'] = this.size;
//     data['restaurant'] = this.restaurant;
//     data['food_category'] = this.category;
//     data['diet'] = this.diet;
//     return data;
//   }
// }

class Set {
  int id;
  String name;
  String shortDescription;
  String image;
  double price;
  int totalQuantity;
  String type;
  String slug;
  String availStatus;
  String size;
  int restaurant;

  Set(
      {this.id,
      this.name,
      this.shortDescription,
      this.image,
      // this.price,
      this.totalQuantity,
      this.type,
      this.slug,
      this.availStatus,
      // this.size,
      this.restaurant});

  Set.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    image = json['image'];
    // price = json['price'];
    totalQuantity = json['total_quantity'];
    type = json['type'];
    slug = json['slug'];
    availStatus = json['avail_status'];
    // size = json['size'];
    restaurant = json['restaurant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    // data['price'] = this.price;
    data['total_quantity'] = this.totalQuantity;
    data['type'] = this.type;
    data['slug'] = this.slug;
    data['avail_status'] = this.availStatus;
    // data['size'] = this.size;
    data['restaurant'] = this.restaurant;
    return data;
  }
}

class Cart {
  int user;
  double total;
  List<Cartitems> cartitems;
  String tax;

  Cart({this.user, this.total, this.cartitems, this.tax});

  Cart.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    total = json['total'];
    if (json['cartitems'] != null) {
      cartitems = new List<Cartitems>();
      json['cartitems'].forEach((v) {
        cartitems.add(new Cartitems.fromJson(v));
      });
    }
    tax = json['tax'];
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
  Single fooditem;
  int count;
  int cart;

  Cartitems({this.id, this.fooditem, this.count, this.cart});

  Cartitems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fooditem =
        json['fooditem'] != null ? new Single.fromJson(json['fooditem']) : null;
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

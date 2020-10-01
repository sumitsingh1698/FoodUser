class RestaurantModel {
  String name;
  String emailAddress;
  String phone;
  RestaurantLocation restaurantLocation;
  String logo;
  String buildingAddress;
  String availableStatus;
  int id;
  String foodType;
  double rating;
  double pricemin;
  double pricemax;
  String preparationtime;
  String openingtime;
  String closingtime;
  bool isfavourite;
  double discount;

  RestaurantModel(
      {this.name,
      this.emailAddress,
      this.phone,
      this.restaurantLocation,
      this.logo,
      this.buildingAddress,
      this.availableStatus,
      this.id,
      this.foodType,
      this.rating,
      this.preparationtime,
      this.pricemax,
      this.pricemin,
      this.openingtime,
      this.closingtime,
      this.isfavourite,
      this.discount});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    discount = json['discounted_percentage'];
    name = json['name'];
    emailAddress = json['email_address'];
    phone = json['phone'];
    restaurantLocation = json['restaurant_location'] != null
        ? new RestaurantLocation.fromJson(json['restaurant_location'])
        : null;
    logo = json['logo'];
    buildingAddress = json['building_address'];
    availableStatus = json['available_status'];
    id = json['id'];
    foodType = json['food_type'];
    rating = json['avg_rating'];
    preparationtime = json['preparation_time'];
    pricemax = json['price_max'];
    pricemin = json['price_min'];
    openingtime = json['restaurant_opening_time'];
    closingtime = json['restaurant_closing_time'];
    isfavourite = json['is_favourite'];
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
    data['id'] = this.id;
    data['food_type'] = this.foodType;
    data['avg_rating'] = rating;
    data['preparation_time'] = preparationtime;
    data['price_min'] = this.pricemin;
    data['price_max'] = pricemax;
    data['restaurant_closing_time'] = this.closingtime;
    data['restaurant_opening_time'] = this.openingtime;
    data['is_favourite'] = isfavourite;
    data['discounted_percentage'] = this.discount;
    return data;
  }
}

class RestaurantLocation {
  String lat;
  String long;

  RestaurantLocation({this.lat, this.long});

  RestaurantLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}

class RestaurantModelFav {
  String name;
  String logo;
  String id;

  RestaurantModelFav({
    this.name,
    this.logo,
    this.id,
  });

  RestaurantModelFav.fromJson(Map<String, dynamic> json) {
    name = json['restaurant_name'];
    logo = json['restaurant_image'];
    id = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_name'] = this.name;
    data['restaurant_image'] = this.logo;
    data['restaurant_id'] = this.id;
    return data;
  }
}

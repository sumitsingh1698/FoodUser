class OfferModel {
  String id;
  int restaurant;
  String description;
  double mincartvalue;
  double maxdiscountvalue;
  bool ispercentage;
  double discount;
  String code;

  OfferModel(this.id, this.restaurant, this.description, this.mincartvalue,
      this.ispercentage, this.code);

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'] is int
        ? json['restaurant']
        : json['restaurant'] == null
            ? 0
            : double.parse(json['restaurant']).toInt();
    description = json['description'];
    mincartvalue = json['min_cart_value'];
    maxdiscountvalue = json['max_discount_amount'];
    discount = json['discount_percentage'];
    ispercentage = json['is_percentage'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant'] = this.restaurant;
    data['description'] = this.description;
    data['min_cart_value'] = this.mincartvalue;
    data['max_discount_amount'] = this.maxdiscountvalue;
    data['is_percentage'] = this.ispercentage;
    data['discount_percentage'] = this.discount;
    return data;
  }
}

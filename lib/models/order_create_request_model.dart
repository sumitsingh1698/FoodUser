class OrderRequestModel {
  int restaurant;
  double grandtotal;
  String address;
  double tax;
  String slot;
  List<IoId> ioId;
  String coupon;
  String instruction;
  String minCharge;
  String maxCharge;
  String minCart;
  OrderRequestModel(
      this.restaurant,
      this.grandtotal,
      this.address,
      this.tax,
      this.slot,
      this.ioId,
      this.coupon,
      this.instruction,
      this.maxCharge,
      this.minCart,
      this.minCharge);

  OrderRequestModel.fromJson(Map<String, dynamic> json) {
    coupon = json['coupon'];
    restaurant = json['restaurant'];
    grandtotal = json['grandtotal'];
    address = json['address'];
    tax = json['tax'];
    slot = json['slot'];
    if (json['io_id'] != null) {
      ioId = new List<IoId>();
      json['io_id'].forEach((v) {
        ioId.add(new IoId.fromJson(v));
      });
    }
    instruction = json['restaurant_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon'] = this.coupon;
    data['restaurant'] = this.restaurant;
    data['grandtotal'] = this.grandtotal;
    data['address'] = this.address;
    data['tax'] = this.tax;
    data['slot'] = this.slot;
    if (this.ioId != null) {
      data['io_id'] = this.ioId.map((v) => v.toJson()).toList();
    }
    data['restaurant_note'] = this.instruction;
    data['max_additional_charges'] = this.maxCharge;
    data['min_additional_charges'] = this.minCharge;
    data['min_cart'] = this.minCart;

    return data;
  }
}

class IoId {
  int fooditem;
  String itemName;
  double itemPrice;
  int count;

  IoId({this.fooditem, this.itemName, this.itemPrice, this.count});

  IoId.fromJson(Map<String, dynamic> json) {
    fooditem = json['fooditem'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fooditem'] = this.fooditem;
    data['item_name'] = this.itemName;
    data['item_price'] = this.itemPrice;
    data['count'] = this.count;
    return data;
  }
}

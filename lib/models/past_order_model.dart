class PastOrderModel {
  String orderNo;
  String slottime;
  String id;
  List<Orderitems> orderitems;
  double grandtotal;
  String status;
  String paymentMethod;
  double subtotal;
  String restaurantAddress;
  String restaurantImage;
  String restaurantName;
  int address;

  PastOrderModel(
      {this.orderNo,
      this.slottime,
      this.id,
      this.orderitems,
      this.grandtotal,
      this.status,
      this.paymentMethod,
      this.subtotal,
      this.restaurantAddress,
      this.restaurantImage,
      this.restaurantName,
      this.address});

  PastOrderModel.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    slottime = json['slottime'];
    id = json['id'];
    if (json['orderitems'] != null) {
      orderitems = new List<Orderitems>();
      json['orderitems'].forEach((v) {
        orderitems.add(new Orderitems.fromJson(v));
      });
    }
    grandtotal = json['grandtotal'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    restaurantAddress = json['restaurant_address'];
    restaurantImage = json['restaurant_image'];
    restaurantName = json['restaurant_name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['slottime'] = this.slottime;
    data['id'] = this.id;
    if (this.orderitems != null) {
      data['orderitems'] = this.orderitems.map((v) => v.toJson()).toList();
    }
    data['grandtotal'] = this.grandtotal;
    data['status'] = this.status;
    data['payment_method'] = this.paymentMethod;
    data['subtotal'] = this.subtotal;
    data['restaurant_address'] = this.restaurantAddress;
    data['restaurant_image'] = this.restaurantImage;
    data['restaurant_name'] = this.restaurantName;
    data['address'] = this.address;
    return data;
  }
}

class Orderitems {
  String itemName;
  double itemPrice;
  int count;
  String size;
  double itemtotal;

  Orderitems(
      {this.itemName, this.itemPrice, this.count, this.size, this.itemtotal});

  Orderitems.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    count = json['count'];
    size = json['size'];
    itemtotal = json['itemtotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['item_price'] = this.itemPrice;
    data['count'] = this.count;
    data['size'] = this.size;
    data['itemtotal'] = this.itemtotal;
    return data;
  }
}

class Rating {
  double rating;
  String order;
  String review;

  Rating({this.order, this.rating, this.review});

  Rating.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    rating = json['rating'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['rating'] = this.rating;
    data['review'] = this.review;
    return data;
  }
}

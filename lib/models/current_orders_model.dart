class CurrentOrderModel {
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
  Tracking tracking;
  int address;

  CurrentOrderModel(
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
      this.tracking,
      this.address});

  CurrentOrderModel.fromJson(Map<String, dynamic> json) {
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
    subtotal = double.parse(json['subtotal'].toString());
    restaurantAddress = json['restaurant_address'];
    restaurantImage = json['restaurant_image'];
    restaurantName = json['restaurant_name'];
    tracking = json['tracking'] != null
        ? new Tracking.fromJson(json['tracking'])
        : null;
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
    if (this.tracking != null) {
      data['tracking'] = this.tracking.toJson();
    }
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

class Tracking {
  String deliveryStaff;
  String orderId;
  bool status;

  Tracking({this.orderId, this.status});

  Tracking.fromJson(Map<String, dynamic> json) {
    deliveryStaff = json['delivery_staff'];
    orderId = json['order_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_staff'] = this.deliveryStaff;
    data['bucket_id'] = this.orderId;
    data['status'] = this.status;
    return data;
  }
}

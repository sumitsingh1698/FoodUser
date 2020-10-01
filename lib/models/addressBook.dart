class AddressBook {
  int id;
  String name;
  String address;
  String city;
  String pincode;
  String lat;
  String long;

  AddressBook(
      this.name, this.address, this.city, this.pincode, this.lat, this.long);

  AddressBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['address_name'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    lat = json['latitude'];
    long = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['lat'] = this.lat;
    data['lng'] = this.long;
    return data;
  }
}

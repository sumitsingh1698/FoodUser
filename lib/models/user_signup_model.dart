class UserSignupModel {
  String email;
  String name;
  String otp;
  String mobile;

  UserSignupModel(this.email, this.name, this.otp, this.mobile);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['otp'] = this.otp;
    data['mobile'] = this.mobile;
    return data;
  }
}

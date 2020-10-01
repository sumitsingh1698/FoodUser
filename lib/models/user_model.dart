import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/data/my_profile_data.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    getInitialData();
  }

  User user;
  bool loading = true;
  bool isGuest = false;

  Future<Null> getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      isGuest = true;
    } else {
      try {
        String token = prefs.getString('token');
        ProfileDataSource _profileData = new ProfileDataSource();
        var _response = await _profileData.getMyProfileData(token);
        if (_response[0]) user = _response[1];
      } on Exception catch (error) {
        print(error);
        return null;
      }
    }
    loading = false;
    notifyListeners();
  }

  User get getUser => user;

  void updateUser(User _user) async {
    loading = true;
    print(" update user ${_user.id} start : Loading " + loading.toString());
    notifyListeners();
    user.id = _user.id ?? 0;
    user.firstName = _user.firstName;
    user.lastName = _user.lastName;
    user.email = _user.email;
    user.phone = _user.phone;
    user.profilePic = _user.profilePic ?? userImageUrl;
    user.email = _user.email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {} on Exception catch (error) {
      print(error);
      return null;
    }
    loading = false;
    print(" update user end : Loading " + loading.toString());
    notifyListeners();
  }

  Future<List> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token;
    try {
      token = prefs.getString('token');
    } on Exception catch (error) {
      print(error);
      return null;
    }
    ProfileDataSource _profileData = new ProfileDataSource();
    var _response = await _profileData.getLogout(token);
    if (_response[0]) {
      user = null;
      prefs.setString('user_phone', '');
      prefs.setBool('loggedIn', false);
      return [true];
    } else
      return [false, _response[1]];
  }
}

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String profilePic;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.profilePic});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    profilePic = json['profile_pic'] ?? userImageUrl;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}

import 'dart:async';
import 'package:Belly/models/user_model.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/base_url.dart';

class ProfileDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final myProfileDataUrl = baseUrl + "myprofile/";
  static final changePasswordUrl = baseUrl + "changepassword/";
  static final checkDeliveryTrackingUrl = baseUrl + "checktracking/";
  static final logoutUrl = baseUrl + "logout/";

  Future<List> getMyProfileData(token) {
    // api to get current user's profile
    return _netUtil.getData(myProfileDataUrl, token).then((dynamic res) async {
      User response;
      if (res['results'].isNotEmpty) {
        response = User.fromJson(res['results'][0]);
      }

      if (response != null) {
        return [true, response];
      } else {
        return [false, "No data"];
      }
    });
  }

  Future<bool> changePassword(token, password, newPassword) {
    // pass the existing password and new password in the body
    Map<String, String> body = {
      'old_password': password,
      'new_password': newPassword
    };
    return _netUtil
        .putData(
      changePasswordUrl,
      body,
      token,
    )
        .then((dynamic res) async {
      return res['status'];
    });
  }

  Future<Map> checkDeliveryTracking(token, bucketId, orderId) {
    // corresponding bucket Id and order Id are passed as query parameters
    String url =
        checkDeliveryTrackingUrl + "?bucket_id=$bucketId&order_id=$orderId";
    return _netUtil.getData(url, token).then((dynamic res) async {
      print("checkDeliveryTracking $res");
      return res;
    });
  }

  Future<List> getLogout(token) {
    return _netUtil.getData(logoutUrl, token).then((dynamic res) async {
      if (res['status']) {
        return [true];
      } else {
        return [false, res['message']];
      }
    });
  }
}

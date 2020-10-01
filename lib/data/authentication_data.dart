import 'dart:async';
import 'package:Belly/constants/constants.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/utils/base_url.dart';

class AuthDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final verifyPhone = baseUrl + "verifyphone/";
  static final sendOtp = baseUrl + "sendotp/";
  static final sendSignUpOtp = baseUrl + "generateotp/";
  static final verifyOtp = baseUrl + "verifyotp/";
  static final signUpVerifyOtp = baseUrl + "signup_verifyotp/";
  static final loginAuthUrl = baseUrl + "userlogin/";
  static final resetPassUrl = baseUrl + "resetpassword/";
  static final sendFcmTokenUrl = baseUrl + "fcmuser/";

  Future<bool> signUpPhoneValidation(phone, countryDialCode) {
    String url = verifyPhone + "?phone=$phone";

    return _netUtil.signUpPhoneValidation(url).then((dynamic res) async {
      if (res['status']) {
        return false;
      } else {
        return true;
      }
    });
  }

  Future<bool> sendSignUpOtpCode(phone, _key) {
    Map<String, String> body = {
      'mobile': phone,
    };

    return _netUtil.sendOtp(sendSignUpOtp, body).then((dynamic res) async {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(res['existing_user']);
      if (res['status']) {
        if (res['existing_user']) {
          return true;
        } else {
          return false;
        }
      } else {
        Utils.showSnackBar(_key, 'Try Again;Communication Error');
      }
    });
  }

  Future<bool> sendOtpCode(phone) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
    };

    return _netUtil.sendOtp(sendOtp, body).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> verifyOtpCode(phone, otp) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
      'otp': otp
    };

    return _netUtil.sendOtp(verifyOtp, body).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<List> signUpOtpAuthentication(data) {
    return _netUtil
        .signUpOtpAuthentication(signUpVerifyOtp, data)
        .then((dynamic res) async {
      if (res['status']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setBool('loggedIn', true);
        prefs.setString('user_name', res['name']);
        prefs.setString('user_phone', res['phonenumber']);
        return [true];
      } else {
        return [false, res['message']];
      }
    });
  }

  Future<bool> loginOtpAuthentication(phone, password) {
    Map<String, String> body = {
      'mobile': phone,
      'otp': password,
    };
    return _netUtil
        .loginPasswordAuthentication(loginAuthUrl, body)
        .then((dynamic res) async {
      if (res['status']) {
        // status true means the user can be successfully signed in
        //the necessary user details are stored in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setBool('loggedIn', true);
        prefs.setString('user_name', res['name']);
        prefs.setString('user_phone', res['phonenumber']);
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> passwordResetPhoneValidation(phone, countryDialCode) {
    String url = verifyPhone + "?phone=$phone";

    return _netUtil.signUpPhoneValidation(url).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> resetPassword(phone, password) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
      'password': password,
    };
    return _netUtil
        .loginPasswordAuthentication(resetPassUrl, body) //not changed
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> sendFCMToken(token, fcmToken) {
    Map<String, String> body = {'fcm_token': fcmToken};
    return _netUtil
        .postFCMToken(sendFcmTokenUrl, token, body)
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }
}

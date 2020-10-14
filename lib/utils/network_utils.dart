import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  Future<dynamic> postFavorites(String url, token, data) async {
    Map _body = {'restaurant': data};
    Map<String, String> requestHeaders = {
      // 'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data postAddress");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> checkCoupon(String url, token, _body) async {
    Map<String, String> requestHeaders = {
      // 'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data postAddress");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> deleteFavorites(String url, token) async {
    Map<String, String> requestHeaders = {
      // 'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.delete(
      url,
      headers: requestHeaders,
    );
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data postAddress");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> deleteAddress(String url, token) async {
    Map<String, String> requestHeaders = {
      // 'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.delete(
      url,
      headers: requestHeaders,
    );
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data postAddress");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getOffers(String url, String token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final parsed = json.decode(response.body);
    print('offers offers parsed $parsed');
    return parsed;
  }

  Future<dynamic> getAddress(String url, String token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final parsed = json.decode(response.body);
    print('address parsed $parsed');
    return parsed;
  }

  Future<dynamic> postAddress(String url, token, data) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    log("response of postAddress ${response.body.toString()}");
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data postAddress");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> submitRating(String url, String token, data) async {
    var _body = json.encode(data);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    print(_body);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      print('faiiiiiiiiiiiiiiiiiiiiiiiiiiiillllllllllllllllllled');
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    print('ssssssssssssssssssssseeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaa');
    print(parsed);
    return parsed;
  }

  Future<dynamic> signUpPhoneValidation(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(response.body);
    return parsed;
  }

  Future<dynamic> sendOtp(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(response.body);
    return parsed;
  }

  Future<dynamic> signUpOtpAuthentication(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> loginPasswordAuthentication(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getCampuses(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getUniversities(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    print('resulltssssseebinssssss ${parsed}');
    return parsed;
  }

  Future<dynamic> getUserRestaurants(String url, token) async {
    var response;
    if (token != null) {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Authorization': "Token " + token
      };
      response = await http.get(
        url,
        headers: requestHeaders,
      );
      print("$response token not null");
    } else
      response = await http.get(url);
    final int statusCode = response.statusCode;
    print(response);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      print(response.body);
      throw new Exception("Error while fetching data");
    }
    final parsed = json.decode(utf8.decode(response.bodyBytes));
    log('parsed pardsed restDetails  $parsed ');
    return parsed;
  }

  Future<dynamic> getUserCounts(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postLoginRequest(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> signUpFormSubmission(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(response.body);
    return parsed;
  }

  Future<dynamic> getCartDetails(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      print(parsed);
      throw new Exception("Error while fetching dataaaaaaaaaaaaaaaaaaaa");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    print(parsed);
    return parsed;
  }

  Future<dynamic> addItemToCart(String url, String token, data) async {
    var _body = json.encode(data);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    print(_body);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      print('faiiiiiiiiiiiiiiiiiiiiiiiiiiiillllllllllllllllllled');
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    print('ssssssssssssssssssssseeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaa');
    print(parsed);
    return parsed;
  }

  Future<dynamic> clearCartItems(String url, String token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postFCMToken(String url, token, data) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> putData(String url, data, token) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.put(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getData(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }
}

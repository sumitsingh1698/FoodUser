import 'dart:async';
import 'dart:developer';
import 'package:Belly/models/cart_response_model.dart';
import 'package:Belly/models/cart_upload_request_model.dart';
import 'package:Belly/models/restaurant_detail_model.dart';
import 'package:Belly/models/restaurant_model.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/base_url.dart';

class RestaurantDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final restaurantList = baseUrl + "userhome/";
  static final restaurantGuestList = baseUrl + "publichome/";
  static final restaurantDetailUrl = baseUrl + "restaurant/";
  static final foodItemDetailUrl = baseUrl + "fooditem/";
  static final cartDetailUrl = baseUrl + "cartdetails/";
  static final cartCountUrl = baseUrl + "cartcount/";

  List<RestaurantModel> restaurants = [];

  Future<List<RestaurantModel>> getUserRestaurants(token, lat, long, category) {
    return _netUtil
        .getUserRestaurants(
            restaurantList + '?lat=$lat&long=$long&category=$category', token)
        .then((dynamic res) async {
      List<dynamic> temp = res['results'];
      print("data of res ${res['results'][1]}");
      print('${res['results'][0]} dddddddddddddddddddddddddddddddddd');
      restaurants = (temp).map((i) => RestaurantModel.fromJson(i)).toList();

      return restaurants;
    });
  }

  Future<List<RestaurantModel>> getUserRestaurantsForSearch(
      token, lat, long, search) {
    return _netUtil
        .getUserRestaurants(
            restaurantList + '?lat=$lat&long=$long&search=$search', token)
        .then((dynamic res) async {
      List<dynamic> temp = res['results'];
      restaurants = (temp).map((i) => RestaurantModel.fromJson(i)).toList();

      return restaurants;
    });
  }

  Future<List<RestaurantModel>> getGuestRestaurantsForSearch(
      lat, long, search) {
    return _netUtil
        .getCampuses(
            restaurantGuestList + "?lat=$lat&long=$long&search=$search")
        .then((dynamic res) async {
      List<dynamic> temp = res['results'];
      restaurants = (temp).map((i) => RestaurantModel.fromJson(i)).toList();

      return restaurants;
    });
  }

  Future<List<RestaurantModel>> getGuestRestaurants(lat, long, category) {
    return _netUtil
        .getCampuses(
            restaurantGuestList + "?lat=$lat&long=$long&category=$category")
        .then((dynamic res) async {
      List<dynamic> temp = res['results'];
      print(res);
      restaurants = (temp).map((i) => RestaurantModel.fromJson(i)).toList();
      return restaurants;
    });
  }

  Future<RestaurantDetailResponse> restaurantDetail(token, restaurantId) {
    String url = restaurantDetailUrl + "$restaurantId/";

    return _netUtil.getUserRestaurants(url, token).then((dynamic res) async {
      print(res['single']);
      log(res['single'].toString());
      RestaurantDetailResponse response =
          RestaurantDetailResponse.fromJson(res);

      return response;
    });
  }

  Future<ItemDetailResponse> foodItemDetail(token, itemId) {
    String url = foodItemDetailUrl + "$itemId/";
    print("print Idem id $itemId");
    return _netUtil.getUserRestaurants(url, token).then((dynamic res) async {
      log(res.toString());
      print('respons response of food item $res');
      ItemDetailResponse response = ItemDetailResponse.fromJson(res);
      return response;
    });
  }

  Future<Map> cartCounts(token) {
    return _netUtil
        .getUserCounts(cartCountUrl, token)
        .then((dynamic response) async {
      return response;
    });
  }

  Future<List> cartDetails(token) {
    return _netUtil
        .getCartDetails(cartDetailUrl, token)
        .then((dynamic res) async {
      print("Rwsults of Final before before Item ${res}");
      CartResponseModel response;
      if (res['results'].isNotEmpty) {
        print("Rwsults of Final Item ${res['results']}");
        log(res['results'].toString());
        response = CartResponseModel.fromJson(res['results'][0]);
      }
      if (response != null) {
        return [true, response];
      } else {
        return [false, "No cart"];
      }
    }).catchError((onError) {
      print("Error on fonal CArt $onError");
    });
  }
}

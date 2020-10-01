import 'package:Belly/models/food_item_model.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';

class AddToCartData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String addToCartUrl = baseUrl + "addtocart/";
  static final String clearCartUrl = baseUrl + "removecart/";
  List<Cartitems> foodItemList;

  Future<bool> addItemToCart(token, cartItemList) {
    return _netUtil
        .addItemToCart(addToCartUrl, token, cartItemList)
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> clearCart(token) {
    return _netUtil
        .clearCartItems(clearCartUrl, token)
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }
}

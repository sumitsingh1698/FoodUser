import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';

class OrderConfirmData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String addToCartUrl = baseUrl + "order/";

  // confirms an order after selecting the slot time
  Future orderConfirmation(token, finalOrder) {
    return _netUtil
        .addItemToCart(addToCartUrl, token, finalOrder)
        .then((dynamic res) async {
      return res;
    });
  }
}

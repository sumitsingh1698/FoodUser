import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';

class RazorPayPaymentData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String paymentUrl = baseUrl + "paynow/";

  //stripe generated token is sent to backend to initiate payment
  Future<Map> makeRazorPayment(token, orderId) {
    Map<String, String> body = {
      'id': orderId,
    };
    return _netUtil
        .addItemToCart(paymentUrl, token, body)
        .then((dynamic res) async {
      if (res['status']) {
        return res;
      } else {
        return res;
      }
    });
  }
}

import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';

class PaymentMethodData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String paymentUrl = baseUrl + "codpayment/";

  // api call to make the cod payment
  Future makeCOD(token, orderId) {
    Map<String, String> body = {
      'id': orderId,
    };
    return _netUtil
        .addItemToCart(paymentUrl, token, body)
        .then((dynamic res) async {
      print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
      print(res);
      return res;
    });
  }
}

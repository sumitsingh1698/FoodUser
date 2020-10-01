import 'dart:async';
import 'package:Belly/models/cart_response_model.dart';
import 'package:Belly/models/current_orders_model.dart' as order;
import 'package:Belly/models/past_order_model.dart';
import 'package:Belly/models/restaurant_detail_model.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/base_url.dart';

class OrderHistoryDataSource {
  /// these two api's are fetched with pagination
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final pastOrdersUrl = baseUrl + "orderhistory/";
  static final currentOrdersUrl = baseUrl + "ordering/";

  List<order.CurrentOrderModel> currentOrders = [];

  // returns previous orders
  Future<List<PastOrderModel>> getPastOrders(token, _page) async {
    List<PastOrderModel> orders = [];
    final res = await _netUtil.getUserRestaurants(
        pastOrdersUrl + "?page=$_page", token);
    print('ressssssssresresresres');
    // print(res);
    List<dynamic> temp = res['results'];
    print(temp);
    temp.forEach((i) => orders.add(PastOrderModel.fromJson(i)));
    // print('current order of hhhhhhhhhhhhhhiiiiiiiiiiisssssssssssstttttory');
    // print(orders);
    // print(orders);
    return orders;
  }

  // returns current orders
  Future<List<order.CurrentOrderModel>> getCurrentOrders(token, _page) async {
    final res = await _netUtil.getUserRestaurants(
        currentOrdersUrl + "?page=$_page", token);

    List<dynamic> temp = res['results'];
    currentOrders =
        temp.map((i) => order.CurrentOrderModel.fromJson(i)).toList();

    print(currentOrders.map((element) => element.orderNo));
    return currentOrders;
  }
}

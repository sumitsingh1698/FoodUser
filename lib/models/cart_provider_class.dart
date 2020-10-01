import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/data/restaurant_data.dart';

class CartModel extends ChangeNotifier {
  CartModel() {
    getSharedPrefs();
  }

  /// Internal, private state of the cart.
  int itemCount;
  double price;
  bool isGuest = false;

  /// function that should be called to initialize the cart
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      isGuest = true;
      itemCount = 0;
      price = 0;
      notifyListeners();
    } else {
      try {
        String token = prefs.getString('token');
        getCurrentCartData(token);
      } on Exception catch (error) {
        print(error);
        return null;
      }
    }
  }

  /// to get the online cart data to the local cart provider
  void getCurrentCartData(token) async {
    RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
    var countData = await _restaurantDataSource.cartCounts(token);
    if (countData['count'] > 0) {
      itemCount = countData['results'][0]['cartitems'];
      price = countData['results'][0]['total'];
    } else {
      itemCount = 0;
      price = 0;
    }
    notifyListeners();
  }

  /// An unmodifiable view of the items in the cart.
  int get getItemCount => itemCount;

  /// The current total price of all items (assuming all items cost $42).
  double get totalPrice => price;

  /// Update total item count in cart.
  void updateCount(int c) {
    itemCount = c;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Update total price in cart.
  void updatePrice(double p) {
    price = p;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/add_to_cart.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/ui/screens/home_screen.dart';

class OrderCreationSuccessPage extends StatefulWidget {
  @override
  _OrderCreationSuccessPage createState() => _OrderCreationSuccessPage();
}

class _OrderCreationSuccessPage extends State<OrderCreationSuccessPage> {
  bool _loader = false;
  AddToCartData cartData = new AddToCartData();
  String token;
  CartModel _cartProvider;

  @override
  initState() {
    super.initState();
    getSharedPrefs();
    new Timer(const Duration(seconds: 3), onClose);
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      token = prefs.getString('token');
      clearCart();
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  clearCart() async {
    bool updatedCartFlag = await cartData.clearCart(token);
    if (updatedCartFlag) {
      setState(() {
        _cartProvider.updatePrice(0.0);
        _cartProvider.updateCount(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartModel>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: new Scaffold(
        backgroundColor: blackColor,
        resizeToAvoidBottomPadding: false,
        body: (_loader)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(greenBellyColor),
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      orderCompleted,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'NotoSansJP-Bold',
                        color: whiteColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      pleaseOrderWillcome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'NotoSansJP-Bold',
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void onClose() {
    // Navigator.of(context).pushReplacement(new PageRouteBuilder(
    //   maintainState: true,
    //   opaque: true,
    //   pageBuilder: (context, _, __) => new HomeScreen(),
    // ));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => new HomeScreen(),
        ),
        (route) => false);
  }
}

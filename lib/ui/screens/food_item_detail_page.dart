import 'package:Belly/ui/screens/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Belly/data/add_to_cart.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/models/cart_response_model.dart';
import 'package:Belly/models/cart_upload_request_model.dart';
import 'package:Belly/models/food_item_model.dart' as cartModel;
import 'package:Belly/ui/screens/cartui.dart';
import 'package:Belly/models/cart_response_model.dart' as cartResponse;
import 'dart:async';

class FoodItemDetailPage extends StatefulWidget {
  final itemId;

  FoodItemDetailPage(this.itemId);

  @override
  _FoodItemDetailPageState createState() => _FoodItemDetailPageState();
}

class _FoodItemDetailPageState extends State<FoodItemDetailPage> {
  bool isLoading = true;
  bool _countLoader = false;
  double totalPrice = 0.0;
  List<cartModel.Cartitems> finalItems = [];
  final List<cartResponse.Cartitems> cartItems = [];
  bool _isButtonEnabled = false;
  String token;
  RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
  ItemDetailResponse data;
  List cartDataResponse;
  CartResponseModel cartDataRes;
  cartModel.Cartitems currentItem;
  AddToCartData cartData = new AddToCartData();
  SharedPreferences prefs;
  bool updatedCartFlag = true;
  CartModel _cartProvider;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      isGuest = true;
    } else {
      token = prefs.getString('token');
      getCurrentCartData();
    }
    getData();
  }

  void getData() async {
    data = await _restaurantDataSource.foodItemDetail(token, widget.itemId);

    setState(() {
      if (data.cartitem.length != 0) {
        currentItem = new cartModel.Cartitems(
            fooditem: data.cartitem[0].fooditem.id,
            count: data.cartitem[0].count,
            price: data.cartitem[0].fooditem.price,
            restuarantId: data.cartitem[0].fooditem.restaurant);
      } else {
        currentItem = new cartModel.Cartitems(
            fooditem: data.fooditem[0].id,
            count: 0,
            price: data.fooditem[0].price,
            restuarantId: data.fooditem[0].restaurant);
      }

      isLoading = false;
      _countLoader = false;
    });
  }

  void getCurrentCartData() async {
    try {
      cartDataResponse = await _restaurantDataSource.cartDetails(token);
      if (cartDataResponse[0] == true) cartDataRes = cartDataResponse[1];
      saveLocalCart();

      calculateTotalPrice();
    } on Exception catch (error) {
      print(error);
      return null;
    }
    getData();
  }

  void saveLocalCart() {
    try {
      if (cartDataRes != null && cartDataRes.cartitems.length != 0) {
        for (int i = 0; i < cartDataRes.cartitems.length; i++) {
          cartItems.add(cartDataRes.cartitems[i]);
          if (cartDataRes.cartitems[i].fooditem != null)
            finalItems.add(new cartModel.Cartitems(
                fooditem: cartDataRes.cartitems[i].fooditem.id,
                count: cartDataRes.cartitems[i].count,
                price: cartDataRes.cartitems[i].fooditem.price,
                restuarantId: cartDataRes.cartitems[i].fooditem.restaurant.id));
        }
      }
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  calculateTotalPrice() {
    totalPrice = 0;
    setState(() {
      for (var i = 0; i < finalItems.length; i++) {
        totalPrice += finalItems[i].count * finalItems[i].price;
      }
      if (totalPrice != 0)
        _isButtonEnabled = true;
      else
        _isButtonEnabled = false;
    });
    _cartProvider.updatePrice(totalPrice);
  }

  addDataToCartServer(finalMap) async {
    setState(() {
      _countLoader = true;
    });

    updatedCartFlag = await cartData.addItemToCart(token, finalMap);
    if (updatedCartFlag) {
      setState(() {
        _countLoader = false;
      });
    }
  }

  clearCart() async {
    setState(() {
      _countLoader = true;
    });

    updatedCartFlag = await cartData.clearCart(token);
    if (updatedCartFlag) {
      setState(() {
        finalItems.clear();
        _cartProvider.updatePrice(0.0);
        _cartProvider.updateCount(0);
        getCurrentCartData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : Container(
              color: Colors.black,
              child: SafeArea(
                child: Container(
                  color: whiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                          color: cloudsColor,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          child: CachedNetworkImage(
                            imageUrl: data.fooditem[0].image,
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        _buildAppBar(context),
                      ]),
                      SizedBox(
                        height: 24,
                      ),
                      _buildItemName(),
                      SizedBox(
                        height: 12,
                      ),
                      _buildItemDescription(),
                      Spacer(),
                      addRemoveItemUi(context),
                      SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () {
                          clearCart();
                        },
                        child: Center(
                            child: Text(
                          removeFromCart,
                          style: TextStyle(
                              fontSize: 16,
                              color: redColor,
                              fontFamily: "NotoSansJP"),
                        )),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: addtoCartButtonUi(context),
    );
  }

  Widget addRemoveItemUi(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        currentItem.count != 0
            ? IconButton(
                icon: new Icon(
                  Icons.remove_circle_outline,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    currentItem.count--;
                  });
                  _addToCart(context, currentItem.fooditem, currentItem.count,
                      currentItem.price, currentItem.restuarantId);
                },
              )
            : IconButton(
                icon: new Icon(
                  Icons.remove_circle_outline,
                  size: 40,
                  color: disabledGrey,
                ),
              ),
        SizedBox(
          width: 24,
        ),
        Container(
          width: 30,
          child: Center(
            child: _countLoader
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(greenBellyColor),
                      strokeWidth: 3.0,
                    ),
                  )
                : Text(currentItem.count.toString(),
                    style: CustomFontStyle.regularBoldTextStyle(blackColor)),
          ),
        ),
        SizedBox(
          width: 24,
        ),
        IconButton(
          icon: new Icon(
            Icons.add_circle_outline,
            size: 40,
          ),
          onPressed: () {
            if (isGuest)
              loginToContinue(context);
            else {
              setState(() {
                currentItem.count++;
              });
              _addToCart(context, currentItem.fooditem, currentItem.count,
                  currentItem.price, currentItem.restuarantId);
            }
          },
        ),
      ],
    );
  }

  loginToContinue(BuildContext context) async {
    Widget optionYes = CupertinoDialogAction(
      child: Text(
        yes,
        style: CustomFontStyle.bottomButtonTextStyle(blueColor),
      ),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget optionNo = CupertinoDialogAction(
      child: Text(
        no,
        style: CustomFontStyle.bottomButtonTextStyle(blueColor),
      ),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    bool proceedLogin = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data:
                Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: CupertinoAlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(wouldYouLikeToLogin,
                    style: CustomFontStyle.regularBoldTextStyle(blackColor)),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(loginContinueToCart,
                    style: CustomFontStyle.smallTextStyle(blackColor)),
              ),
              actions: <Widget>[
                optionYes,
                optionNo,
              ],
            ));
      },
    );

    if (proceedLogin) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isGuest", false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomePage()),
          (Route<dynamic> route) => false);
    } else {
      return;
    }
  }

  _addToCart(BuildContext context, int id, int _count, double _price,
      int _restaurantId) async {
    Widget optionYes = CupertinoDialogAction(
      child: Text(
        yes,
        style: CustomFontStyle.mediumTextStyle(blueColor),
      ),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget optionNo = CupertinoDialogAction(
      child: Text(
        no,
        style: CustomFontStyle.mediumTextStyle(blueColor),
      ),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    if (finalItems.length == 0) {
      finalItems.add(new cartModel.Cartitems(
          fooditem: id,
          count: _count,
          price: _price,
          restuarantId: _restaurantId));
      setState(() {
        calculateTotalPrice();
      });
    } else {
      if (finalItems[0].restuarantId != _restaurantId) {
        bool shouldUpdate = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Theme(
                data: Theme.of(context)
                    .copyWith(dialogBackgroundColor: Colors.white),
                child: CupertinoAlertDialog(
                  title: Text(
                    doYouWantToClearCart,
                    style: CustomFontStyle.bottomButtonTextStyle(blackColor),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(itemsFromOtherRestaurantInCart,
                        style: CustomFontStyle.smallTextStyle(blackColor)),
                  ),
                  actions: <Widget>[
                    optionYes,
                    optionNo,
                  ],
                ));
          },
        );

        if (shouldUpdate)
          finalItems.clear();
        else {
          setState(() {
            currentItem.count = 0;
          });

          return;
        }
      }
      bool itemExist = false;
      for (var i = 0; i < finalItems.length; i++) {
        if (finalItems[i].fooditem == id) {
          itemExist = true;
          if (_count != 0)
            finalItems[i].count = _count;
          else
            finalItems.removeAt(i);
        }
      }
      if (!itemExist)
        finalItems.add(new cartModel.Cartitems(
            fooditem: id,
            count: _count,
            price: _price,
            restuarantId: _restaurantId));
      setState(() {
        calculateTotalPrice();
      });
    }
    final cartModel.CartUploadModel finalCart = new cartModel.CartUploadModel(
      cartitems: finalItems,
      total: totalPrice,
    );
    Map<String, dynamic> cartRequest = finalCart.toJson();
    addDataToCartServer(cartRequest);
    _cartProvider.updateCount(finalItems.length);
    _cartProvider.updatePrice(totalPrice);
    if (totalPrice != 0) {
      setState(() {
        _isButtonEnabled = true;
      });
    }
  }

  Widget addtoCartButtonUi(context) {
    return Consumer<CartModel>(
        builder: (context, cartRepo, child) => Padding(
              padding: const EdgeInsets.only(bottom: 24.0, left: 24, right: 24),
              child: Container(
                height: 50,
                width: 327,
                child: RaisedButton(
                  onPressed: () {
                    if (_isButtonEnabled) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartDetailPage()),
                      );
                    }
                  },
                  color: blackColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Stack(children: [
                          Center(
                            child: Text(
                              viewCart,
                              style:
                                  CustomFontStyle.RegularTextStyle(whiteColor),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: !isLoading &&
                                      cartRepo.totalPrice != 0 &&
                                      cartRepo.totalPrice != null
                                  ? Text(
                                      "₹ " + cartRepo.totalPrice.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "NotoSansJP"),
                                    )
                                  : Container(),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget _buildAppBar(context) {
    return Positioned(
      top: appbarMargin,
      left: 18.0,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        data.fooditem[0].name,
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontFamily: "NotoSansJP"),
      ),
    );
  }

  Widget _buildItemDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        data.fooditem[0].shortDescription,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

import 'package:Belly/ui/screens/cartRestaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/data/add_to_cart.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/models/cart_response_model.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/models/food_item_model.dart' as cartModel;
import 'restaurant_detail_page.dart';
import 'order_confirmation_page.dart';

class CartDetailPage extends StatefulWidget {
  final bool back;
  CartDetailPage({
    this.back = true,
  });
  @override
  _CartDetailPageState createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  List<String> slots;
  bool _isLoading = true;
  String token;
  CartResponseModel cartDataRes;
  List cartDataResponse;
  List<cartModel.Cartitems> finalItems = [];
  RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
  double priceIncludingTax = 0;
  AddToCartData cartData = new AddToCartData();
  bool updatedCartFlag = false;
  bool _countLoader = false;
  double totalPrice = 0.0;
  CartModel _cartProvider;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      setState(() {
        isGuest = true;
      });
    } else {
      try {
        token = prefs.getString('token');
        print('toooooooooken');
        print(token);
        await getCurrentCartData();
      } on Exception catch (error) {
        print(error);
        return null;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future getCurrentCartData() async {
    try {
      print('toooooooooken');
      print(token);
      cartDataResponse = await _restaurantDataSource.cartDetails(token);
      if (cartDataResponse[0]) {
        cartDataRes = cartDataResponse[1];
        finalItems.clear();
        if (cartDataRes.cartitems.length != 0) {
          for (int i = 0; i < cartDataRes.cartitems.length; i++) {
            if (cartDataRes.cartitems[i].fooditem != null)
              finalItems.add(new cartModel.Cartitems(
                  fooditem: cartDataRes.cartitems[i].fooditem.id,
                  count: cartDataRes.cartitems[i].count,
                  price: cartDataRes.cartitems[i].fooditem.pricing
                      .firstWhere((element) =>
                          element.id == cartDataRes.cartitems[i].pricingId)
                      .price,
                  pricing: cartDataRes.cartitems[i].fooditem.pricing[0].id,
                  restuarantId:
                      cartDataRes.cartitems[i].fooditem.restaurant.id));
          }
          priceIncludingTax = (cartDataRes.total +
              (cartDataRes.total * (double.parse(cartDataRes.tax) / 100)));
        }
      } else
        _cartProvider.itemCount = 0;

      // print(finalItems[0]);
      // print('ssssssssssssssssssssuuuuuuuuuuccccccceeeeeeessssssss');
      setState(() {
        _isLoading = false;
      });
    } on Exception catch (error) {
      print('fffffffffffffiinnnnnnnnngetcurrentcartData');
      print(error.toString());
      return null;
    }
  }

  calculateTotalPrice() {
    priceIncludingTax = 0;
    setState(() {
      for (var i = 0; i < finalItems.length; i++) {
        priceIncludingTax += finalItems[i].count * finalItems[i].price;
      }
    });
  }

  addDataToCartServer(finalMap, lastOne) async {
    setState(() {
      _countLoader = true;
    });

    updatedCartFlag = await cartData.addItemToCart(token, finalMap);
    if (lastOne && updatedCartFlag) {
      getCurrentCartData();
    }
    setState(() {
      _countLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartModel>(context, listen: true);
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: CustomCloseAppBar(
          title: cart,
          back: widget.back ? true : false,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(greenBellyColor),
                ),
              )
            : isGuest
                ? Center(
                    child: Text(
                    youAreNotLoggedIn,
                    style: CustomFontStyle.regularBoldTextStyle(blackColor),
                  ))
                : cartDataRes.cartitems.length != 0
                    ? CartRestauranPage(
                        cartDataRes.cartitems[0].fooditem.restaurant.id)
                    : Center(
                        child: Text('No Items In your Cart'),
                      )
        //         Stack(
        //             children: <Widget>[
        //               _cartProvider.itemCount == 0
        //                   ? Center(
        //                       child: Text(
        //                       noItemsInCart,
        //                       style: CustomFontStyle.regularBoldTextStyle(
        //                           blackColor),
        //                     ))
        //                   : _buildDetailsUi(context),
        //             ],
        //           ),
        // bottomNavigationBar:
        //     _cartProvider.itemCount != 0 && _cartProvider.itemCount != null
        //         ? _buildBottomButton(context, _cartProvider.totalPrice.toString())
        //         : null,
        );
  }

  Widget _buildBottomButton(context, String _totalPrice) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderConfirmationPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: blackColor,
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Stack(children: [
                      Center(
                        child: Text(
                          proceedToOrder,
                          style: CustomFontStyle.RegularTextStyle(whiteColor),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: _countLoader
                                ? CupertinoActivityIndicator()
                                : Text(
                                    "₹ " + _totalPrice != null
                                        ? _totalPrice
                                        : 0,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "NotoSansJP"),
                                  )),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildDetailsUi(context) {
    return ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _cartProvider.itemCount == null ||
                          _cartProvider.itemCount == 0
                      ? Container()
                      : Text(
                          cartDataRes.cartitems[0].fooditem.restaurant.name,
                          style:
                              CustomFontStyle.regularBoldTextStyle(blackColor),
                        ),
                ),
                color: cloudsColor,
                width: double.infinity,
              ),
              _cartProvider.itemCount == 0
                  ? Container()
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount:
                              finalItems.length == null ? 0 : finalItems.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    cartDataRes.cartitems[index]
                                                        .fooditem.name,
                                                    style: CustomFontStyle
                                                        .regularBoldTextStyle(
                                                            blackColor),
                                                  ),
                                                  Text(
                                                    cartDataRes.cartitems[index]
                                                        .fooditem.pricing
                                                        .firstWhere((element) =>
                                                            element.id ==
                                                            cartDataRes
                                                                .cartitems[
                                                                    index]
                                                                .pricingId)
                                                        .size,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomFontStyle
                                                        .RegularTextStyle(
                                                            grey1Color),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "₹ " +
                                                    cartDataRes.cartitems[index]
                                                        .fooditem.pricing
                                                        .firstWhere((element) =>
                                                            element.id ==
                                                            cartDataRes
                                                                .cartitems[
                                                                    index]
                                                                .pricingId)
                                                        .price
                                                        .toString(),
                                                style: CustomFontStyle
                                                    .regularFormTextStyle(
                                                        blackColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 130,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: new Border.all(
                                                    color: disabledGrey,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    cartDataRes.cartitems[index]
                                                                .count !=
                                                            0
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              setState(() {
                                                                cartDataRes
                                                                    .cartitems[
                                                                        index]
                                                                    .count--;
                                                              });
                                                              await _addToCart(
                                                                  context,
                                                                  cartDataRes
                                                                      .cartitems[
                                                                          index]
                                                                      .fooditem
                                                                      .id,
                                                                  cartDataRes
                                                                      .cartitems[
                                                                          index]
                                                                      .count,
                                                                  cartDataRes
                                                                      .cartitems[
                                                                          index]
                                                                      .fooditem
                                                                      .pricing
                                                                      .firstWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          cartDataRes
                                                                              .cartitems[
                                                                                  index]
                                                                              .pricingId)
                                                                      .price,
                                                                  cartDataRes
                                                                      .cartitems[
                                                                          index]
                                                                      .fooditem
                                                                      .restaurant
                                                                      .id);
                                                            },
                                                            child: Icon(
                                                              Icons.remove,
                                                              color: orange,
                                                            ))
                                                        : Icon(
                                                            Icons.remove,
                                                            color: greyColor,
                                                          ),
                                                    Container(
                                                      color: orange,
                                                      height: 135,
                                                      width: 40,
                                                      child: Center(
                                                        child: Text(
                                                          cartDataRes
                                                              .cartitems[index]
                                                              .count
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  blackColor),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            cartDataRes
                                                                .cartitems[
                                                                    index]
                                                                .count++;
                                                          });
                                                          await _addToCart(
                                                              context,
                                                              cartDataRes
                                                                  .cartitems[
                                                                      index]
                                                                  .fooditem
                                                                  .id,
                                                              cartDataRes
                                                                  .cartitems[
                                                                      index]
                                                                  .count,
                                                              cartDataRes
                                                                  .cartitems[
                                                                      index]
                                                                  .fooditem
                                                                  .pricing
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      cartDataRes
                                                                          .cartitems[
                                                                              index]
                                                                          .pricingId)
                                                                  .price,
                                                              cartDataRes
                                                                  .cartitems[
                                                                      index]
                                                                  .fooditem
                                                                  .restaurant
                                                                  .id);
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color: orange,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: CachedNetworkImage(
                                                  imageUrl: cartDataRes
                                                      .cartitems[index]
                                                      .fooditem
                                                      .image,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            InkWell(
                                              child: Text(
                                                delete,
                                                style: CustomFontStyle
                                                    .regularFormTextStyle(
                                                        greenColor),
                                              ),
                                              onTap: () async {
                                                await _addToCart(
                                                    context,
                                                    cartDataRes.cartitems[index]
                                                        .fooditem.id,
                                                    0,
                                                    cartDataRes.cartitems[index]
                                                        .fooditem.pricing
                                                        .firstWhere((element) =>
                                                            element.id ==
                                                            cartDataRes
                                                                .cartitems[
                                                                    index]
                                                                .pricingId)
                                                        .price,
                                                    cartDataRes
                                                        .cartitems[index]
                                                        .fooditem
                                                        .restaurant
                                                        .id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: cloudsColor,
                                    height: 1,
                                  ),
                                ],
                              ))),
              _cartProvider.itemCount == 0
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantDetailPage(
                                        cartDataRes.cartitems[0].fooditem
                                            .restaurant.id,
                                      )),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 12.0, bottom: 16.0, top: 8.0),
                            child: Text(
                              addProducts,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                letterSpacing: 1.0,
                                fontFamily: 'NotoSansJP',
                                color: disabledGrey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ]);
  }

  _addToCart(BuildContext context, int id, int _count, double _price,
      int _restaurantId) async {
    bool lastOne = false;
    if (finalItems.length == 0) {
      finalItems.add(new cartModel.Cartitems(
          fooditem: id,
          count: _count,
          price: _price,
          restuarantId: _restaurantId));

      calculateTotalPrice();
    } else {
      if (finalItems[0].restuarantId != _restaurantId) {
        finalItems.clear();
      }
      bool itemExist = false;
      for (var i = 0; i < finalItems.length; i++) {
        if (finalItems[i].fooditem == id) {
          itemExist = true;
          if (_count != 0)
            finalItems[i].count = _count;
          else {
            lastOne = true;
            finalItems.removeAt(i);
          }
        }
      }
      if (!itemExist)
        finalItems.add(new cartModel.Cartitems(
            fooditem: id,
            count: _count,
            price: _price,
            restuarantId: _restaurantId));

      calculateTotalPrice();
    }
    await _addFinalToCart(lastOne);
  }

  _addFinalToCart(bool _lastone) async {
    final cartModel.CartUploadModel finalCart = new cartModel.CartUploadModel(
      cartitems: finalItems,
      total: priceIncludingTax,
    );
    Map<String, dynamic> cartRequest = finalCart.toJson();
    addDataToCartServer(cartRequest, _lastone);
    _cartProvider.updateCount(finalItems.length);
    _cartProvider.updatePrice(priceIncludingTax);
  }
}

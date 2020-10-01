import 'package:Belly/constants/String.dart';
import 'package:Belly/data/add_to_cart.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/models/cart_response_model.dart';
import 'package:Belly/models/cart_upload_request_model.dart';
import 'package:Belly/ui/screens/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Belly/models/food_item_model.dart' as cartModel;
import 'package:Belly/models/cart_response_model.dart' as cartResponse;

class MenuCell extends StatefulWidget {
  final item;
  final i;
  final Function(String) selectedAdd;
  final String slug;
  MenuCell(this.item, this.i, this.slug, this.selectedAdd);
  @override
  _MenuCellState createState() => _MenuCellState();
}

class _MenuCellState extends State<MenuCell> {
  String selectedAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => FoodItemDetailPage(widget.item.slug)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 90,
                    child: CachedNetworkImage(
                      imageUrl: widget.item.image,
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        child: Text(
                          widget.item.name,
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontFamily: 'NotoSansJP',
                            color: blackBellyColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          // CustomFontStyle.regularBoldTextStyle(blackColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          widget.item.shortDescription,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: CustomFontStyle.RegularTextStyle(grey1Color),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              "₹ " + widget.item.price.toString(),
                              style: CustomFontStyle.regularFormTextStyle(
                                  blackColor),
                            ),
                          ),
                          widget.slug == widget.item.slug
                              ? AddRemoveCart(widget.item.id)
                              : GestureDetector(
                                  onTap: () {
                                    widget.selectedAdd(widget.item.slug);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.12),
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      color: cloudsColor,
                                      child: Center(
                                        child: Text(
                                          'Add +',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  )),
                        ],
                      ),
                    ],
                  ),
                ]),
            SizedBox(
              height: 5,
            ),
            Container(
              color: cloudsColor,
              height: 1,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
  }
}

// class MenuCell extends StatelessWidget {
//   var item;
//   final i;

//   MenuCell(this.item, this.i);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 26.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           InkWell(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => FoodItemDetailPage(item.slug)),
//             ),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 80,
//                     width: 80,
//                     child: CachedNetworkImage(
//                       imageUrl: item.image,
//                       errorWidget: (context, url, error) =>
//                           new Icon(Icons.error),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         width: 200,
//                         child: Text(
//                           item.name,
//                           style:
//                               CustomFontStyle.regularBoldTextStyle(blackColor),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: 200,
//                         child: Text(
//                           item.shortDescription,
//                           maxLines: 1,
//                           softWrap: false,
//                           overflow: TextOverflow.ellipsis,
//                           style: CustomFontStyle.RegularTextStyle(grey1Color),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.35,
//                             child: Text(
//                               "₹ " + item.price.toString(),
//                               style: CustomFontStyle.regularFormTextStyle(
//                                   blackColor),
//                             ),
//                           ),
//                           AddRemoveCart(item.slug),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ]),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Container(
//             color: cloudsColor,
//             height: 1,
//           ),
//           SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     ));
//   }
// }

class AddRemoveCart extends StatefulWidget {
  final itemId;

  AddRemoveCart(this.itemId);

  @override
  _AddRemoveCartState createState() => _AddRemoveCartState();
}

class _AddRemoveCartState extends State<AddRemoveCart> {
  bool isLoading = true;
  bool _countLoader = false;
  double totalPrice = 0.0;
  List<cartModel.Cartitems> finalItems = [];
  final List<cartResponse.Cartitems> cartItems = [];
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
    print('onnonononoonoonoonon');
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool("loggedIn").toString();
    if (loggedIn == 'null' || loggedIn == 'false') {
      isGuest = true;
    } else {
      token = prefs.getString('token');
      await getCurrentCartData();
    }
    // getData();
  }

  void getData() async {
    data = await _restaurantDataSource.foodItemDetail(token, widget.itemId);
    print('pppppllllllsssssssssssssssssgsgukggvkgvjyv');
    print('id of food item is');
    print(widget.itemId);
    int id = widget.itemId;
    // print('foood itme price is ${data.cartitem[0].fooditem.price}');
    setState(() {
      if (data.cartitem.length != 0) {
        currentItem = new cartModel.Cartitems(
            fooditem: id,
            count: data.cartitem[0].count,
            price: data.cartitem[0].fooditem.price,
            restuarantId: data.cartitem[0].fooditem.restaurant);
      } else {
        currentItem = new cartModel.Cartitems(
            fooditem: id,
            count: 1,
            price: data.fooditem[0].price,
            restuarantId: data.fooditem[0].restaurant);
        _addToCart(context, currentItem.fooditem, currentItem.count,
            currentItem.price, currentItem.restuarantId);
      }
      _countLoader = false;
      isLoading = false;
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
      finalItems.forEach((element) {
        print('rrrrrrrrrrrrr');
        print(element.restuarantId);
      });
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
    return (isLoading)
        ? Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
            child: Container(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            ),
          )
        : addRemoveItemUi(context);
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
                  size: 20,
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
                  size: 20,
                  color: disabledGrey,
                ),
              ),
        Container(
          width: 10,
          child: Center(
            child: _countLoader
                ? SizedBox(
                    height: 18,
                    width: 10,
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
        IconButton(
          icon: new Icon(
            Icons.add_circle_outline,
            size: 20,
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
    // if (totalPrice != 0) {
    //   // setState(() {
    //   //   _isButtonEnabled = true;
    //   // });
    // }
  }
}

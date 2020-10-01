import 'package:Belly/models/cart_provider_class.dart';
import 'package:Belly/models/offerModel.dart';
import 'package:Belly/presentation/custom_icons_icons.dart';
import 'package:Belly/ui/screens/OfferSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/data/order_confirm_data.dart';
import 'package:Belly/data/restaurant_data.dart';
import 'package:Belly/models/cart_response_model.dart';
import 'package:Belly/models/order_create_request_model.dart';
import 'package:Belly/ui/screens/payment_page.dart';
import 'package:Belly/ui/widgets/close_custom_app_bar.dart';
import 'package:Belly/utils/show_snackbar.dart';

class OrderConfirmationPage extends StatefulWidget {
  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  bool _isLoading = true;
  String token;
  CartResponseModel cartDataRes;
  List cartDataResponse;
  final List<IoId> purchasedItems = [];
  RestaurantDataSource _restaurantDataSource = new RestaurantDataSource();
  OrderConfirmData _orderDataSource = new OrderConfirmData();
  var _orderConfirmationRes;
  double priceIncludingTax = 0;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  TextEditingController instructionController = new TextEditingController();
  double deduction = 0;
  OfferModel coupon;
  int addressId;
  double discountRes;
  double additional;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    addressId = prefs.getInt('addressId');
    try {
      token = prefs.getString('token');
      getCurrentCartData();
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  void getCurrentCartData() async {
    try {
      cartDataResponse = await _restaurantDataSource.cartDetails(token);
      cartDataRes = cartDataResponse[1];
      if (cartDataRes.cartitems.length != 0) {
        for (int i = 0; i < cartDataRes.cartitems.length; i++) {
          if (cartDataRes.cartitems[i].fooditem != null)
            purchasedItems.add(new IoId(
                fooditem: cartDataRes.cartitems[i].fooditem.id,
                itemName: cartDataRes.cartitems[i].fooditem.name,
                count: cartDataRes.cartitems[i].count,
                itemPrice: cartDataRes.cartitems[i].fooditem.price));
        }
      }
      calculation();
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  calculation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dis = cartDataRes.restaurantDiscount;
    discountRes = (cartDataRes.total - cartDataRes.total * dis / 100);
    print('restaurant discount is d$dis');
    if (discountRes - deduction >= double.parse(cartDataRes.minCart))
      additional = double.parse(cartDataRes.minCharge);
    else
      additional = double.parse(cartDataRes.maxCharge);
    setState(() {
      priceIncludingTax = (discountRes -
          deduction +
          additional +
          ((discountRes - deduction + additional) *
              (double.parse(cartDataRes.tax) / 100)));
      print(priceIncludingTax);
    });
    setState(() {
      _isLoading = false;
    });
  }

  _handleOrderConfirmation() async {
    setState(() {
      _isLoading = true;
    });
    var currentTime = new DateTime.now();
    String slotTime;

    slotTime = Jiffy({
      "year": currentTime.year,
      "month": currentTime.month,
      "day": currentTime.day,
      "hour": currentTime.hour,
      "minute": currentTime.minute,
      "second": currentTime.second,
    }).format();
    // slotTime = "2020-08-25T21:40:31.000";
    print(slotTime);
    print(
        "oooooooooooooooooooooooorrrrrrrrrrrrrrrrrrddddddddddeeeeeeeeeeeeeer         $priceIncludingTax");

    final OrderRequestModel finalOrder = new OrderRequestModel(
        cartDataRes.cartitems[0].fooditem.restaurant.id,
        priceIncludingTax,
        addressId.toString(),
        double.parse(
          cartDataRes.tax,
        ),
        slotTime,
        purchasedItems,
        coupon == null ? "xxx" : coupon.code,
        instructionController.text,
        cartDataRes.maxCharge,
        cartDataRes.minCharge,
        cartDataRes.minCart);
    print('coupon name before order confirmation${finalOrder.coupon}');
    _orderConfirmationRes =
        await _orderDataSource.orderConfirmation(token, finalOrder);
    if (_orderConfirmationRes['status']) {
      _isLoading = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentSelectPage(
                priceIncludingTax, _orderConfirmationRes['id'])),
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      if (_orderConfirmationRes['error_code'].toString() == "EO1")
        Utils.showSnackBar(_key, _orderConfirmationRes['message']);
      else
        Utils.showSnackBar(_key, _orderConfirmationRes['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      key: _key,
      appBar: CloseAppBar(),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(greenBellyColor),
              ),
            )
          : Stack(
              children: <Widget>[
                _buildDetailsUi(context),
              ],
            ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              _handleOrderConfirmation();
            });
          }
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
                          choosePaymentMethod,
                          style: CustomFontStyle.RegularTextStyle(whiteColor),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "₹ " + (priceIncludingTax).toInt().toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: whiteColor,
                                fontWeight: FontWeight.w300,
                                fontFamily: "NotoSansJP"),
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsUi(context) {
    return Form(
        key: _formKey,
        autovalidate: _validate,
        child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      cartDataRes.cartitems[0].fooditem.restaurant.name,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'NotoSansJP',
                        color: blackColor,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      // cartDataRes.cartitems[0].fooditem.restaurant.campus, uncommment
                      '',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'NotoSansJP-Bold',
                        color: disabledGrey,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Cooking Instructions',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'NotoSansJP',
                        color: blackColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: cloudsColor,
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: instructionController,
                          decoration: new InputDecoration.collapsed(
                              hintText: 'Cooking Instructions (optional)'),
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontFamily: 'MontserratMedium',
                            color: blackColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Offers',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'NotoSansJP-Bold',
                        color: disabledGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final OfferModel copn = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfferSelect(cartDataRes
                                  .cartitems[0].fooditem.restaurant.id),
                            ));
                        setState(() {
                          coupon = copn;
                        });
                        print('coupon restaurant ${coupon.restaurant}');
                        print(
                            'coupon restaurant ${cartDataRes.cartitems[0].fooditem.restaurant.id}');
                        if (coupon.restaurant == 0 ||
                            coupon.restaurant ==
                                cartDataRes
                                    .cartitems[0].fooditem.restaurant.id) {
                          if (discountRes >= coupon.mincartvalue &&
                              copn != null) {
                            print('is percentage ${coupon.ispercentage}');
                            if (coupon.ispercentage) {
                              final deduct =
                                  (discountRes) * coupon.discount / 100;
                              if (deduct >= coupon.maxdiscountvalue) {
                                setState(() {
                                  deduction = coupon.maxdiscountvalue;
                                });
                              } else {
                                setState(() {
                                  deduction = deduct;
                                });
                              }
                            } else {
                              setState(() {
                                deduction = coupon.discount;
                              });
                            }
                            calculation();
                            print('ddddddedduccctiion   $deduction');
                          }
                        } else {
                          Utils.showSnackBar(
                              _key, "Coupon not valid for this Restaurant");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            MyIcon.offerbutton,
                            size: 14,
                          ),
                          Text(
                            'Select a Promo Code',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontFamily: 'NotoSansJP-Bold',
                              color: Colors.blue[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'View Offers',
                            style: TextStyle(
                              fontFamily: 'NotoSansJP-Bold',
                              color: Colors.red[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          orderContents,
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontFamily: 'NotoSansJP',
                            color: blackColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => RestaurantDetailPage(
                            //           cartDataRes.cartitems[0].fooditem
                            //               .restaurant.id)),
                            // );
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add Items",
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
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: cartDataRes.cartitems.length == null
                                ? 0
                                : cartDataRes.cartitems.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          cartDataRes.cartitems[index].fooditem
                                                  .name +
                                              "   x " +
                                              cartDataRes.cartitems[index].count
                                                  .toString(),
                                          style: TextStyle(color: blackColor),
                                        ),
                                      ),
                                      Text(
                                        "₹ " +
                                            (cartDataRes.cartitems[index]
                                                        .count *
                                                    cartDataRes.cartitems[index]
                                                        .fooditem.price)
                                                .toString(),
                                        style: TextStyle(color: blackColor),
                                      )
                                    ],
                                  ),
                                ))),
                    Container(
                      height: 1,
                      color: cloudsColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              subTotal,
                              style: TextStyle(color: blackColor),
                            ),
                            Text(
                              "₹ " + cartDataRes.total.toString(),
                              style: TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Restaurant Offer',
                              style: TextStyle(color: blackColor),
                            ),
                            Text(
                              "₹ " +
                                  (cartDataRes.total - discountRes).toString(),
                              style: TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tax',
                              style: TextStyle(color: blackColor),
                            ),
                            Text(
                              "₹ " +
                                  ((discountRes - deduction + additional) *
                                          (double.parse(cartDataRes.tax) / 100))
                                      .toInt()
                                      .toString(),
                              style: TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Additional Charges',
                              style: TextStyle(color: blackColor),
                            ),
                            Text(
                              "₹ " + additional.toString(),
                              style: TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                        deduction != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Coupon Offer',
                                    style: TextStyle(color: blackColor),
                                  ),
                                  Text(
                                    " - ₹ " + deduction.toString(),
                                    style: TextStyle(color: blackColor),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              totalAmount,
                              style: TextStyle(color: blackColor),
                            ),
                            Text(
                              "₹ " +
                                  (priceIncludingTax).toInt().toString() +
                                  " " +
                                  taxIncluding,
                              style: TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ]));
  }
}

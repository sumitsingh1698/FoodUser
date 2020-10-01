import 'package:Belly/data/razorpay_data.dart';
import 'package:Belly/ui/screens/razorpaypage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/String.dart';
import 'package:Belly/data/payment_method_data.dart';
import 'package:Belly/ui/screens/order_created_sucess_page.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/utils/show_snackbar.dart';

class PaymentSelectPage extends StatefulWidget {
  final double totalPrice;
  final orderId;

  PaymentSelectPage(this.totalPrice, this.orderId);

  @override
  _PaymentSelectPage createState() => _PaymentSelectPage();
}

class _PaymentSelectPage extends State<PaymentSelectPage> {
  bool _loader = false;
  final _key = new GlobalKey<ScaffoldState>();
  String _radioValue;
  String _paymentMethod;
  PaymentMethodData _paymentMethodData = new PaymentMethodData();
  bool _buttonEnabled = true;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  bool isCvvFocused = false;
  String userToken;
  RazorPayPaymentData razorpayDataSource = new RazorPayPaymentData();

  @override
  void initState() {
    super.initState();
    setState(() {
      _radioValue = "paybycash";
    });
    _paymentMethod = _radioValue;
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userToken = prefs.getString('token');
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  _handlePaymentMethod() async {
    // if user chooses pay by cash call the api to set the payment method as by cash in backend
    if (_paymentMethod == "paybycash") {
      showLoading();
      try {
        setState(() {
          _buttonEnabled = false;
        });
        final codresponse =
            await _paymentMethodData.makeCOD(userToken, widget.orderId);
        setState(() {
          _loader = false;
          _buttonEnabled = true;
        });
        print(codresponse["message"]);
        if (codresponse['status']) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderCreationSuccessPage()),
          );
        }
      } on Exception catch (error) {
        print(error);
        return null;
      }
    } else if (_paymentMethod == "payonline") {
      _buttonEnabled ? _handleOnlinePayment() : null;
    }
  }

  void setError(dynamic error) {
    // display the error message using a snackbar
    print(error.toString());
    hideLoading();
    Utils.showSnackBar(_key, error.toString());
    setState(() {
      _buttonEnabled = true;
    });
  }

  void showLoading() {
    setState(() {
      _loader = true;
    });
  }

  void hideLoading() {
    setState(() {
      _loader = false;
    });
  }

  _handleOnlinePayment() async {
    razorpayDataSource
        .makeRazorPayment(userToken, widget.orderId)
        .then((response) {
      hideLoading();
      if (response['status']) {
        print('response response response $response');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RazorpayPage(
            razId: response['response']['id'],
            amount: response['response']['amount'],
            orderId: widget.orderId,
          );
        }));
      } else {
        print('errrrrrror');
        print(response);
        // Utils.showSnackBar(_key, response[1]);
        // enable the button if an attempt fails
        setState(() {
          _buttonEnabled = true;
        });
      }
    }).catchError((onError) {
      setError(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: ""),
      body: Stack(children: <Widget>[
        Opacity(
            opacity: _loader ? 0.8 : 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        selectPaymentMethod,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'NotoSansJP',
                          color: blackColor,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: cloudsColor,
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          children: <Widget>[
                            Radio(
                              activeColor: blackColor,
                              value: 'paybycash',
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: cloudsColor,
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Text(
                                  payByCash,
                                  style: CustomFontStyle.regularFormTextStyle(
                                      blackColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: cloudsColor,
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          children: <Widget>[
                            Radio(
                              activeColor: blackColor,
                              value: 'payonline',
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: cloudsColor,
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Text(
                                  payByCard,
                                  style: CustomFontStyle.regularFormTextStyle(
                                      blackColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // display card widget if the payment method chosen is by card
                      _paymentMethod == "payonline"
                          ? Container()
                          // _stripeWidget()
                          : Container()
                    ],
                  ),
                ),
              ),
            )),
        // a black overlay is drawn over the screen to indicate loading
        _loader
            ? Opacity(
                opacity: _loader ? 1.0 : 0,
                child: Container(
                  color: blackColor.withOpacity(0.5),
                ),
              )
            : SizedBox(),
        _loader
            ? Opacity(
                opacity: _loader ? 1.0 : 0,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                ),
              )
            : SizedBox()
      ]),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'paybycash':
          _paymentMethod = value;
          break;
        case 'payonline':
          _paymentMethod = value;
          break;
        default:
          _paymentMethod = null;
      }
    });
  }

  Widget _buildBottomButton(context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          onTap: () {
            _handlePaymentMethod();
          },
          child: Container(
            decoration: BoxDecoration(
              color: blackBellyColor,
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
                            order,
                            style: CustomFontStyle.mediumTextStyle(
                                whiteBellyColor),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "₹ " + widget.totalPrice.toInt().toString(),
                              style: CustomFontStyle.mediumTextStyle(
                                  whiteBellyColor),
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
        ));
  }
}

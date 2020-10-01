import 'package:Belly/constants/Style.dart';
import 'package:Belly/ui/screens/order_created_sucess_page.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RazorpayPage extends StatefulWidget {
  final String razId;
  final int amount;
  final String orderId;

  RazorpayPage({this.razId, this.amount, this.orderId});

  @override
  _RazorpayPageState createState() => _RazorpayPageState();
}

class _RazorpayPageState extends State<RazorpayPage> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  String text = 'RazorPay';
  NetworkUtil _networkUtil = NetworkUtil();
  String payverifyUrl = BaseUrl().mainUrl + 'verifypayment/';
  String token;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomCloseAppBar(
          title: 'Razorpay',
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text(text, style: CustomFontStyle.mediumTextStyle(Colors.black)),
            _loading
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : SizedBox.shrink()
          ],
        )));
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getToken();
    openCheckout();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tkn = prefs.getString('token');
    setState(() {
      token = tkn;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_9hTfIvw3mROOrj',
      'amount': widget.amount, //in the smallest currency sub-unit.
      'name': '',
      // _userProvider.user.firstName,
      'order_id': widget.razId, // Generate order_id using Orders API
      'description': '',
      'timeout': 300, // in seconds
      'prefill': {
        'contact': '',
        //  _userProvider.user.phone,
        'email': '',
        //  _userProvider.user.email
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      text = "Don't Exit !";
      _loading = true;
    });
    var body = {
      "id": widget.orderId,
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
    };
    print('body is $body');
    print('token for $token');
    final res = await _networkUtil.addItemToCart(payverifyUrl, token, body);

    if (res['status']) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderCreationSuccessPage()),
      );
    } else {
      setState(() {
        text = 'Payment Failed,Try Again';
        _loading = false;
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      text = 'Payment Failed,Try Again';
    });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }
}

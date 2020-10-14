import 'package:Belly/constants/Color.dart';
import 'package:Belly/constants/Style.dart';
import 'package:Belly/models/offerModel.dart';
import 'package:Belly/presentation/custom_icons_icons.dart';
import 'package:Belly/ui/widgets/custom_close_app_bar.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';
import 'package:Belly/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferSelect extends StatefulWidget {
  final int id;
  OfferSelect(this.id);
  @override
  _OfferSelectState createState() => _OfferSelectState();
}

class _OfferSelectState extends State<OfferSelect> {
  TextEditingController offerContrller = TextEditingController();
  NetworkUtil _networkUtil = NetworkUtil();
  final _key = new GlobalKey<ScaffoldState>();
  OfferModel offerModel;
  bool coupon = false;
  bool loading = true;
  String token;
  List<OfferModel> offers = [];
  getOfferData() async {
    setState(() {
      coupon = false;
    });
    Map _body = {
      'coupon': '${offerContrller.text}',
      'restaurant': widget.id.toString()
    };
    String url = BaseUrl().mainUrl + 'checkcoupon/';
    final res = await _networkUtil.checkCoupon(url, token, _body);

    Utils.showSnackBar(_key, res["message"]);
    if (res['status']) {
      offerModel = OfferModel.fromJson(res);
      setState(() {
        coupon = true;
      });
    }
    print(res);
  }

  getCouponList() async {
    print('gggggggettttttttttDDDDDDDaaata');
    String baseurl = BaseUrl().mainUrl;
    String url = baseurl + 'offers/';
    final List res = await _networkUtil.getOffers(url, token);
    List<OfferModel> temp = res.map((e) => OfferModel.fromJson(e)).toList();
    setState(() {
      offers = temp;
      loading = false;
    });
    print(res);
    print('ressssssssssssss');
  }

  @override
  void initState() {
    super.initState();
    sharedprefs();
  }

  sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getCouponList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomCloseAppBar(
        title: "Coupon Code",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[500]),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(
                      child: TextFormField(
                        onEditingComplete: () {
                          getOfferData();
                        },
                        controller: offerContrller,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 18),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[500],
                              size: 24,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                offerContrller.clear();
                              },
                              icon: Icon(Icons.clear),
                              color: Colors.grey[500],
                              iconSize: 24,
                            ),
                            hintText: "Enter Your Coupon Code"),
                      ),
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              coupon ? couponBox(offerModel) : couponlist()
            ],
          ),
        ),
      ),
    );
  }

  Widget couponlist() {
    return loading
        ? CupertinoActivityIndicator()
        : offers.length == 0
            ? Container(
                child: Center(
                    child: Text(
                  "No Offer Found",
                  style: CustomFontStyle.RegularTextStyle(grey1Color),
                )),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return couponBox(offers[index]);
                });
  }

  Widget couponBox(OfferModel searchcoupon) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, searchcoupon),
      child: Container(
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        MyIcon.offerbutton,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          searchcoupon.description,
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontFamily: 'MontserratMedium',
                            color: Colors.green,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Max Discount: ${searchcoupon.maxdiscountvalue}',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: 'MontserratMedium',
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Min Cart Valure Required: ${searchcoupon.mincartvalue}',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: 'MontserratMedium',
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'APPLY COUPON',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'MontserratMedium',
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
